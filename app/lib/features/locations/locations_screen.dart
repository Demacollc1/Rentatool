import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/local/database.dart';
import '../../data/repositories/location_repository.dart';
import '../../data/sync/sync_service.dart';
import '../labels/qr_labels_pdf.dart';

/// Árbol de ubicaciones con navegación por niveles y etiquetas QR.
class LocationsScreen extends ConsumerStatefulWidget {
  const LocationsScreen({super.key});

  @override
  ConsumerState<LocationsScreen> createState() =>
      _LocationsScreenState();
}

class _LocationsScreenState extends ConsumerState<LocationsScreen> {
  final List<Location> _stack = [];

  @override
  Widget build(BuildContext context) {
    final parentId = _stack.isEmpty ? null : _stack.last.id;
    final depth = _stack.length;
    final children = ref.watch(locationChildrenProvider(parentId));

    return Scaffold(
      appBar: AppBar(
        title: Text(_stack.isEmpty
            ? 'Ubicaciones'
            : _stack.map((l) => l.name).join(' > ')),
        leading: _stack.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _stack.removeLast()),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            tooltip: 'Etiquetas QR de este nivel',
            onPressed: () => _printLabels(children.value ?? const []),
          ),
          IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Configuración',
              onPressed: () => context.go('/settings')),
        ],
      ),
      floatingActionButton: depth >= locationLevels.length
          ? null
          : FloatingActionButton.extended(
              onPressed: _create,
              icon: const Icon(Icons.add),
              label: Text(locationLevels[depth]),
            ),
      body: children.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => list.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    depth == 0
                        ? 'Crea tu primera ubicación (ej. "Showroom", '
                            '"Bodega B87") y dentro sus áreas, repisas '
                            'y niveles.'
                        : 'Sin sub-ubicaciones. Agrega '
                            '"${locationLevels[depth.clamp(0, locationLevels.length - 1)]}" '
                            'con el botón +.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.only(bottom: 88),
                children: [
                  for (final l in list)
                    ListTile(
                      leading: const Icon(Icons.place_outlined),
                      title: Text(l.name),
                      subtitle: Text(
                          locationLevels[l.level
                              .clamp(0, locationLevels.length - 1)],
                          style: const TextStyle(fontSize: 11)),
                      onTap: () => setState(() => _stack.add(l)),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) async {
                          final repo =
                              ref.read(locationRepositoryProvider);
                          if (v == 'rename') {
                            final name = await _ask(context,
                                'Renombrar', l.name);
                            if (name != null) {
                              await repo.rename(l.id, name);
                            }
                          } else if (v == 'label') {
                            await _printLabels([l]);
                          } else if (v == 'delete') {
                            await repo.softDelete(l.id);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                              value: 'rename',
                              child: Text('Renombrar')),
                          PopupMenuItem(
                              value: 'label',
                              child: Text('Etiqueta QR')),
                          PopupMenuItem(
                              value: 'delete', child: Text('Eliminar')),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _create() async {
    final depth = _stack.length;
    final name = await _ask(context,
        'Nueva ${locationLevels[depth]}', '');
    if (name == null) return;
    await ref.read(locationRepositoryProvider).save(
          parentId: _stack.isEmpty ? null : _stack.last.id,
          name: name,
        );
  }

  Future<void> _printLabels(List<Location> list) async {
    if (list.isEmpty) return;
    final repo = ref.read(locationRepositoryProvider);
    final labels = <QrLabel>[];
    for (final l in list) {
      labels.add(QrLabel(
        title: l.name,
        subtitle: await repo.fullPath(l.id),
        data: qrForLocation(l.id),
      ));
    }
    final (wMm, hMm) =
        await loadLabelSize(ref.read(syncServiceProvider));
    final pdf = await buildQrLabelsPdf(
      title: 'Ubicación',
      labels: labels,
      fileName: 'etiquetas_ubicaciones',
      widthMm: wMm,
      heightMm: hMm,
    );
    await SharePlus.instance.share(ShareParams(files: [XFile(pdf)]));
  }
}

Future<String?> _ask(
    BuildContext context, String title, String initial) async {
  final c = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(controller: c, autofocus: true),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () {
              final v = c.text.trim();
              Navigator.pop(ctx, v.isEmpty ? null : v);
            },
            child: const Text('Guardar')),
      ],
    ),
  );
}
