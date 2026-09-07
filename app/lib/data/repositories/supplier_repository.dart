import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../sync/sync_service.dart';

class SupplierRepository {
  SupplierRepository(this._db, this._sync);

  final AppDatabase _db;
  final SyncService _sync;

  Stream<List<Supplier>> watchAll({String query = ''}) {
    final q = _db.select(_db.suppliers)
      ..where((s) => s.deletedAt.isNull())
      ..orderBy([(s) => OrderingTerm.asc(s.name)]);
    if (query.trim().isNotEmpty) {
      final like = '%${query.trim()}%';
      q.where((s) => s.name.like(like) | s.ruc.like(like));
    }
    return q.watch();
  }

  Future<Supplier?> getById(String id) =>
      (_db.select(_db.suppliers)..where((s) => s.id.equals(id)))
          .getSingleOrNull();

  Future<String> save({
    String? id,
    required String name,
    String? ruc,
    String? phone,
    String? email,
    String? notes,
  }) async {
    final rowId = id ?? const Uuid().v4();
    await _db.into(_db.suppliers).insertOnConflictUpdate(
          SuppliersCompanion.insert(
            id: rowId,
            name: name,
            ruc: Value(ruc),
            phone: Value(phone),
            email: Value(email),
            notes: Value(notes),
            updatedAt: Value(DateTime.now()),
          ),
        );
    final s = await getById(rowId);
    await _sync.enqueue(table: 'suppliers', rowId: rowId, op: 'upsert', row: {
      'id': rowId,
      'name': s!.name,
      'ruc': s.ruc,
      'phone': s.phone,
      'email': s.email,
      'notes': s.notes,
      'updated_at': isoTs(s.updatedAt),
      'deleted_at': isoTsN(s.deletedAt),
    });
    return rowId;
  }
}

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) =>
    SupplierRepository(
        ref.watch(appDatabaseProvider), ref.watch(syncServiceProvider)));

final suppliersProvider = StreamProvider.autoDispose
    .family<List<Supplier>, String>((ref, query) =>
        ref.watch(supplierRepositoryProvider).watchAll(query: query));

final supplierProvider = FutureProvider.autoDispose
    .family<Supplier?, String>(
        (ref, id) => ref.watch(supplierRepositoryProvider).getById(id));
