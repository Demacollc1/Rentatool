import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config.dart';
import '../../data/local/database.dart';
import '../admin/admin_screen.dart' show canonicalAvatar;

/// Ícono del oficio/trade por nombre.
IconData tradeIcon(String name) {
  final n = name.toUpperCase();
  if (n.contains('ALBAÑIL')) return Icons.construction;
  if (n.contains('CARPIN')) return Icons.carpenter;
  if (n.contains('ELECTRIC')) return Icons.electrical_services;
  if (n.contains('IMPERMEAB')) return Icons.roofing;
  if (n.contains('JARDIN')) return Icons.grass;
  if (n.contains('LIMPIEZA')) return Icons.cleaning_services;
  if (n.contains('MOVIMIENTO') || n.contains('DEMOL')) {
    return Icons.agriculture;
  }
  if (n.contains('PINTURA')) return Icons.format_paint;
  if (n.contains('PLOMER')) return Icons.plumbing;
  if (n.contains('SEGURIDAD')) return Icons.health_and_safety;
  if (n.contains('SOLDADURA')) return Icons.local_fire_department;
  return Icons.handyman;
}

/// Ícono temático del producto por su nombre (fallback cuando el
/// canónico no tiene ícono propio subido).
IconData productIcon(String name) {
  final n = name.toUpperCase();
  if (n.contains('MOTOSIERRA') ||
      n.contains('DESBROZADORA') ||
      n.contains('CORTACETOS') ||
      n.contains('SOPLADOR')) {
    return Icons.grass;
  }
  if (n.contains('SIERRA') ||
      n.contains('CEPILLO') ||
      n.contains('REBAJADORA') ||
      n.contains('LIJADORA') ||
      n.contains('TRONZADORA') ||
      n.contains('INGLETEADORA')) {
    return Icons.carpenter;
  }
  if (n.contains('TALADRO') ||
      n.contains('ROTOMARTILLO') ||
      n.contains('DESTORNILLADOR') ||
      n.contains('LLAVE DE IMPACTO') ||
      n.contains('PERCUTOR')) {
    return Icons.hardware;
  }
  if (n.contains('MARTILLO') || n.contains('ROMPEPAVIMENTO')) {
    return Icons.construction;
  }
  if (n.contains('COMPRESOR') || n.contains('INFLA')) return Icons.air;
  if (n.contains('GENERADOR')) return Icons.electric_bolt;
  if (n.contains('HIDROLAVADORA') || n.contains('ASPIRADORA')) {
    return Icons.cleaning_services;
  }
  if (n.contains('SOLDADORA') || n.contains('SOPLETE')) {
    return Icons.local_fire_department;
  }
  if (n.contains('NIVEL') ||
      n.contains('TOPOMETRO') ||
      n.contains('TERMOMETRO')) {
    return Icons.straighten;
  }
  if (n.contains('ESCALERA')) return Icons.stairs;
  if (n.contains('BOMBA') ||
      n.contains('DESTAPA') ||
      n.contains('TUBOS')) {
    return Icons.plumbing;
  }
  if (n.contains('PULIDORA') ||
      n.contains('ESMERIL') ||
      n.contains('AMOLADORA')) {
    return Icons.build_circle;
  }
  if (n.contains('PINTURA') || n.contains('PISTOLA')) {
    return Icons.format_paint;
  }
  if (n.contains('VIBRADOR') ||
      n.contains('APISONADOR') ||
      n.contains('CONCRETERA') ||
      n.contains('REGLA') ||
      n.contains('HELICOPTERO')) {
    return Icons.foundation;
  }
  if (n.contains('CARRETILLA')) return Icons.trolley;
  if (n.contains('CABLE') || n.contains('EXTENSION')) {
    return Icons.electrical_services;
  }
  return Icons.handyman;
}

/// Avatar del producto: ícono subido del canónico si existe; si no,
/// ícono temático por nombre (nunca el círculo con letras).
Widget productAvatar(ToolModel model, Canonical? canonical,
    {double radius = 16}) {
  final path = canonical?.iconLocalPath;
  if (canonical != null &&
      path != null &&
      File(path).existsSync()) {
    return canonicalAvatar(canonical, radius: radius);
  }
  return CircleAvatar(
    radius: radius,
    backgroundColor: model.line == 'ind'
        ? Colors.amber.shade200
        : Colors.blueGrey.shade100,
    child: Icon(productIcon(model.name),
        size: radius + 2, color: Colors.black87),
  );
}

/// URL firmada (1 h) para una foto del bucket privado photos.
final photoSignedUrlProvider = FutureProvider.autoDispose
    .family<String?, String>((ref, remotePath) async {
  if (!AppConfig.hasSupabase) return null;
  try {
    return await Supabase.instance.client.storage
        .from('photos')
        .createSignedUrl(remotePath, 3600);
  } catch (_) {
    return null;
  }
});

/// Miniatura de la unidad: foto local → foto remota (URL firmada) →
/// ícono QR con el color del estado.
class AssetThumb extends ConsumerWidget {
  const AssetThumb(
      {super.key, required this.asset, this.highlight = false});

  final Asset asset;
  final bool highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = asset.photoLocalPath;
    if (local != null && File(local).existsSync()) {
      return _round(Image.file(File(local), fit: BoxFit.cover));
    }
    if (asset.photoPath != null) {
      final url =
          ref.watch(photoSignedUrlProvider(asset.photoPath!)).value;
      if (url != null) {
        return _round(Image.network(url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback()));
      }
    }
    return _fallback();
  }

  Widget _round(Widget child) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 40, height: 40, child: child),
      );

  Widget _fallback() => Icon(
        highlight ? Icons.center_focus_strong : Icons.qr_code_2,
        color: asset.status == 'available'
            ? Colors.green
            : asset.status == 'rented'
                ? Colors.orange
                : Colors.grey,
      );
}
