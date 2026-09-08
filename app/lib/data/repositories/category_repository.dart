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

  Future<void> rename(String id, String name) async {
    await (_db.update(_db.categories)..where((c) => c.id.equals(id)))
        .write(CategoriesCompanion(
      name: Value(name),
      updatedAt: Value(DateTime.now()),
    ));
    await _enqueue(id);
  }

  /// Elimina (soft) si no tiene hijos vivos ni productos vinculados.
  /// Devuelve null si se eliminó, o el motivo.
  Future<String?> delete(String id) async {
    final children = await (_db.select(_db.categories)
          ..where(
              (c) => c.parentId.equals(id) & c.deletedAt.isNull()))
        .get();
    if (children.isNotEmpty) {
      return 'Tiene ${children.length} subcategoría(s): elimínalas primero';
    }
    final countExp = _db.toolModels.id.count();
    final q = _db.selectOnly(_db.toolModels)
      ..addColumns([countExp])
      ..where(_db.toolModels.categoryId.equals(id) &
          _db.toolModels.deletedAt.isNull());
    final direct = (await q.getSingle()).read(countExp) ?? 0;
    final linkExp = _db.toolModelCategories.id.count();
    final lq = _db.selectOnly(_db.toolModelCategories)
      ..addColumns([linkExp])
      ..where(_db.toolModelCategories.categoryId.equals(id) &
          _db.toolModelCategories.deletedAt.isNull());
    final linked = (await lq.getSingle()).read(linkExp) ?? 0;
    if (direct + linked > 0) {
      return 'Está en uso por ${direct + linked} producto(s)';
    }
    final now = DateTime.now();
    await (_db.update(_db.categories)..where((c) => c.id.equals(id)))
        .write(CategoriesCompanion(
            deletedAt: Value(now), updatedAt: Value(now)));
    await _enqueue(id);
    return null;
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
