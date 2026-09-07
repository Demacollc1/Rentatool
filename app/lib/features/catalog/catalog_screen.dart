import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/category_repository.dart';
import 'product_sheet.dart';

/// Catálogo agrupado oficio → grupo, con búsqueda.
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final models = ref.watch(toolModelsProvider(_query));
    final cats = ref.watch(categoriesProvider);
    final assets = ref.watch(allAssetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de renta')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const ProductSheet(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Producto'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar por nombre, código o marca',
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
            data: (list) {
              final catList = cats.value ?? <Category>[];
              final byId = {for (final c in catList) c.id: c};
              final assetList = assets.value ?? <Asset>[];
              final unitsByModel = <String, List<Asset>>{};
              for (final a in assetList) {
                unitsByModel.putIfAbsent(a.toolModelId, () => []).add(a);
              }
              // Agrupa por oficio raíz.
              final byOficio = <String, List<ToolModel>>{};
              for (final m in list) {
                String? cid = m.categoryId;
                while (
                    cid != null && byId[cid]?.parentId != null) {
                  cid = byId[cid]!.parentId;
                }
                final name = byId[cid]?.name ?? 'Sin oficio';
                byOficio.putIfAbsent(name, () => []).add(m);
              }
              final oficios = byOficio.keys.toList()..sort();
              if (list.isEmpty) {
                return const Center(
                    child: Text('Sin modelos. Importa el portafolio '
                        'desde el dashboard.'));
              }
              return ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  for (final oficio in oficios)
                    ExpansionTile(
                      initiallyExpanded: _query.isNotEmpty,
                      title: Text(oficio,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          '${byOficio[oficio]!.length} modelos',
                          style: const TextStyle(fontSize: 11)),
                      children: [
                        for (final m in byOficio[oficio]!)
                          _ModelTile(
                            model: m,
                            units: unitsByModel[m.id] ?? const [],
                          ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _ModelTile extends StatelessWidget {
  const _ModelTile({required this.model, required this.units});

  final ToolModel model;
  final List<Asset> units;

  @override
  Widget build(BuildContext context) {
    final available =
        units.where((a) => a.status == 'available').length;
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor:
            model.line == 'ind' ? Colors.amber.shade700 : Colors.blueGrey,
        child: Text(model.line == 'ind' ? 'IND' : 'DIY',
            style: const TextStyle(
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
      title: Text('${model.name} — ${model.brand ?? ''}'),
      subtitle: Text(
        [
          if (model.ratCode != null) model.ratCode!,
          if (model.supplierCode != null) model.supplierCode!,
          if (model.rateDay != null)
            '\$${model.rateDay!.toStringAsFixed(2)}/día',
          '${units.length} u. ($available disp.)',
        ].join(' · '),
        style: const TextStyle(fontSize: 11),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/catalog/model/${model.id}'),
    );
  }
}
