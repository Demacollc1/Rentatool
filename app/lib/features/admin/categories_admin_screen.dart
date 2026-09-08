import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/repositories/category_repository.dart';

/// Administración de categorías del catálogo: oficios (nivel 0) y
/// grupos de equipo (nivel 1).
class CategoriesAdminScreen extends ConsumerWidget {
  const CategoriesAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref, parent: null),
        icon: const Icon(Icons.add),
        label: const Text('Oficio'),
      ),
      body: cats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          final oficios = list.where((c) => c.level == 0).toList();
          final byParent = <String, List<Category>>{};
          for (final c in list.where((c) => c.level > 0)) {
            byParent.putIfAbsent(c.parentId ?? '', () => []).add(c);
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              for (final o in oficios)
                ExpansionTile(
                  leading: const Icon(Icons.engineering_outlined),
                  title: Text(o.name,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${byParent[o.id]?.length ?? 0} grupos',
                      style: const TextStyle(fontSize: 11)),
                  trailing: _menu(context, ref, o, isOficio: true),
                  children: [
                    for (final g in byParent[o.id] ?? <Category>[])
                      ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.only(left: 32, right: 8),
                        leading:
                            const Icon(Icons.label_outline, size: 18),
                        title: Text(g.name,
                            style: const TextStyle(fontSize: 13)),
                        trailing:
                            _menu(context, ref, g, isOficio: false),
                      ),
                    TextButton.icon(
                      onPressed: () =>
                          _edit(context, ref, parent: o),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Agregar grupo'),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _menu(BuildContext context, WidgetRef ref, Category c,
      {required bool isOficio}) {
    return PopupMenuButton<String>(
      onSelected: (v) async {
        final repo = ref.read(categoryRepositoryProvider);
        if (v == 'rename') {
          final name = await _ask(context, 'Renombrar', c.name);
          if (name != null) await repo.rename(c.id, name);
        } else if (v == 'delete') {
          final err = await repo.delete(c.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(err ?? '${c.name} eliminada ✔')));
          }
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'rename', child: Text('Renombrar')),
        PopupMenuItem(
            value: 'delete',
            child: Text('Eliminar (si no está en uso)')),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref,
      {Category? parent}) async {
    final name = await _ask(
        context,
        parent == null
            ? 'Nuevo oficio'
            : 'Nuevo grupo en ${parent.name}',
        '');
    if (name == null) return;
    await ref
        .read(categoryRepositoryProvider)
        .save(parentId: parent?.id, name: name);
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
}
