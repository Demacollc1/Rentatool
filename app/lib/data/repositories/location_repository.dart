import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../sync/sync_service.dart';

/// Niveles de ubicación del showroom/bodega.
const locationLevels = [
  'Showroom / Bodega',
  'Área / Zona',
  'Repisa',
  'Nivel',
  'Contenedor',
];

class LocationRepository {
  LocationRepository(this._db, this._sync);

  final AppDatabase _db;
  final SyncService _sync;

  Stream<List<Location>> watchChildren(String? parentId) {
    final q = _db.select(_db.locations)
      ..where((l) => l.deletedAt.isNull())
      ..orderBy([(l) => OrderingTerm.asc(l.name)]);
    if (parentId == null) {
      q.where((l) => l.parentId.isNull());
    } else {
      q.where((l) => l.parentId.equals(parentId));
    }
    return q.watch();
  }

  Stream<List<Location>> watchAll() => (_db.select(_db.locations)
        ..where((l) => l.deletedAt.isNull())
        ..orderBy([(l) => OrderingTerm.asc(l.name)]))
      .watch();

  Future<Location?> getById(String id) =>
      (_db.select(_db.locations)..where((l) => l.id.equals(id)))
          .getSingleOrNull();

  /// "Showroom > Zona A > Repisa 3"
  Future<String> fullPath(String id) async {
    final parts = <String>[];
    String? cursor = id;
    while (cursor != null) {
      final loc = await getById(cursor);
      if (loc == null) break;
      parts.insert(0, loc.name);
      cursor = loc.parentId;
    }
    return parts.join(' > ');
  }

  Future<String> save({
    String? id,
    String? parentId,
    required String name,
  }) async {
    var level = 0;
    if (parentId != null) {
      final parent = await getById(parentId);
      level = (parent?.level ?? -1) + 1;
      if (level >= locationLevels.length) {
        throw StateError('Máximo ${locationLevels.length} niveles');
      }
    }
    final rowId = id ?? const Uuid().v4();
    await _db.into(_db.locations).insertOnConflictUpdate(
          LocationsCompanion.insert(
            id: rowId,
            parentId: Value(parentId),
            name: name,
            level: Value(level),
            updatedAt: Value(DateTime.now()),
          ),
        );
    await _enqueue(rowId);
    return rowId;
  }

  Future<void> rename(String id, String name) async {
    await (_db.update(_db.locations)..where((l) => l.id.equals(id)))
        .write(LocationsCompanion(
      name: Value(name),
      updatedAt: Value(DateTime.now()),
    ));
    await _enqueue(id);
  }

  Future<void> softDelete(String id) async {
    final now = DateTime.now();
    final children = await (_db.select(_db.locations)
          ..where((l) => l.parentId.equals(id) & l.deletedAt.isNull()))
        .get();
    for (final c in children) {
      await softDelete(c.id);
    }
    await (_db.update(_db.locations)..where((l) => l.id.equals(id)))
        .write(LocationsCompanion(
      deletedAt: Value(now),
      updatedAt: Value(now),
    ));
    await _enqueue(id);
  }

  Future<void> _enqueue(String id) async {
    final l = await getById(id);
    if (l == null) return;
    await _sync.enqueue(table: 'locations', rowId: id, op: 'upsert', row: {
      'id': l.id,
      'parent_id': l.parentId,
      'name': l.name,
      'level': l.level,
      'updated_at': isoTs(l.updatedAt),
      'deleted_at': isoTsN(l.deletedAt),
    });
  }
}

final locationRepositoryProvider = Provider<LocationRepository>((ref) =>
    LocationRepository(
        ref.watch(appDatabaseProvider), ref.watch(syncServiceProvider)));

final locationChildrenProvider = StreamProvider.autoDispose
    .family<List<Location>, String?>((ref, parentId) =>
        ref.watch(locationRepositoryProvider).watchChildren(parentId));

final allLocationsProvider = StreamProvider.autoDispose<List<Location>>(
    (ref) => ref.watch(locationRepositoryProvider).watchAll());

final locationPathProvider = FutureProvider.autoDispose
    .family<String, String>((ref, id) =>
        ref.watch(locationRepositoryProvider).fullPath(id));
