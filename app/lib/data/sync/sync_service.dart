import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config.dart';
import '../local/database.dart';
import 'adapters.dart';

class SyncResult {
  const SyncResult({this.pushed = 0, this.pulled = 0, this.error});

  final int pushed;
  final int pulled;
  final String? error;

  bool get ok => error == null;
}

/// Cómo se sube y se mergea una tabla. Cada repositorio registra el
/// suyo; el ORDEN de la lista define el orden de push (padres antes
/// que hijos, respetando llaves foráneas).
class TableSyncAdapter {
  const TableSyncAdapter({
    required this.remoteTable,
    required this.mergeRemote,
  });

  /// Nombre de la tabla en Supabase.
  final String remoteTable;

  /// Aplica una fila remota en local con last-write-wins.
  /// Devuelve true si escribió.
  final Future<bool> Function(AppDatabase db, Map<String, dynamic> row)
      mergeRemote;
}

DateTime? tsN(dynamic v) => v == null ? null : DateTime.parse(v as String);
DateTime ts(dynamic v) => DateTime.parse(v as String);
String isoTs(DateTime t) => t.toUtc().toIso8601String();
String? isoTsN(DateTime? t) => t?.toUtc().toIso8601String();

/// ¿La fila remota es más nueva que la local? (LWW)
bool newer(DateTime? local, DateTime remote) =>
    local == null || remote.isAfter(local);

/// Servicio de sincronización offline-first (mismo patrón que YASTA):
/// push de la cola ordenado por dependencias y tolerante a fallos,
/// pull incremental por cursor updated_at, merge last-write-wins.
class SyncService {
  SyncService(this._db, this._adapters);

  final AppDatabase _db;
  final List<TableSyncAdapter> _adapters;

  SupabaseClient get _remote => Supabase.instance.client;

  List<String> get _tableOrder =>
      [for (final a in _adapters) a.remoteTable];

  Future<void> enqueue({
    required String table,
    required String rowId,
    required String op,
    required Map<String, dynamic> row,
  }) async {
    await _db.into(_db.syncQueue).insert(SyncQueueCompanion.insert(
          tableRef: table,
          rowId: rowId,
          op: op,
          payload: jsonEncode(row),
        ));
  }

  Future<int> pendingCount() async {
    final countExp = _db.syncQueue.seq.count();
    final query = _db.selectOnly(_db.syncQueue)..addColumns([countExp]);
    return (await query.getSingle()).read(countExp) ?? 0;
  }

  Future<SyncResult> syncAll() async {
    if (!AppConfig.hasSupabase) {
      // Build sin --dart-define-from-file: no hay URL/key embebidas.
      return const SyncResult(
          error: 'Este APK no trae credenciales del servidor: '
              'instala la versión oficial más reciente');
    }
    if (_remote.auth.currentSession == null) {
      return const SyncResult(
          error: 'Inicia sesión para poder sincronizar');
    }
    try {
      final org = await _orgId();
      if (org == null) {
        return const SyncResult(error: 'El usuario no tiene organización');
      }
      final (pushed, pushError) = await _push(org);
      final pulled = await _pull();
      return SyncResult(pushed: pushed, pulled: pulled, error: pushError);
    } on Object catch (e) {
      return SyncResult(error: e.toString());
    }
  }

  // ---------- Organización ----------

  Future<String?> _orgId() async {
    final cached = await stateGet('org_id');
    if (cached != null) return cached;
    final uid = _remote.auth.currentUser?.id;
    if (uid == null) return null;
    final row = await _remote
        .from('profiles')
        .select('organization_id')
        .eq('id', uid)
        .maybeSingle();
    final org = row?['organization_id'] as String?;
    if (org != null) {
      await stateSet('org_id', org);
      final orgRow = await _remote
          .from('organizations')
          .select('name')
          .eq('id', org)
          .maybeSingle();
      final name = orgRow?['name'] as String?;
      if (name != null) await stateSet('org_name', name);
    }
    return org;
  }

  Future<String> orgName() async =>
      await stateGet('org_name') ?? 'DEMACO Rent a Tool';

  // ---------- Push ----------

  Future<(int, String?)> _push(String org) async {
    await _uploadPendingCanonicalIcons(org);
    await _uploadPendingAssetPhotos(org);
    await _uploadPendingLinePhotos();
    final entries = await (_db.select(_db.syncQueue)
          ..orderBy([(q) => OrderingTerm.asc(q.seq)]))
        .get();
    final order = _tableOrder;
    final sorted = [...entries]..sort((a, b) {
        final ta = order.indexOf(a.tableRef);
        final tb = order.indexOf(b.tableRef);
        final byTable = (ta < 0 ? order.length : ta)
            .compareTo(tb < 0 ? order.length : tb);
        return byTable != 0 ? byTable : a.seq.compareTo(b.seq);
      });
    var pushed = 0;
    var failed = 0;
    String? firstError;
    for (final e in sorted) {
      try {
        final payload = jsonDecode(e.payload) as Map<String, dynamic>;
        payload['organization_id'] = org;
        await _remote.from(e.tableRef).upsert(payload);
        await (_db.delete(_db.syncQueue)
              ..where((q) => q.seq.equals(e.seq)))
            .go();
        pushed++;
      } on Object catch (err) {
        failed++;
        firstError ??= '${e.tableRef}: $err';
      }
    }
    final error = failed == 0
        ? null
        : '$failed fila(s) no subieron (se reintentarán). '
            'Primer error → $firstError';
    return (pushed, error);
  }

  /// Sube íconos de canónicos al bucket photos y registra icon_path.
  Future<void> _uploadPendingCanonicalIcons(String org) async {
    final pending = await (_db.select(_db.canonicals)
          ..where((c) =>
              c.iconUploadedAt.isNull() & c.iconLocalPath.isNotNull()))
        .get();
    for (final c in pending) {
      final file = File(c.iconLocalPath!);
      if (!file.existsSync()) continue;
      final remotePath = '$org/canonicos/${c.id}.jpg';
      await _remote.storage.from('photos').upload(
            remotePath,
            file,
            fileOptions: const FileOptions(upsert: true),
          );
      await _remote
          .from('canonicals')
          .update({'icon_path': remotePath}).eq('id', c.id);
      await (_db.update(_db.canonicals)..where((x) => x.id.equals(c.id)))
          .write(CanonicalsCompanion(
        iconPath: Value(remotePath),
        iconUploadedAt: Value(DateTime.now()),
      ));
    }
  }

  /// Sube fotos de unidades al bucket photos y registra photo_path.
  Future<void> _uploadPendingAssetPhotos(String org) async {
    final pending = await (_db.select(_db.assets)
          ..where((a) =>
              a.photoUploadedAt.isNull() & a.photoLocalPath.isNotNull()))
        .get();
    for (final a in pending) {
      final file = File(a.photoLocalPath!);
      if (!file.existsSync()) continue;
      final remotePath = '$org/unidades/${a.id}.jpg';
      await _remote.storage.from('photos').upload(
            remotePath,
            file,
            fileOptions: const FileOptions(upsert: true),
          );
      await _remote
          .from('assets')
          .update({'photo_path': remotePath}).eq('id', a.id);
      await (_db.update(_db.assets)..where((x) => x.id.equals(a.id)))
          .write(AssetsCompanion(
        photoPath: Value(remotePath),
        photoUploadedAt: Value(DateTime.now()),
      ));
    }
  }

  /// Sube las fotos de evidencia pendientes al bucket docs (la fila
  /// ya viaja por la cola con su photo_path definitivo).
  Future<void> _uploadPendingLinePhotos() async {
    final pending = await (_db.select(_db.rentalLinePhotos)
          ..where((p) =>
              p.uploadedAt.isNull() &
              p.localPath.isNotNull() &
              p.photoPath.isNotNull()))
        .get();
    for (final p in pending) {
      final file = File(p.localPath!);
      if (!file.existsSync()) continue;
      await _remote.storage.from('docs').upload(
            p.photoPath!,
            file,
            fileOptions: const FileOptions(upsert: true),
          );
      await (_db.update(_db.rentalLinePhotos)
            ..where((x) => x.id.equals(p.id)))
          .write(RentalLinePhotosCompanion(
        uploadedAt: Value(DateTime.now()),
      ));
    }
  }

  // ---------- Pull ----------

  Future<int> _pull() async {
    var pulled = 0;
    for (final adapter in _adapters) {
      final table = adapter.remoteTable;
      final since = await stateGet('pull_$table') ??
          DateTime.utc(2000).toIso8601String();
      final rows = await _remote
          .from(table)
          .select()
          .gt('updated_at', since)
          .order('updated_at', ascending: true)
          .limit(500);
      for (final row in rows) {
        if (await adapter.mergeRemote(
            _db, Map<String, dynamic>.from(row))) {
          pulled++;
        }
      }
      if (rows.isNotEmpty) {
        await stateSet(
            'pull_$table', rows.last['updated_at'] as String);
      }
    }
    return pulled;
  }

  // ---------- Estado ----------

  Future<String?> stateGet(String key) async {
    final row = await (_db.select(_db.syncState)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> stateSet(String key, String value) async {
    await _db
        .into(_db.syncState)
        .insertOnConflictUpdate(SyncStateCompanion.insert(
          key: key,
          value: value,
        ));
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final syncServiceProvider = Provider<SyncService>((ref) =>
    SyncService(ref.watch(appDatabaseProvider), buildSyncAdapters()));
