/// Heurísticas para extraer marca, modelo y número de serie del texto
/// OCR de una etiqueta de producto o caja. Puro y testeable.
class LabelGuess {
  const LabelGuess({this.brand, this.model, this.serial});

  final String? brand;
  final String? model;
  final String? serial;

  bool get isEmpty => brand == null && model == null && serial == null;
}

const _knownBrands = [
  'DEWALT', 'CRAFTSMAN', 'STANLEY', 'BOSCH', 'MAKITA', 'MILWAUKEE',
  'BLACK+DECKER', 'BLACK & DECKER', 'RYOBI', 'HILTI', 'METABO',
  'SKIL', 'TRUPER', 'INGCO', 'TOTAL', 'HUSQVARNA', 'STIHL', 'HONDA',
  'KARCHER', 'KÄRCHER', 'SK POWER', 'EINHELL', 'WORX', 'DONGCHENG',
];

/// Extrae marca/modelo/serie de las líneas del OCR.
LabelGuess parseLabelText(String text) {
  final lines = text
      .split(RegExp(r'[\n\r]+'))
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();
  final upper = lines.map((l) => l.toUpperCase()).toList();

  // ── Marca: primera coincidencia con la lista conocida ──
  String? brand;
  for (final l in upper) {
    for (final b in _knownBrands) {
      if (l.contains(b)) {
        brand = _titleCase(b);
        break;
      }
    }
    if (brand != null) break;
  }

  // ── Serie: etiquetada (S/N, SERIAL, SERIE…) o dígitos largos ──
  String? serial;
  final serialTag = RegExp(
      r'(?:S\s*/?\s*N|SERIAL(?:\s*(?:NO|NUMBER|N[ÚU]MERO))?|'
      r'SERIE|SER\.?\s*NO)\s*[:#.]?\s*([A-Z0-9][A-Z0-9\-]{4,})',
      caseSensitive: false);
  for (final l in lines) {
    final m = serialTag.firstMatch(l);
    if (m != null) {
      serial = m.group(1);
      break;
    }
  }
  if (serial == null) {
    // Fallback: la secuencia de dígitos más larga (≥8).
    String best = '';
    for (final l in lines) {
      for (final m in RegExp(r'\d{8,}').allMatches(l)) {
        if (m.group(0)!.length > best.length) best = m.group(0)!;
      }
    }
    if (best.isNotEmpty) serial = best;
  }

  // ── Modelo: etiquetado o token alfanumérico tipo D28114/DWE575K ──
  String? model;
  final modelTag = RegExp(
      r'(?:MODEL(?:O)?|MOD|TYPE|TYP|CAT\.?\s*(?:NO|N[ÚU]M)?)'
      r'\s*[:#.]?\s*([A-Z0-9][A-Z0-9\-\/\.]{2,})',
      caseSensitive: false);
  for (final l in lines) {
    final m = modelTag.firstMatch(l);
    if (m != null) {
      final candidate = m.group(1)!.toUpperCase();
      if (candidate != serial) {
        model = candidate;
        break;
      }
    }
  }
  if (model == null) {
    // Token con letras Y dígitos, 4-14 chars, que no sea la serie.
    final tokenRe = RegExp(r'\b(?=[A-Z0-9\-\/]*[A-Z])'
        r'(?=[A-Z0-9\-\/]*\d)[A-Z][A-Z0-9\-\/]{3,13}\b');
    for (final l in upper) {
      for (final m in tokenRe.allMatches(l)) {
        final t = m.group(0)!;
        if (t == serial) continue;
        if (RegExp(r'^\d+V$|^\d+HZ$|^\d+W$|^\d+RPM$|^\d+AH?$')
            .hasMatch(t)) {
          continue; // specs eléctricas, no modelo
        }
        model = t;
        break;
      }
      if (model != null) break;
    }
  }

  return LabelGuess(brand: brand, model: model, serial: serial);
}

String _titleCase(String s) => s
    .split(' ')
    .map((w) => w.isEmpty
        ? w
        : w[0].toUpperCase() + w.substring(1).toLowerCase())
    .join(' ');
