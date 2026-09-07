import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../sync/sync_service.dart';

/// Niveles: 0 = oficio (Carpintería…) · 1 = grupo de equipo.
const categoryLevels = ['Oficio', 'Grupo de equipo'];

class CategoryRepository {
  CategoryRepository(this._db, this._sync);

  final AppDatabase _db;
  final SyncService _sync;

  Stream<List<Category>> watchAll() => (_db.select(_db.categories)
        ..where((c) => c.deletedAt.isNull())
        ..orderBy([(c) => OrderingTerm.asc(c.name)]))
      .watch();

  Future<Category?> getById(String id) =>
      (_db.select(_db.categories)..where((c) => c.id.equals(id)))
          .getSingleOrNull();

  Future<String> save({
    String? id,
    String? parentId,
    required String name,
  }) async {
    var level = 0;
    if (parentId != null) {
      final parent = await getById(parentId);
      level = (parent?.level ?? -1) + 1;
      if (level >= categoryLevels.length) {
        throw StateError('Máximo ${categoryLevels.length} niveles');
      }
    }
    final rowId = id ?? const Uuid().v4();
    await _db.into(_db.categories).insertOnConflictUpdate(
          CategoriesCompanion.insert(
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

  Future<void> _enqueue(String id) async {
    final c = await getById(id);
    if (c == null) return;
    await _sync.enqueue(table: 'categories', rowId: id, op: 'upsert', row: {
      'id': c.id,
      'parent_id': c.parentId,
      'name': c.name,
      'level': c.level,
      'updated_at': isoTs(c.updatedAt),
      'deleted_at': isoTsN(c.deletedAt),
    });
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) =>
    CategoryRepository(
        ref.watch(appDatabaseProvider), ref.watch(syncServiceProvider)));

final categoriesProvider = StreamProvider.autoDispose<List<Category>>(
    (ref) => ref.watch(categoryRepositoryProvider).watchAll());
