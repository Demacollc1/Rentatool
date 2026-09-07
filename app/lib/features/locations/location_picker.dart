import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/repositories/location_repository.dart';

/// Selector jerárquico de ubicación. Devuelve el id elegido o null.
Future<String?> pickLocation(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _LocationPickerSheet(),
  );
}

class _LocationPickerSheet extends ConsumerStatefulWidget {
  const _LocationPickerSheet();

  @override
  ConsumerState<_LocationPickerSheet> createState() =>
      _LocationPickerSheetState();
}

class _LocationPickerSheetState
    extends ConsumerState<_LocationPickerSheet> {
  final List<Location> _stack = [];

  @override
  Widget build(BuildContext context) {
    final parentId = _stack.isEmpty ? null : _stack.last.id;
    final children = ref.watch(locationChildrenProvider(parentId));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (ctx, scroll) => Column(children: [
        ListTile(
          leading: _stack.isEmpty
              ? const Icon(Icons.place)
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      setState(() => _stack.removeLast()),
                ),
          title: Text(_stack.isEmpty
              ? 'Elige la ubicación'
              : _stack.map((l) => l.name).join(' > ')),
          trailing: _stack.isEmpty
              ? null
              : FilledButton(
                  onPressed: () =>
                      Navigator.pop(context, _stack.last.id),
                  child: const Text('Elegir aquí'),
                ),
        ),
        const Divider(height: 1),
        Expanded(
          child: children.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) => ListView(
              controller: scroll,
              children: [
                if (list.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Sin sub-ubicaciones aquí. Usa '
                        '"Elegir aquí" o crea ubicaciones en la '
                        'pantalla de Ubicaciones.'),
                  ),
                for (final l in list)
                  ListTile(
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(l.name),
                    subtitle: Text(
                        locationLevels[
                            l.level.clamp(0, locationLevels.length - 1)],
                        style: const TextStyle(fontSize: 11)),
                    trailing: TextButton(
                      onPressed: () => Navigator.pop(context, l.id),
                      child: const Text('Elegir'),
                    ),
                    onTap: () => setState(() => _stack.add(l)),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
