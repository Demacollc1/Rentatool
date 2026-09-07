import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/catalog_repository.dart';
import '../../data/seed/portfolio_importer.dart';

/// Importación de la semilla del portafolio DEMACO (una sola vez).
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  bool _busy = false;
  ImportSummary? _preview;
  ImportSummary? _done;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadPreview);
  }

  Future<void> _loadPreview() async {
    final importer = ref.read(portfolioImporterProvider);
    final data = await importer.loadRaw();
    if (mounted) {
      setState(() => _preview = importer.summarize(data));
    }
  }

  Future<void> _run() async {
    setState(() => _busy = true);
    try {
      final importer = ref.read(portfolioImporterProvider);
      final data = await importer.loadRaw();
      final result = await importer.import(data);
      if (mounted) setState(() => _done = result);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasModels =
        (ref.watch(toolModelsProvider('')).value ?? []).isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Importar portafolio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_done != null) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 40),
                    const SizedBox(height: 8),
                    Text('Importado: ${_done!.modelos} modelos, '
                        '${_done!.consumibles} consumibles, '
                        '${_done!.oficios} oficios.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.go('/catalog'),
                      child: const Text('Ver el catálogo'),
                    ),
                  ]),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Portafolio DEMACO',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (_preview == null)
                        const LinearProgressIndicator()
                      else ...[
                        Text('• ${_preview!.oficios} oficios'),
                        Text('• ${_preview!.filas} tipos de herramienta'),
                        Text(
                            '• ${_preview!.modelos} modelos con código '
                            '(líneas industrial y DIY)'),
                        Text(
                            '• ${_preview!.consumibles} consumibles'),
                        const SizedBox(height: 8),
                        const Text(
                            'Tarifas precargadas: 4h 14% · día 20% · '
                            'semana 70% · mes 200% del costo '
                            '(editables por modelo).',
                            style: TextStyle(fontSize: 12)),
                        const Text(
                            'No crea unidades físicas: esas se '
                            'registran al etiquetar cada equipo.',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (hasModels)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('El catálogo ya tiene modelos. '
                        'Reimportar es seguro (no duplica), pero '
                        'sobrescribirá tarifas editadas con las '
                        'precargadas.'),
                  ),
                ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _busy || _preview == null ? null : _run,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.upload_file),
                label: Text(_busy
                    ? 'Importando…'
                    : hasModels
                        ? 'Reimportar de todos modos'
                        : 'Importar ahora'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
