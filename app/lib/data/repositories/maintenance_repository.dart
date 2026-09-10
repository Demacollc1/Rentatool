import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../sync/sync_service.dart';
import 'catalog_repository.dart';

/// Orden con su unidad y producto para pintar pantallas.
class OrderView {
  const OrderView(this.order, this.asset, this.model);

  final MaintenanceOrder order;
  final Asset? asset;
  final ToolModel? model;
}

/// Preventivo vencido: qué plan y qué unidad lo deben.
class DuePlan {
  const DuePlan(this.plan, this.asset, this.model, this.reason);

  final MaintenancePlan plan;
  final Asset asset;
  final ToolModel? model;
  final String reason; // "8 días vencido" / "12 h sobre el plan"
}

/// F4: cuarentena → orden de mantenimiento (costos + horómetro) →
/// ubicación definitiva. Los preventivos se vigilan por plan.
class MaintenanceRepository {
  MaintenanceRepository(this._db, this._sync, this._catalog);

  final AppDatabase _db;
  final SyncService _sync;
  final CatalogRepository _catalog;

  // ---------------- órdenes ----------------

  Stream<List<OrderView>> watchOrders({String? status}) {
    final q = _db.select(_db.maintenanceOrders)
      ..where((o) => o.deletedAt.isNull())
      ..orderBy([(o) => OrderingTerm.desc(o.openedAt)]);
    if (status != null) q.where((o) => o.status.equals(status));
    return q.watch().asyncMap((orders) async {
      final out = <OrderView>[];
      for (final o in orders) {
        final asset = await _catalog.getAsset(o.assetId);
        final model = asset == null
            ? null
            : await _catalog.getModel(asset.toolModelId);
        out.add(OrderView(o, asset, model));
      }
      return out;
    });
  }

  Future<MaintenanceOrder?> openOrderFor(String assetId) =>
      (_db.select(_db.maintenanceOrders)
            ..where((o) =>
                o.assetId.equals(assetId) &
                o.status.equals('open') &
                o.deletedAt.isNull()))
          .getSingleOrNull();

  /// Abre una orden y pasa la unidad a mantenimiento (kardex).
  /// Devuelve null si ok, o el motivo.
  Future<String?> openOrder({
    required String assetId,
    String kind = 'revision',
    String? contractRef,
    String? notes,
  }) async {
    final asset = await _catalog.getAsset(assetId);
    if (asset == null) return 'Unidad no encontrada';
    if (asset.status == 'rented') {
      return '${asset.assetTag} está rentada: recíbela primero';
    }
    final abierta = await openOrderFor(assetId);
    if (abierta != null) {
      return '${asset.assetTag} ya tiene una orden abierta';
    }
    final rowId = const Uuid().v4();
    final now = DateTime.now();
    await _db.into(_db.maintenanceOrders).insert(
          MaintenanceOrdersCompanion.insert(
            id: rowId,
            assetId: assetId,
            kind: Value(kind),
            contractRef: Value(contractRef),
            openedAt: now,
            notes: Value(notes),
            updatedAt: Value(now),
          ),
        );
    await _enqueueOrder(rowId);
    if (asset.status != 'maintenance') {
      await _catalog.setAssetStatus(assetId, 'maintenance',
          contractRef: contractRef, notes: notes);
    }
    return null;
  }

  /// Cierra la orden: costos + horómetro; la unidad sale a su
  /// ubicación definitiva como disponible (o de baja si no tiene
  /// arreglo). Devuelve null si ok.
  Future<String?> closeOrder(
    String orderId, {
    double laborCost = 0,
    double partsCost = 0,
    double otherCost = 0,
    double depreciationCost = 0,
    double? hoursMeter,
    String? locationId,
    String condition = 'good',
    bool retire = false,
    String? notes,
  }) async {
    final order = await (_db.select(_db.maintenanceOrders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
    if (order == null) return 'Orden no encontrada';
    if (order.status == 'done') return 'La orden ya está cerrada';
    final asset = await _catalog.getAsset(order.assetId);
    if (asset == null) return 'Unidad no encontrada';
    if (hoursMeter != null && hoursMeter < asset.hoursMeter) {
      return 'El horómetro no puede retroceder '
          '(actual ${asset.hoursMeter.toStringAsFixed(1)} h)';
    }

    final now = DateTime.now();
    final total =
        laborCost + partsCost + otherCost + depreciationCost;
    await (_db.update(_db.maintenanceOrders)
          ..where((o) => o.id.equals(orderId)))
        .write(MaintenanceOrdersCompanion(
      status: const Value('done'),
      closedAt: Value(now),
      hoursMeter:
          hoursMeter == null ? const Value.absent() : Value(hoursMeter),
      laborCost: Value(laborCost),
      partsCost: Value(partsCost),
      otherCost: Value(otherCost),
      depreciationCost: Value(depreciationCost),
      totalCost: Value(total),
      notes: notes == null ? const Value.absent() : Value(notes),
      updatedAt: Value(now),
    ));
    await _enqueueOrder(orderId);

    // Unidad: horómetro, última revisión y condición.
    await (_db.update(_db.assets)
          ..where((a) => a.id.equals(order.assetId)))
        .write(AssetsCompanion(
      hoursMeter:
          hoursMeter == null ? const Value.absent() : Value(hoursMeter),
      lastMaintenanceAt: Value(now),
      condition: Value(condition),
      updatedAt: Value(now),
    ));
    if (retire) {
      await _catalog.setAssetStatus(order.assetId, 'retired',
          notes: notes);
    } else {
      await _catalog.setAssetStatus(order.assetId, 'available',
          notes: notes);
      if (locationId != null) {
        await _catalog.moveAsset(order.assetId, locationId);
      }
    }
    return null;
  }

  /// Horas estimadas por fórmula cuando no hay horómetro físico:
  /// acumulado + días desde la última revisión × horas/día.
  double estimatedHours(Asset asset, {double hoursPerDay = 6}) {
    final desde = asset.lastMaintenanceAt ?? asset.purchaseDate;
    if (desde == null) return asset.hoursMeter;
    final dias = DateTime.now().difference(desde).inDays;
    return asset.hoursMeter + (dias > 0 ? dias * hoursPerDay : 0);
  }

  // ---------------- planes preventivos ----------------

  Stream<List<MaintenancePlan>> watchPlans(String toolModelId) =>
      (_db.select(_db.maintenancePlans)
            ..where((p) =>
                p.toolModelId.equals(toolModelId) &
                p.deletedAt.isNull()))
          .watch();

  Future<String> savePlan({
    String? id,
    required String toolModelId,
    required String name,
    int? everyDays,
    double? everyHours,
    String? notes,
  }) async {
    final rowId = id ?? const Uuid().v4();
    final now = DateTime.now();
    await _db.into(_db.maintenancePlans).insertOnConflictUpdate(
          MaintenancePlansCompanion(
            id: Value(rowId),
            toolModelId: Value(toolModelId),
            name: Value(name),
            everyDays: Value(everyDays),
            everyHours: Value(everyHours),
            notes: Value(notes),
            updatedAt: Value(now),
          ),
        );
    await _sync.enqueue(
        table: 'maintenance_plans',
        rowId: rowId,
        op: 'upsert',
        row: {
          'id': rowId,
          'tool_model_id': toolModelId,
          'name': name,
          'every_days': everyDays,
          'every_hours': everyHours,
          'notes': notes,
          'updated_at': isoTs(now),
          'deleted_at': null,
        });
    return rowId;
  }

  Future<void> deletePlan(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.maintenancePlans)
          ..where((p) => p.id.equals(id)))
        .write(MaintenancePlansCompanion(
      deletedAt: Value(now),
      updatedAt: Value(now),
    ));
    final p = await (_db.select(_db.maintenancePlans)
          ..where((x) => x.id.equals(id)))
        .getSingle();
    await _sync.enqueue(
        table: 'maintenance_plans',
        rowId: id,
        op: 'upsert',
        row: {
          'id': p.id,
          'tool_model_id': p.toolModelId,
          'name': p.name,
          'every_days': p.everyDays,
          'every_hours': p.everyHours,
          'notes': p.notes,
          'updated_at': isoTs(now),
          'deleted_at': isoTs(now),
        });
  }

  /// Preventivos vencidos: por días desde la última revisión o por
  /// horas de trabajo desde la última orden cerrada.
  Future<List<DuePlan>> duePreventives() async {
    final plans = await (_db.select(_db.maintenancePlans)
          ..where((p) => p.deletedAt.isNull()))
        .get();
    if (plans.isEmpty) return const [];
    final byModel = <String, List<MaintenancePlan>>{};
    for (final p in plans) {
      byModel.putIfAbsent(p.toolModelId, () => []).add(p);
    }
    final assets = await (_db.select(_db.assets)
          ..where((a) =>
              a.deletedAt.isNull() &
              a.status.isNotIn(['retired', 'rented'])))
        .get();
    final out = <DuePlan>[];
    for (final a in assets) {
      final planes = byModel[a.toolModelId];
      if (planes == null) continue;
      if (await openOrderFor(a.id) != null) continue;
      final model = await _catalog.getModel(a.toolModelId);
      // Horas en la última orden cerrada (base del contador).
      final lastDone = await (_db.select(_db.maintenanceOrders)
            ..where((o) =>
                o.assetId.equals(a.id) &
                o.status.equals('done') &
                o.deletedAt.isNull())
            ..orderBy([(o) => OrderingTerm.desc(o.closedAt)])
            ..limit(1))
          .getSingleOrNull();
      final baseHours = lastDone?.hoursMeter ?? 0;
      final baseDate =
          a.lastMaintenanceAt ?? a.purchaseDate ?? a.updatedAt;
      for (final p in planes) {
        if (p.everyDays != null) {
          final dias = DateTime.now().difference(baseDate).inDays;
          if (dias >= p.everyDays!) {
            out.add(DuePlan(p, a, model,
                '${dias - p.everyDays!} días vencido'));
            continue;
          }
        }
        if (p.everyHours != null) {
          final horas = a.hoursMeter - baseHours;
          if (horas >= p.everyHours!) {
            out.add(DuePlan(p, a, model,
                '${(horas - p.everyHours!).toStringAsFixed(0)} h '
                'sobre el plan'));
          }
        }
      }
    }
    return out;
  }

  // ---------------- sync ----------------

  Future<void> _enqueueOrder(String id) async {
    final o = await (_db.select(_db.maintenanceOrders)
          ..where((x) => x.id.equals(id)))
        .getSingleOrNull();
    if (o == null) return;
    await _sync.enqueue(
        table: 'maintenance_orders',
        rowId: id,
        op: 'upsert',
        row: {
          'id': o.id,
          'asset_id': o.assetId,
          'kind': o.kind,
          'status': o.status,
          'contract_ref': o.contractRef,
          'opened_at': isoTs(o.openedAt),
          'closed_at': isoTsN(o.closedAt),
          'hours_meter': o.hoursMeter,
          'labor_cost': o.laborCost,
          'parts_cost': o.partsCost,
          'other_cost': o.otherCost,
          'depreciation_cost': o.depreciationCost,
          'total_cost': o.totalCost,
          'notes': o.notes,
          'updated_at': isoTs(o.updatedAt),
          'deleted_at': isoTsN(o.deletedAt),
        });
  }
}

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>(
    (ref) => MaintenanceRepository(
        ref.watch(appDatabaseProvider),
        ref.watch(syncServiceProvider),
        ref.watch(catalogRepositoryProvider)));

final maintenanceOrdersProvider = StreamProvider.autoDispose
    .family<List<OrderView>, String?>((ref, status) => ref
        .watch(maintenanceRepositoryProvider)
        .watchOrders(status: status));

final modelPlansProvider = StreamProvider.autoDispose
    .family<List<MaintenancePlan>, String>((ref, modelId) =>
        ref.watch(maintenanceRepositoryProvider).watchPlans(modelId));

final duePreventivesProvider =
    FutureProvider.autoDispose<List<DuePlan>>((ref) =>
        ref.watch(maintenanceRepositoryProvider).duePreventives());
