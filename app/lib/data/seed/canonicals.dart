import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Subgrupo canónico del ERP Demaco (Book de subgrupos de productos).
/// El nombre completo es la concatenación de Descripción 1 y 2.
class Canonical {
  const Canonical({required this.code, required this.name});

  final String code;
  final String name;
}

/// Catálogo de ~1,700 canónicos empaquetado en assets (solo lectura;
/// se buscan en memoria, no viven en la base).
final canonicalsProvider = FutureProvider<List<Canonical>>((ref) async {
  final text = await rootBundle.loadString('assets/seed/canonicos.json');
  final data = jsonDecode(text) as List;
  return [
    for (final c in data)
      Canonical(code: c['code'] as String, name: c['name'] as String),
  ];
});
