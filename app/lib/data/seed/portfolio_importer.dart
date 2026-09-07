import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config.dart';
import '../repositories/catalog_repository.dart';
import '../repositories/category_repository.dart';

/// Resumen del portafolio antes/después de importar.
class ImportSummary {
  const ImportSummary({
    required this.oficios,
    required this.filas,
    required this.modelos,
    required this.consumibles,
  });

  final int oficios;
  final int filas;
  final int modelos;
  final int consumibles;
}

/// uuid v5-like determinístico (sha1 → formato uuid) a partir de una
/// clave natural: reimportar nunca duplica.
String deterministicId(String key) {
  final h = sha1.convert(utf8.encode('demaco-seed:$key')).bytes;
  final b = List<int>.from(h.take(16));
  b[6] = (b[6] & 0x0f) | 0x50; // versión 5
  b[8] = (b[8] & 0x3f) | 0x80; // variante RFC 4122
  String hex(int start, int end) => b
      .sublist(start, end)
      .map((x) => x.toRadixString(16).padLeft(2, '0'))
      .join();
  return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
}

/// Importa el portafolio (assets/seed/portafolio.json) al catálogo:
/// oficios/grupos → categorías, líneas ind/diy → tool_models,
/// cons_codes → consumables + vínculos. NO crea unidades físicas.
class PortfolioImporter {
  PortfolioImporter(this._categories, this._catalog);

  final CategoryRepository _categories;
  final CatalogRepository _catalog;

  Future<Map<String, dynamic>> loadRaw() async {
    final text =
        await rootBundle.loadString('assets/seed/portafolio.json');
    return jsonDecode(text) as Map<String, dynamic>;
  }

  ImportSummary summarize(Map<String, dynamic> data) {
    var filas = 0;
    final modelCodes = <String>{};
    final cons = <String>{};
    for (final tools in data.values) {
      for (final t in tools as List) {
        filas++;
        final row = t as Map<String, dynamic>;
        for (final lineKey in const ['ind', 'diy']) {
          final line = row[lineKey] as Map<String, dynamic>?;
          final code = (line?['code'] as String?)?.trim();
          // La misma herramienta puede repetirse en varios oficios:
          // cuenta modelos únicos por código.
          if (code != null && code.isNotEmpty) modelCodes.add(code);
        }
        for (final c in (row['cons_codes'] as List? ?? const [])) {
          final code = (c as Map)['code'] as String?;
          if (code != null && code.isNotEmpty) cons.add(code);
        }
      }
    }
    return ImportSummary(
      oficios: data.length,
      filas: filas,
      modelos: modelCodes.length,
      consumibles: cons.length,
    );
  }

  /// Ejecuta la importación. Idempotente (ids determinísticos).
  Future<ImportSummary> import(Map<String, dynamic> data) async {
    final modelSeen = <String>{};
    final consSeen = <String>{};

    for (final entry in data.entries) {
      final oficio = _titleCase(entry.key);
      final oficioId = deterministicId('oficio:${entry.key}');
      await _categories.save(id: oficioId, name: oficio);

      for (final t in entry.value as List) {
        final row = t as Map<String, dynamic>;
        final grupo = (row['grupo'] as String?)?.trim();
        String? grupoId;
        if (grupo != null && grupo.isNotEmpty) {
          grupoId = deterministicId('grupo:${entry.key}|$grupo');
          await _categories.save(
              id: grupoId, parentId: oficioId, name: grupo);
        }

        // Consumibles de la fila.
        final consIds = <String>[];
        for (final c in (row['cons_codes'] as List? ?? const [])) {
          final cc = c as Map;
          final code = (cc['code'] as String?)?.trim();
          if (code == null || code.isEmpty) continue;
          final consId = deterministicId('cons:$code');
          if (consSeen.add(code)) {
            await _catalog.saveConsumable(
              id: consId,
              code: code,
              name: (cc['label'] as String?)?.trim().isNotEmpty ?? false
                  ? (cc['label'] as String).trim()
                  : code,
              cost: (cc['cost'] as num?)?.toDouble() ?? 0,
            );
          }
          consIds.add(consId);
        }

        for (final lineKey in const ['ind', 'diy']) {
          final line = row[lineKey] as Map<String, dynamic>?;
          final code = (line?['code'] as String?)?.trim();
          if (line == null || code == null || code.isEmpty) continue;
          final cost = (line['cost'] as num?)?.toDouble() ?? 0;
          final modelId = deterministicId('model:$code');
          final noteBits = <String>[
            if ((row['status'] as String?) != null &&
                row['status'] != 'ok')
              'estado: ${row['status']}',
            if ((row['sub'] as String?)?.isNotEmpty ?? false)
              'sub: ${row['sub']}',
            if ((row['cons'] as String?)?.isNotEmpty ?? false)
              'consumibles sugeridos: ${row['cons']}',
            'unidades plan (n): ${line['n'] ?? 0}',
          ];
          await _catalog.saveModel(
            id: modelId,
            name: row['tool'] as String? ?? code,
            spec: row['spec'] as String?,
            line: lineKey,
            brand: line['brand'] as String?,
            supplierCode: code,
            description: line['desc'] as String?,
            categoryId: grupoId ?? oficioId,
            listCost: cost,
            rateHalfDay:
                cost > 0 ? _r2(cost * RentalRates.halfDayPct) : null,
            rateDay: cost > 0 ? _r2(cost * RentalRates.dayPct) : null,
            rateWeek: cost > 0 ? _r2(cost * RentalRates.weekPct) : null,
            rateMonth:
                cost > 0 ? _r2(cost * RentalRates.monthPct) : null,
            b87Qty: (line['b87'] as num?)?.toDouble() ?? 0,
            notes: noteBits.join(' · '),
          );
          modelSeen.add(code);
          for (final consId in consIds) {
            await _catalog.linkConsumable(modelId, consId,
                id: deterministicId('link:$code|$consId'));
          }
        }
      }
    }
    return ImportSummary(
      oficios: data.length,
      filas: data.values.fold(0, (s, v) => s + (v as List).length),
      modelos: modelSeen.length,
      consumibles: consSeen.length,
    );
  }

  static double _r2(double v) => (v * 100).roundToDouble() / 100;

  static String _titleCase(String s) {
    final lower = s.toLowerCase();
    return lower
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}

final portfolioImporterProvider = Provider<PortfolioImporter>((ref) =>
    PortfolioImporter(ref.watch(categoryRepositoryProvider),
        ref.watch(catalogRepositoryProvider)));
