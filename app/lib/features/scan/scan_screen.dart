import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../data/repositories/catalog_repository.dart';

/// Escáner tri-rama: unidad (demaco:asset:), ubicación (demaco:loc:)
/// o cualquier otro código (consumible por código de barras).
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _handled = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;
    _handled = true;

    if (raw.startsWith('demaco:asset:')) {
      final id = raw.substring('demaco:asset:'.length);
      final asset = await ref.read(catalogRepositoryProvider).getAsset(id);
      if (!mounted) return;
      if (asset == null) {
        _notFound('Unidad no encontrada');
        return;
      }
      context.go('/catalog/model/${asset.toolModelId}');
      return;
    }
    if (raw.startsWith('demaco:loc:')) {
      final id = raw.substring('demaco:loc:'.length);
      if (!mounted) return;
      context.go('/locations/items/$id');
      return;
    }
    // Código de barras comercial → busca consumible.
    final matches = await ref
        .read(catalogRepositoryProvider)
        .watchConsumables(query: raw)
        .first;
    if (!mounted) return;
    if (matches.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${matches.first.name} — stock '
              '${matches.first.stock.toStringAsFixed(0)}')));
      context.pop();
    } else {
      _notFound('Código "$raw" no registrado');
    }
  }

  void _notFound(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
    setState(() => _handled = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear')),
      body: MobileScanner(onDetect: _onDetect),
    );
  }
}
