import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../seed/portfolio_importer.dart' show deterministicId;
import '../sync/sync_service.dart';

/// Canónicos administrables: semilla del ERP (1,694) + los propios.
class CanonicalRepository {
  CanonicalRepository(this._db, this._sync);

  final AppDatabase _db;
  final SyncService _sync;

  /// Carga la semilla del ERP si la tabla está vacía. Ids
  /// determinísticos por código: cada dispositivo se siembra igual y
  /// nada se duplica; la semilla NO se encola (solo lo que el usuario
  /// cree o edite viaja al servidor).
  Future<void> ensureSeeded() async {
    final countExp = _db.canonicals.id.count();
    final q = _db.selectOnly(_db.canonicals)..addColumns([countExp]);
    final n = (await q.getSingle()).read(countExp) ?? 0;
    if (n > 0) return;
    final text =
        await rootBundle.loadString('assets/seed/canonicos.json');
    final data = jsonDecode(text) as List;
    final now = DateTime.now();
    await _db.batch((b) {
      for (final c in data) {
        b.insert(
          _db.canonicals,
          CanonicalsCompanion.insert(
            id: deterministicId('canon:${c['code']}'),
            code: c['code'] as String,
            name: c['name'] as String,
            updatedAt: Value(now),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  Stream<List<Canonical>> watchAll({String query = ''}) {
    final q = _db.select(_db.canonicals)
      ..where((c) => c.deletedAt.isNull())
      ..orderBy([(c) => OrderingTerm.asc(c.code)]);
    if (query.trim().isNotEmpty) {
      final like = '%${query.trim()}%';
      q.where((c) => c.code.like(like) | c.name.like(like));
    }
    return q.watch();
  }

  Future<Canonical?> getByCode(String code) =>
      (_db.select(_db.canonicals)
            ..where(
                (c) => c.code.equals(code) & c.deletedAt.isNull()))
          .getSingleOrNull();

  /// Crea o edita un canónico (estos SÍ se sincronizan).
  Future<String> save({
    String? id,
    required String code,
    required String name,
  }) async {
    final normalized = code.trim().toUpperCase();
    final existing = id == null ? await getByCode(normalized) : null;
    final rowId = id ?? existing?.id ?? const Uuid().v4();
    await _db.into(_db.canonicals).insertOnConflictUpdate(
        CanonicalsCompanion.insert(
            id: rowId,
            code: normalized,
            name: name.trim(),
            updatedAt: Value(DateTime.now())));
    await _sync.enqueue(table: 'canonicals', rowId: rowId, op: 'upsert', row: {
      'id': rowId,
      'code': normalized,
      'name': name.trim(),
      'updated_at': isoTs(DateTime.now()),
      'deleted_at': null,
    });
    return rowId;
  }
}

final canonicalRepositoryProvider = Provider<CanonicalRepository>(
    (ref) => CanonicalRepository(
        ref.watch(appDatabaseProvider), ref.watch(syncServiceProvider)));

final canonicalsDbProvider = StreamProvider.autoDispose
    .family<List<Canonical>, String>((ref, query) {
  final repo = ref.watch(canonicalRepositoryProvider);
  // Siembra perezosa antes de observar.
  return Stream.fromFuture(repo.ensureSeeded())
      .asyncExpand((_) => repo.watchAll(query: query));
});
