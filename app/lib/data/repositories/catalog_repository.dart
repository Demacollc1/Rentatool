import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../sync/sync_service.dart';

/// Catálogo de renta: modelos de herramienta, unidades físicas,
/// consumibles y el kardex de movimientos.
class CatalogRepository {
  CatalogRepository(this._db, this._sync);

  final AppDatabase _db;
  final SyncService _sync;

  // ═══════════ Modelos ═══════════

  Stream<List<ToolModel>> watchModels({String query = ''}) {
    final q = _db.select(_db.toolModels)
      ..where((m) => m.deletedAt.isNull())
      ..orderBy([(m) => OrderingTerm.asc(m.name)]);
    if (query.trim().isNotEmpty) {
      final like = '%${query.trim()}%';
      q.where((m) =>
          m.name.like(like) |
          m.description.like(like) |
          m.brand.like(like) |
          m.supplierCode.like(like));
    }
    return q.watch();
  }

  Future<ToolModel?> getModel(String id) =>
      (_db.select(_db.toolModels)..where((m) => m.id.equals(id)))
          .getSingleOrNull();

  Future<String> saveModel({
    String? id,
    required String name,
    String? spec,
    String line = 'ind',
    String? brand,
    String? supplierCode,
    String? description,
    String? categoryId,
    double listCost = 0,
    double? rateHalfDay,
    double? rateDay,
    double? rateWeek,
    double? rateMonth,
    double b87Qty = 0,
    bool published = false,
    String? notes,
    String? ratCode,
    String? canonicalCode,
    String? canonicalName,
    String? variant,
    String? supplierId,
  }) async {
    final rowId = id ?? const Uuid().v4();
    await _db.into(_db.toolModels).insertOnConflictUpdate(
          ToolModelsCompanion.insert(
            id: rowId,
            name: name,
            spec: Value(spec),
            line: Value(line),
            brand: Value(brand),
            supplierCode: Value(supplierCode),
            description: Value(description),
            categoryId: Value(categoryId),
            listCost: Value(listCost),
            rateHalfDay: Value(rateHalfDay),
            rateDay: Value(rateDay),
            rateWeek: Value(rateWeek),
            rateMonth: Value(rateMonth),
            b87Qty: Value(b87Qty),
            published: Value(published),
            notes: Value(notes),
            ratCode: Value(ratCode),
            canonicalCode: Value(canonicalCode),
            canonicalName: Value(canonicalName),
            variant: Value(variant),
            supplierId: Value(supplierId),
            updatedAt: Value(DateTime.now()),
          ),
        );
    await _enqueueModel(rowId);
    return rowId;
  }

  /// Siguiente código Rent a Tool para un canónico: AAQ-001, AAQ-002…
  Future<String> nextRatCode(String canonicalCode) async {
    final like = '$canonicalCode-%';
    final rows = await (_db.select(_db.toolModels)
          ..where((m) => m.ratCode.like(like)))
        .get();
    var maxSeq = 0;
    for (final m in rows) {
      final parts = m.ratCode?.split('-');
      final n = parts == null ? null : int.tryParse(parts.last);
      if (n != null && n > maxSeq) maxSeq = n;
    }
    return '$canonicalCode-${(maxSeq + 1).toString().padLeft(3, '0')}';
  }

  Future<void> _enqueueModel(String id) async {
    final m = await getModel(id);
    if (m == null) return;
    await _sync
        .enqueue(table: 'tool_models', rowId: id, op: 'upsert', row: {
      'id': m.id,
      'name': m.name,
      'spec': m.spec,
      'line': m.line,
      'brand': m.brand,
      'supplier_code': m.supplierCode,
      'description': m.description,
      'category_id': m.categoryId,
      'list_cost': m.listCost,
      'rate_half_day': m.rateHalfDay,
      'rate_day': m.rateDay,
      'rate_week': m.rateWeek,
      'rate_month': m.rateMonth,
      'b87_qty': m.b87Qty,
      'published': m.published,
      'notes': m.notes,
      'rat_code': m.ratCode,
      'canonical_code': m.canonicalCode,
      'canonical_name': m.canonicalName,
      'variant': m.variant,
      'supplier_id': m.supplierId,
      'updated_at': isoTs(m.updatedAt),
      'deleted_at': isoTsN(m.deletedAt),
    });
  }

  // ═══════════ Unidades (assets) ═══════════

  Stream<List<Asset>> watchAssets({String? modelId}) {
    final q = _db.select(_db.assets)
      ..where((a) => a.deletedAt.isNull())
      ..orderBy([(a) => OrderingTerm.asc(a.assetTag)]);
    if (modelId != null) q.where((a) => a.toolModelId.equals(modelId));
    return q.watch();
  }

  Future<Asset?> getAsset(String id) =>
      (_db.select(_db.assets)..where((a) => a.id.equals(id)))
          .getSingleOrNull();

  /// Siguiente correlativo DEM-0001, DEM-0002…
  Future<String> nextAssetTag() async {
    final countExp = _db.assets.id.count();
    final q = _db.selectOnly(_db.assets)..addColumns([countExp]);
    final n = (await q.getSingle()).read(countExp) ?? 0;
    return 'DEM-${(n + 1).toString().padLeft(4, '0')}';
  }

  /// Alta de unidad física: crea el asset + movement `intake`.
  Future<String> createAsset({
    required String toolModelId,
    required String assetTag,
    String? serial,
    String? locationId,
    double purchaseCost = 0,
    DateTime? purchaseDate,
    String condition = 'new',
    String? notes,
    String? supplierId,
    String? invoiceNumber,
    String? brand,
    String? mfrModel,
  }) async {
    final rowId = const Uuid().v4();
    await _db.into(_db.assets).insert(AssetsCompanion.insert(
          id: rowId,
          toolModelId: toolModelId,
          assetTag: assetTag,
          serial: Value(serial),
          locationId: Value(locationId),
          purchaseCost: Value(purchaseCost),
          purchaseDate: Value(purchaseDate),
          condition: Value(condition),
          notes: Value(notes),
          supplierId: Value(supplierId),
          invoiceNumber: Value(invoiceNumber),
          brand: Value(brand),
          mfrModel: Value(mfrModel),
          updatedAt: Value(DateTime.now()),
        ));
    await _enqueueAsset(rowId);
    await _recordMovement(
      assetId: rowId,
      kind: 'intake',
      toLocationId: locationId,
      notes: 'Ingreso de unidad $assetTag',
    );
    return rowId;
  }

  /// Mueve una unidad de ubicación (kardex `transfer`).
  Future<void> moveAsset(String id, String? toLocationId) async {
    final asset = await getAsset(id);
    if (asset == null) return;
    await (_db.update(_db.assets)..where((a) => a.id.equals(id))).write(
      AssetsCompanion(
        locationId: Value(toLocationId),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _enqueueAsset(id);
    await _recordMovement(
      assetId: id,
      kind: 'transfer',
      fromLocationId: asset.locationId,
      toLocationId: toLocationId,
    );
  }

  /// Cambia el estado de la unidad registrando el movimiento acorde.
  Future<void> setAssetStatus(String id, String status,
      {String? notes}) async {
    final asset = await getAsset(id);
    if (asset == null || asset.status == status) return;
    await (_db.update(_db.assets)..where((a) => a.id.equals(id))).write(
      AssetsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _enqueueAsset(id);
    final kind = switch (status) {
      'rented' => 'rent_out',
      'maintenance' => 'maintenance_out',
      'retired' => 'retire',
      'available' when asset.status == 'rented' => 'rent_return',
      'available' when asset.status == 'maintenance' =>
        'maintenance_return',
      _ => 'adjust',
    };
    await _recordMovement(assetId: id, kind: kind, notes: notes);
  }

  Future<void> _enqueueAsset(String id) async {
    final a = await getAsset(id);
    if (a == null) return;
    await _sync.enqueue(table: 'assets', rowId: id, op: 'upsert', row: {
      'id': a.id,
      'tool_model_id': a.toolModelId,
      'asset_tag': a.assetTag,
      'serial': a.serial,
      'status': a.status,
      'condition': a.condition,
      'location_id': a.locationId,
      'purchase_date': a.purchaseDate?.toUtc().toIso8601String(),
      'purchase_cost': a.purchaseCost,
      'notes': a.notes,
      'supplier_id': a.supplierId,
      'invoice_number': a.invoiceNumber,
      'brand': a.brand,
      'mfr_model': a.mfrModel,
      'updated_at': isoTs(a.updatedAt),
      'deleted_at': isoTsN(a.deletedAt),
    });
  }

  // ═══════════ Consumibles ═══════════

  Stream<List<Consumable>> watchConsumables({String query = ''}) {
    final q = _db.select(_db.consumables)
      ..where((c) => c.deletedAt.isNull())
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);
    if (query.trim().isNotEmpty) {
      final like = '%${query.trim()}%';
      q.where((c) => c.name.like(like) | c.code.like(like));
    }
    return q.watch();
  }

  Future<String> saveConsumable({
    String? id,
    String? code,
    required String name,
    String unit = 'u',
    double cost = 0,
    double salePrice = 0,
    double stock = 0,
    double minStock = 0,
    String? locationId,
    String? canonicalCode,
    String? supplierId,
  }) async {
    final rowId = id ?? const Uuid().v4();
    await _db.into(_db.consumables).insertOnConflictUpdate(
          ConsumablesCompanion.insert(
            id: rowId,
            code: Value(code),
            name: name,
            unit: Value(unit),
            cost: Value(cost),
            salePrice: Value(salePrice),
            stock: Value(stock),
            minStock: Value(minStock),
            locationId: Value(locationId),
            canonicalCode: Value(canonicalCode),
            supplierId: Value(supplierId),
            updatedAt: Value(DateTime.now()),
          ),
        );
    final c = await (_db.select(_db.consumables)
          ..where((x) => x.id.equals(rowId)))
        .getSingle();
    await _sync
        .enqueue(table: 'consumables', rowId: rowId, op: 'upsert', row: {
      'id': c.id,
      'code': c.code,
      'name': c.name,
      'unit': c.unit,
      'cost': c.cost,
      'sale_price': c.salePrice,
      'stock': c.stock,
      'min_stock': c.minStock,
      'location_id': c.locationId,
      'canonical_code': c.canonicalCode,
      'supplier_id': c.supplierId,
      'updated_at': isoTs(c.updatedAt),
      'deleted_at': isoTsN(c.deletedAt),
    });
    return rowId;
  }

  Future<void> linkConsumable(String toolModelId, String consumableId,
      {String? id}) async {
    final rowId = id ?? const Uuid().v4();
    await _db.into(_db.toolModelConsumables).insertOnConflictUpdate(
          ToolModelConsumablesCompanion.insert(
            id: rowId,
            toolModelId: toolModelId,
            consumableId: consumableId,
            updatedAt: Value(DateTime.now()),
          ),
        );
    await _sync.enqueue(
        table: 'tool_model_consumables',
        rowId: rowId,
        op: 'upsert',
        row: {
          'id': rowId,
          'tool_model_id': toolModelId,
          'consumable_id': consumableId,
          'updated_at': isoTs(DateTime.now()),
          'deleted_at': null,
        });
  }

  Stream<List<Consumable>> watchModelConsumables(String modelId) {
    final join = _db.select(_db.consumables).join([
      innerJoin(
          _db.toolModelConsumables,
          _db.toolModelConsumables.consumableId
              .equalsExp(_db.consumables.id)),
    ])
      ..where(_db.toolModelConsumables.toolModelId.equals(modelId) &
          _db.consumables.deletedAt.isNull() &
          _db.toolModelConsumables.deletedAt.isNull());
    return join
        .watch()
        .map((rows) =>
            [for (final r in rows) r.readTable(_db.consumables)]);
  }

  // ═══════════ Kardex ═══════════

  Future<void> _recordMovement({
    String? assetId,
    String? consumableId,
    required String kind,
    double quantity = 1,
    String? fromLocationId,
    String? toLocationId,
    String? notes,
  }) async {
    final rowId = const Uuid().v4();
    final now = DateTime.now();
    await _db.into(_db.inventoryMovements).insert(
          InventoryMovementsCompanion.insert(
            id: rowId,
            assetId: Value(assetId),
            consumableId: Value(consumableId),
            kind: kind,
            quantity: Value(quantity),
            fromLocationId: Value(fromLocationId),
            toLocationId: Value(toLocationId),
            movedAt: now,
            notes: Value(notes),
            updatedAt: Value(now),
          ),
        );
    await _sync.enqueue(
        table: 'inventory_movements',
        rowId: rowId,
        op: 'upsert',
        row: {
          'id': rowId,
          'asset_id': assetId,
          'consumable_id': consumableId,
          'kind': kind,
          'quantity': quantity,
          'from_location_id': fromLocationId,
          'to_location_id': toLocationId,
          'moved_at': isoTs(now),
          'notes': notes,
          'updated_at': isoTs(now),
          'deleted_at': null,
        });
  }

  Stream<List<InventoryMovement>> watchMovements({String? assetId}) {
    final q = _db.select(_db.inventoryMovements)
      ..where((m) => m.deletedAt.isNull())
      ..orderBy([(m) => OrderingTerm.desc(m.movedAt)])
      ..limit(100);
    if (assetId != null) q.where((m) => m.assetId.equals(assetId));
    return q.watch();
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) =>
    CatalogRepository(
        ref.watch(appDatabaseProvider), ref.watch(syncServiceProvider)));

final toolModelsProvider = StreamProvider.autoDispose
    .family<List<ToolModel>, String>((ref, query) =>
        ref.watch(catalogRepositoryProvider).watchModels(query: query));

final toolModelProvider = FutureProvider.autoDispose
    .family<ToolModel?, String>(
        (ref, id) => ref.watch(catalogRepositoryProvider).getModel(id));

final modelAssetsProvider = StreamProvider.autoDispose
    .family<List<Asset>, String>((ref, modelId) => ref
        .watch(catalogRepositoryProvider)
        .watchAssets(modelId: modelId));

final allAssetsProvider = StreamProvider.autoDispose<List<Asset>>(
    (ref) => ref.watch(catalogRepositoryProvider).watchAssets());

final consumablesProvider = StreamProvider.autoDispose
    .family<List<Consumable>, String>((ref, query) => ref
        .watch(catalogRepositoryProvider)
        .watchConsumables(query: query));

final modelConsumablesProvider = StreamProvider.autoDispose
    .family<List<Consumable>, String>((ref, modelId) => ref
        .watch(catalogRepositoryProvider)
        .watchModelConsumables(modelId));

final assetMovementsProvider = StreamProvider.autoDispose
    .family<List<InventoryMovement>, String?>((ref, assetId) => ref
        .watch(catalogRepositoryProvider)
        .watchMovements(assetId: assetId));
