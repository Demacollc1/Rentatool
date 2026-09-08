import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as pth;
import 'package:path_provider/path_provider.dart';
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

  /// Guarda el ícono del canónico: copia el archivo elegido a los
  /// documentos del app y lo deja pendiente de subir al Storage.
  Future<void> setIcon(String id, String pickedPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final outDir = Directory(pth.join(dir.path, 'icons'));
    await outDir.create(recursive: true);
    final dest = pth.join(outDir.path, '$id.jpg');
    await File(pickedPath).copy(dest);
    await (_db.update(_db.canonicals)..where((c) => c.id.equals(id)))
        .write(CanonicalsCompanion(
      iconLocalPath: Value(dest),
      iconUploadedAt: const Value(null),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Cuántos productos vivos usan este canónico.
  Future<int> productsUsing(String code) async {
    final countExp = _db.toolModels.id.count();
    final q = _db.selectOnly(_db.toolModels)
      ..addColumns([countExp])
      ..where(_db.toolModels.canonicalCode.equals(code) &
          _db.toolModels.deletedAt.isNull());
    return (await q.getSingle()).read(countExp) ?? 0;
  }

  /// Elimina (soft) un canónico SOLO si ningún producto lo usa.
  /// Devuelve null si se eliminó, o el motivo si no se pudo.
  Future<String?> delete(String id) async {
    final c = await (_db.select(_db.canonicals)
          ..where((x) => x.id.equals(id)))
        .getSingleOrNull();
    if (c == null) return 'Canónico no encontrado';
    final inUse = await productsUsing(c.code);
    if (inUse > 0) {
      return 'No se puede eliminar: ${c.code} está en uso por '
          '$inUse producto${inUse == 1 ? '' : 's'}';
    }
    final now = DateTime.now();
    await (_db.update(_db.canonicals)..where((x) => x.id.equals(id)))
        .write(CanonicalsCompanion(
            deletedAt: Value(now), updatedAt: Value(now)));
    await _sync.enqueue(table: 'canonicals', rowId: id, op: 'upsert', row: {
      'id': c.id,
      'code': c.code,
      'name': c.name,
      'updated_at': isoTs(now),
      'deleted_at': isoTs(now),
    });
    return null;
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
