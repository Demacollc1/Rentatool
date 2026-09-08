import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../catalog/category_tree_picker.dart';

/// Categorización masiva: ver las categorías de cada producto y
/// asignar a varios productos a la vez.
class ProductCategorizationScreen extends ConsumerStatefulWidget {
  const ProductCategorizationScreen({super.key});

  @override
  ConsumerState<ProductCategorizationScreen> createState() =>
      _ProductCategorizationScreenState();
}

class _ProductCategorizationScreenState
    extends ConsumerState<ProductCategorizationScreen> {
  String _query = '';
  final Set<String> _picked = {};
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final models = ref.watch(toolModelsProvider(_query));
    final cats = ref.watch(categoriesProvider);
    final links = ref.watch(allModelCategoriesProvider).value ?? {};
    final byId = {for (final c in cats.value ?? <Category>[]) c.id: c};

    String label(String id) {
      final c = byId[id];
      if (c == null) return '?';
      final parent = c.parentId == null ? null : byId[c.parentId!];
      return parent == null ? c.name : '${parent.name} › ${c.name}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_picked.isEmpty
            ? 'Categorización de productos'
            : '${_picked.length} seleccionados'),
        actions: [
          if (_picked.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Limpiar selección',
              onPressed: () => setState(() => _picked.clear()),
            ),
        ],
      ),
      floatingActionButton: _picked.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _busy ? null : _bulkAssign,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.category),
              label: Text('Categorizar (${_picked.length})'),
            ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar producto',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: models.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) => ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final m = list[i];
                final linked = links[m.id] ?? const <String>{};
                final effective = linked.isNotEmpty
                    ? linked
                    : {if (m.categoryId != null) m.categoryId!};
                return CheckboxListTile(
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _picked.contains(m.id),
                  onChanged: (v) => setState(() => v == true
                      ? _picked.add(m.id)
                      : _picked.remove(m.id)),
                  title: Text(
                      '${m.ratCode != null ? '${m.ratCode} · ' : ''}${m.name}',
                      style: const TextStyle(fontSize: 13)),
                  subtitle: Wrap(
                    spacing: 4,
                    children: [
                      if (effective.isEmpty)
                        const Text('Sin categorías',
                            style: TextStyle(
                                fontSize: 10, color: Colors.orange))
                      else
                        for (final id in effective)
                          Text(label(id),
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade700)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _bulkAssign() async {
    final picked = await pickCategorySet(context, ref,
        initial: {},
        title: 'Categorías para ${_picked.length} productos');
    if (picked == null || picked.isEmpty || !mounted) return;

    // ¿Agregar a las existentes o reemplazarlas?
    final mode = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('¿Cómo aplicar?'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'add'),
            child: const ListTile(
                leading: Icon(Icons.add),
                title: Text('Agregar a las categorías actuales')),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'replace'),
            child: const ListTile(
                leading: Icon(Icons.swap_horiz),
                title: Text('Reemplazar las categorías actuales')),
          ),
        ],
      ),
    );
    if (mode == null || !mounted) return;

    setState(() => _busy = true);
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final links =
          ref.read(allModelCategoriesProvider).value ?? const {};
      for (final modelId in _picked) {
        final current = mode == 'add'
            ? {...(links[modelId] ?? const <String>{}), ...picked}
            : picked;
        await repo.setModelCategories(modelId, current);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                '${_picked.length} productos categorizados ✔')));
        setState(() => _picked.clear());
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
