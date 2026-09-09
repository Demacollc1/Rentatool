import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../sync/sync_service.dart';
import 'catalog_repository.dart';

/// Contrato con su cliente y el total de sus líneas vivas.
class ContractView {
  const ContractView(this.contract, this.customer, this.total, this.lines);

  final RentalContract contract;
  final Customer? customer;
  final double total;
  final int lines;
}

/// Línea con la unidad y el producto para pintar la pantalla.
class LineView {
  const LineView(this.line, this.asset, this.model);

  final RentalLine line;
  final Asset? asset;
  final ToolModel? model;
}

class RentalRepository {
  RentalRepository(this._db, this._sync, this._catalog);

  final AppDatabase _db;
  final SyncService _sync;
  final CatalogRepository _catalog;

  // ---------------- clientes ----------------

  Stream<List<Customer>> watchCustomers({String query = ''}) {
    final q = _db.select(_db.customers)
      ..where((c) => c.deletedAt.isNull());
    if (query.trim().isNotEmpty) {
      final like = '%${query.trim()}%';
      q.where((c) => c.name.like(like) | c.idNumber.like(like));
    }
    q.orderBy([(c) => OrderingTerm.asc(c.name)]);
    return q.watch();
  }

  Future<String> saveCustomer({
    String? id,
    required String name,
    String? idNumber,
    String? phone,
    String? email,
    String? address,
  }) async {
    final rowId = id ?? const Uuid().v4();
    final now = DateTime.now();
    await _db.into(_db.customers).insertOnConflictUpdate(
          CustomersCompanion(
            id: Value(rowId),
            name: Value(name),
            idNumber: Value(idNumber),
            phone: Value(phone),
            email: Value(email),
            address: Value(address),
            updatedAt: Value(now),
          ),
        );
    await _sync.enqueue(table: 'customers', rowId: rowId, op: 'upsert', row: {
      'id': rowId,
      'name': name,
      'id_number': idNumber,
      'phone': phone,
      'email': email,
      'address': address,
      'updated_at': isoTs(now),
      'deleted_at': null,
    });
    return rowId;
  }

  // ---------------- obras del cliente ----------------

  Stream<List<CustomerSite>> watchSites(String customerId) =>
      (_db.select(_db.customerSites)
            ..where((s) =>
                s.customerId.equals(customerId) & s.deletedAt.isNull())
            ..orderBy([(s) => OrderingTerm.asc(s.name)]))
          .watch();

  Future<String> saveSite({
    String? id,
    required String customerId,
    required String name,
    String? address,
    String? contactName,
    String? contactPhone,
  }) async {
    final rowId = id ?? const Uuid().v4();
    final now = DateTime.now();
    await _db.into(_db.customerSites).insertOnConflictUpdate(
          CustomerSitesCompanion(
            id: Value(rowId),
            customerId: Value(customerId),
            name: Value(name),
            address: Value(address),
            contactName: Value(contactName),
            contactPhone: Value(contactPhone),
            updatedAt: Value(now),
          ),
        );
    await _sync
        .enqueue(table: 'customer_sites', rowId: rowId, op: 'upsert', row: {
      'id': rowId,
      'customer_id': customerId,
      'name': name,
      'address': address,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'updated_at': isoTs(now),
      'deleted_at': null,
    });
    return rowId;
  }

  // ---------------- contratos ----------------

  /// Siguiente correlativo CTR-0001 (por máximo local, igual que DEM-).
  Future<String> nextContractNumber() async {
    final rows = await _db.select(_db.rentalContracts).get();
    var max = 0;
    for (final r in rows) {
      final m = RegExp(r'^CTR-(\d+)$').firstMatch(r.contractNumber);
      if (m != null) {
        final n = int.parse(m.group(1)!);
        if (n > max) max = n;
      }
    }
    return 'CTR-${(max + 1).toString().padLeft(4, '0')}';
  }

  Future<String> createContract({
    required String customerId,
    DateTime? dueAt,
    double deposit = 0,
    String? notes,
  }) async {
    final rowId = const Uuid().v4();
    final number = await nextContractNumber();
    final now = DateTime.now();
    await _db.into(_db.rentalContracts).insert(
          RentalContractsCompanion.insert(
            id: rowId,
            contractNumber: number,
            customerId: customerId,
            dueAt: Value(dueAt),
            deposit: Value(deposit),
            notes: Value(notes),
            updatedAt: Value(now),
          ),
        );
    await _enqueueContract(rowId);
    return rowId;
  }

  Future<RentalContract?> getContract(String id) =>
      (_db.select(_db.rentalContracts)..where((c) => c.id.equals(id)))
          .getSingleOrNull();

  Future<void> updateContract(
    String id, {
    DateTime? dueAt,
    double? deposit,
    String? notes,
    String? customerId,
    String? deliveryMethod,
    String? siteId,
    double? deliveryFee,
  }) async {
    await (_db.update(_db.rentalContracts)..where((c) => c.id.equals(id)))
        .write(RentalContractsCompanion(
      dueAt: dueAt == null ? const Value.absent() : Value(dueAt),
      deposit: deposit == null ? const Value.absent() : Value(deposit),
      notes: notes == null ? const Value.absent() : Value(notes),
      customerId:
          customerId == null ? const Value.absent() : Value(customerId),
      deliveryMethod: deliveryMethod == null
          ? const Value.absent()
          : Value(deliveryMethod),
      siteId: siteId == null ? const Value.absent() : Value(siteId),
      deliveryFee: deliveryFee == null
          ? const Value.absent()
          : Value(deliveryFee),
      updatedAt: Value(DateTime.now()),
    ));
    if (dueAt != null) await recalcLinesFromDates(id);
    await _enqueueContract(id);
  }

  Stream<List<ContractView>> watchContracts({String? status}) {
    final q = _db.select(_db.rentalContracts)
      ..where((c) => c.deletedAt.isNull())
      ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]);
    if (status != null) q.where((c) => c.status.equals(status));
    return q.watch().asyncMap((contracts) async {
      final out = <ContractView>[];
      for (final c in contracts) {
        final customer = await (_db.select(_db.customers)
              ..where((x) => x.id.equals(c.customerId)))
            .getSingleOrNull();
        final lines = await _livingLines(c.id);
        final total =
            lines.fold<double>(0, (s, l) => s + l.amount);
        out.add(ContractView(c, customer, total, lines.length));
      }
      return out;
    });
  }

  Future<List<RentalLine>> _livingLines(String contractId) =>
      (_db.select(_db.rentalLines)
            ..where((l) =>
                l.contractId.equals(contractId) & l.deletedAt.isNull()))
          .get();

  Stream<List<LineView>> watchLines(String contractId) {
    final q = _db.select(_db.rentalLines)
      ..where(
          (l) => l.contractId.equals(contractId) & l.deletedAt.isNull())
      ..orderBy([(l) => OrderingTerm.asc(l.updatedAt)]);
    return q.watch().asyncMap((lines) async {
      final out = <LineView>[];
      for (final l in lines) {
        final asset = await (_db.select(_db.assets)
              ..where((a) => a.id.equals(l.assetId)))
            .getSingleOrNull();
        final model = await (_db.select(_db.toolModels)
              ..where((m) => m.id.equals(l.toolModelId)))
            .getSingleOrNull();
        out.add(LineView(l, asset, model));
      }
      return out;
    });
  }

  // ---------------- líneas ----------------

  double rateFor(ToolModel m, String kind) => switch (kind) {
        'half_day' => m.rateHalfDay ?? 0,
        'week' => m.rateWeek ?? 0,
        'month' => m.rateMonth ?? 0,
        _ => m.rateDay ?? 0,
      };

  /// Tipo de renta y períodos derivados del rango retiro→devolución
  /// (granularidad de días; el bloque 4h solo se elige manualmente).
  (String, double) rentalKindForDates(DateTime from, DateTime to) {
    final d0 = DateTime(from.year, from.month, from.day);
    final d1 = DateTime(to.year, to.month, to.day);
    var days = d1.difference(d0).inDays;
    if (days < 1) days = 1;
    if (days < 7) return ('day', days.toDouble());
    if (days < 30) return ('week', (days / 7).ceil().toDouble());
    return ('month', (days / 30).ceil().toDouble());
  }

  /// Recalcula tarifa y períodos de las líneas no devueltas según las
  /// fechas del contrato (retiro = start_at o hoy; fin = due_at).
  Future<void> recalcLinesFromDates(String contractId) async {
    final c = await getContract(contractId);
    if (c == null || c.dueAt == null) return;
    if (c.status != 'draft' && c.status != 'active') return;
    final (kind, periods) =
        rentalKindForDates(c.startAt ?? DateTime.now(), c.dueAt!);
    for (final l in await _livingLines(contractId)) {
      if (l.returnedAt != null) continue;
      final model = await _catalog.getModel(l.toolModelId);
      final rate = model == null ? l.rate : rateFor(model, kind);
      await (_db.update(_db.rentalLines)..where((x) => x.id.equals(l.id)))
          .write(RentalLinesCompanion(
        rateKind: Value(kind),
        rate: Value(rate),
        periods: Value(periods),
        amount: Value(rate * periods),
        updatedAt: Value(DateTime.now()),
      ));
      await _enqueueLine(l.id);
    }
  }

  /// Agrega una unidad al contrato. Devuelve null si se agregó, o el
  /// motivo si no se pudo (no disponible / repetida).
  Future<String?> addLine(String contractId, String assetId,
      {String rateKind = 'day'}) async {
    final asset = await _catalog.getAsset(assetId);
    if (asset == null) return 'Unidad no encontrada';
    if (asset.status != 'available') {
      return '${asset.assetTag} no está disponible '
          '(estado: ${asset.status})';
    }
    final dup = await (_db.select(_db.rentalLines)
          ..where((l) =>
              l.contractId.equals(contractId) &
              l.assetId.equals(assetId) &
              l.deletedAt.isNull()))
        .getSingleOrNull();
    if (dup != null) return '${asset.assetTag} ya está en el contrato';

    final model = await _catalog.getModel(asset.toolModelId);
    if (model == null) return 'Producto no encontrado';
    // Con fechas definidas, el tipo y los períodos salen del rango
    // retiro→devolución; sin fechas, manual (día por defecto).
    final contract = await getContract(contractId);
    var kind = rateKind;
    var periods = 1.0;
    if (contract?.dueAt != null) {
      (kind, periods) = rentalKindForDates(
          contract!.startAt ?? DateTime.now(), contract.dueAt!);
    }
    final rate = rateFor(model, kind);
    final rowId = const Uuid().v4();
    final now = DateTime.now();
    await _db.into(_db.rentalLines).insert(RentalLinesCompanion.insert(
          id: rowId,
          contractId: contractId,
          assetId: assetId,
          toolModelId: asset.toolModelId,
          rateKind: Value(kind),
          rate: Value(rate),
          periods: Value(periods),
          amount: Value(rate * periods),
          conditionOut: Value(asset.condition),
          updatedAt: Value(now),
        ));
    await _enqueueLine(rowId);
    return null;
  }

  Future<void> updateLine(String lineId,
      {String? rateKind, double? rate, double? periods}) async {
    final line = await (_db.select(_db.rentalLines)
          ..where((l) => l.id.equals(lineId)))
        .getSingle();
    var newKind = rateKind ?? line.rateKind;
    var newRate = rate ?? line.rate;
    if (rateKind != null && rate == null) {
      final model = await _catalog.getModel(line.toolModelId);
      if (model != null) newRate = rateFor(model, rateKind);
    }
    final newPeriods = periods ?? line.periods;
    await (_db.update(_db.rentalLines)..where((l) => l.id.equals(lineId)))
        .write(RentalLinesCompanion(
      rateKind: Value(newKind),
      rate: Value(newRate),
      periods: Value(newPeriods),
      amount: Value(newRate * newPeriods),
      updatedAt: Value(DateTime.now()),
    ));
    await _enqueueLine(lineId);
  }

  Future<void> removeLine(String lineId) async {
    final now = DateTime.now();
    await (_db.update(_db.rentalLines)..where((l) => l.id.equals(lineId)))
        .write(RentalLinesCompanion(
      deletedAt: Value(now),
      updatedAt: Value(now),
    ));
    await _enqueueLine(lineId);
  }

  // ---------------- flujo entregar / devolver ----------------

  /// Entrega: contrato → active, unidades → rented (kardex rent_out).
  /// Devuelve null si ok, o el motivo si no se pudo.
  Future<String?> deliver(String contractId) async {
    final contract = await getContract(contractId);
    if (contract == null) return 'Contrato no encontrado';
    if (contract.status != 'draft') {
      return 'El contrato ya fue entregado';
    }
    final lines = await _livingLines(contractId);
    if (lines.isEmpty) return 'Agrega al menos una unidad';
    for (final l in lines) {
      final asset = await _catalog.getAsset(l.assetId);
      if (asset == null || asset.status != 'available') {
        return 'La unidad ${asset?.assetTag ?? l.assetId} '
            'ya no está disponible';
      }
    }
    final now = DateTime.now();
    for (final l in lines) {
      await _catalog.setAssetStatus(l.assetId, 'rented',
          contractRef: contract.contractNumber);
      await (_db.update(_db.rentalLines)..where((x) => x.id.equals(l.id)))
          .write(RentalLinesCompanion(
        deliveredAt: Value(now),
        updatedAt: Value(now),
      ));
      await _enqueueLine(l.id);
    }
    await (_db.update(_db.rentalContracts)
          ..where((c) => c.id.equals(contractId)))
        .write(RentalContractsCompanion(
      status: const Value('active'),
      startAt: Value(now),
      updatedAt: Value(now),
    ));
    // Con fecha pactada, los períodos se recalculan desde el retiro real.
    await recalcLinesFromDates(contractId);
    await _enqueueContract(contractId);
    return null;
  }

  /// Devuelve una unidad. Si es la última pendiente, cierra el contrato.
  Future<void> returnLine(String lineId,
      {String conditionIn = 'good', String? notes}) async {
    final line = await (_db.select(_db.rentalLines)
          ..where((l) => l.id.equals(lineId)))
        .getSingle();
    if (line.returnedAt != null) return;
    final contract = await getContract(line.contractId);
    final now = DateTime.now();
    // Condición al recibir ANTES del cambio de estado: setAssetStatus
    // encola la fila completa del asset con la condición ya escrita.
    await (_db.update(_db.assets)..where((a) => a.id.equals(line.assetId)))
        .write(AssetsCompanion(
      condition: Value(conditionIn),
      updatedAt: Value(now),
    ));
    // Dañada → mantenimiento; bien → disponible.
    await _catalog.setAssetStatus(
        line.assetId, conditionIn == 'poor' ? 'maintenance' : 'available',
        contractRef: contract?.contractNumber, notes: notes);
    await (_db.update(_db.rentalLines)..where((l) => l.id.equals(lineId)))
        .write(RentalLinesCompanion(
      returnedAt: Value(now),
      conditionIn: Value(conditionIn),
      notes: notes == null ? const Value.absent() : Value(notes),
      updatedAt: Value(now),
    ));
    await _enqueueLine(lineId);

    final pending = await (_db.select(_db.rentalLines)
          ..where((l) =>
              l.contractId.equals(line.contractId) &
              l.deletedAt.isNull() &
              l.returnedAt.isNull()))
        .get();
    if (pending.isEmpty) {
      await (_db.update(_db.rentalContracts)
            ..where((c) => c.id.equals(line.contractId)))
          .write(RentalContractsCompanion(
        status: const Value('closed'),
        returnedAt: Value(now),
        updatedAt: Value(now),
      ));
      await _enqueueContract(line.contractId);
    }
  }

  /// Cancela un borrador (las unidades nunca salieron).
  Future<String?> cancel(String contractId) async {
    final contract = await getContract(contractId);
    if (contract == null) return 'Contrato no encontrado';
    if (contract.status != 'draft') {
      return 'Solo se cancelan borradores; usa devolver para cerrar';
    }
    final now = DateTime.now();
    await (_db.update(_db.rentalContracts)
          ..where((c) => c.id.equals(contractId)))
        .write(RentalContractsCompanion(
      status: const Value('cancelled'),
      updatedAt: Value(now),
    ));
    await _enqueueContract(contractId);
    return null;
  }

  // ---------------- sync ----------------

  Future<void> _enqueueContract(String id) async {
    final c = await getContract(id);
    if (c == null) return;
    await _sync
        .enqueue(table: 'rental_contracts', rowId: id, op: 'upsert', row: {
      'id': c.id,
      'contract_number': c.contractNumber,
      'customer_id': c.customerId,
      'status': c.status,
      'start_at': isoTsN(c.startAt),
      'due_at': isoTsN(c.dueAt),
      'returned_at': isoTsN(c.returnedAt),
      'deposit': c.deposit,
      'delivery_method': c.deliveryMethod,
      'site_id': c.siteId,
      'delivery_fee': c.deliveryFee,
      'notes': c.notes,
      'created_by': c.createdBy,
      'updated_at': isoTs(c.updatedAt),
      'deleted_at': isoTsN(c.deletedAt),
    });
  }

  Future<void> _enqueueLine(String id) async {
    final l = await (_db.select(_db.rentalLines)
          ..where((x) => x.id.equals(id)))
        .getSingleOrNull();
    if (l == null) return;
    await _sync.enqueue(table: 'rental_lines', rowId: id, op: 'upsert', row: {
      'id': l.id,
      'contract_id': l.contractId,
      'asset_id': l.assetId,
      'tool_model_id': l.toolModelId,
      'rate_kind': l.rateKind,
      'rate': l.rate,
      'periods': l.periods,
      'amount': l.amount,
      'delivered_at': isoTsN(l.deliveredAt),
      'returned_at': isoTsN(l.returnedAt),
      'condition_out': l.conditionOut,
      'condition_in': l.conditionIn,
      'notes': l.notes,
      'updated_at': isoTs(l.updatedAt),
      'deleted_at': isoTsN(l.deletedAt),
    });
  }
}

final rentalRepositoryProvider = Provider<RentalRepository>((ref) =>
    RentalRepository(
        ref.watch(appDatabaseProvider),
        ref.watch(syncServiceProvider),
        ref.watch(catalogRepositoryProvider)));

final contractsProvider = StreamProvider.autoDispose
    .family<List<ContractView>, String?>((ref, status) =>
        ref.watch(rentalRepositoryProvider).watchContracts(status: status));

final contractProvider = StreamProvider.autoDispose
    .family<RentalContract?, String>((ref, id) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.rentalContracts)..where((c) => c.id.equals(id)))
      .watchSingleOrNull();
});

final contractLinesProvider = StreamProvider.autoDispose
    .family<List<LineView>, String>((ref, contractId) =>
        ref.watch(rentalRepositoryProvider).watchLines(contractId));

final customersProvider = StreamProvider.autoDispose
    .family<List<Customer>, String>((ref, query) =>
        ref.watch(rentalRepositoryProvider).watchCustomers(query: query));

final customerProvider =
    StreamProvider.autoDispose.family<Customer?, String>((ref, id) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.customers)..where((c) => c.id.equals(id)))
      .watchSingleOrNull();
});

final customerSitesProvider = StreamProvider.autoDispose
    .family<List<CustomerSite>, String>((ref, customerId) =>
        ref.watch(rentalRepositoryProvider).watchSites(customerId));

final siteProvider =
    StreamProvider.autoDispose.family<CustomerSite?, String>((ref, id) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.customerSites)..where((s) => s.id.equals(id)))
      .watchSingleOrNull();
});
