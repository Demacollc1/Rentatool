import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/repositories/category_repository.dart';

/// Selector de categorías en árbol (oficios y sus grupos) con
/// checkboxes. Devuelve el set elegido o null si se cancela.
Future<Set<String>?> pickCategorySet(
  BuildContext context,
  WidgetRef ref, {
  required Set<String> initial,
  String title = 'Categorías del producto',
}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _CategoryTreeSheet(initial: initial, title: title),
  );
}

class _CategoryTreeSheet extends ConsumerStatefulWidget {
  const _CategoryTreeSheet({required this.initial, required this.title});

  final Set<String> initial;
  final String title;

  @override
  ConsumerState<_CategoryTreeSheet> createState() =>
      _CategoryTreeSheetState();
}

class _CategoryTreeSheetState extends ConsumerState<_CategoryTreeSheet> {
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(categoriesProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (ctx, scroll) => Column(children: [
        ListTile(
          title: Text(widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: FilledButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: Text('Aplicar (${_selected.length})'),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: cats.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) {
              final oficios = list.where((c) => c.level == 0).toList()
                ..sort((a, b) => a.name.compareTo(b.name));
              final byParent = <String, List<Category>>{};
              for (final c in list.where((c) => c.level > 0)) {
                byParent
                    .putIfAbsent(c.parentId ?? '', () => [])
                    .add(c);
              }
              return ListView(
                controller: scroll,
                children: [
                  for (final o in oficios) ...[
                    CheckboxListTile(
                      dense: true,
                      controlAffinity:
                          ListTileControlAffinity.leading,
                      value: _selected.contains(o.id),
                      title: Text(o.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      onChanged: (v) => setState(() => v == true
                          ? _selected.add(o.id)
                          : _selected.remove(o.id)),
                    ),
                    for (final g in byParent[o.id] ?? <Category>[])
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: CheckboxListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          controlAffinity:
                              ListTileControlAffinity.leading,
                          value: _selected.contains(g.id),
                          title: Text(g.name,
                              style:
                                  const TextStyle(fontSize: 13)),
                          onChanged: (v) => setState(() => v == true
                              ? _selected.add(g.id)
                              : _selected.remove(g.id)),
                        ),
                      ),
                  ],
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}
