import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/canonical_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../core/theme.dart';
import 'product_sheet.dart';
import 'visuals.dart';

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
    final canonicals = ref.watch(canonicalsDbProvider(''));
    final modelCats =
        ref.watch(allModelCategoriesProvider).value ?? const {};
    final canonicalByCode = {
      for (final c in canonicals.value ?? <Canonical>[]) c.code: c
    };

    return Scaffold(
      appBar: AppBar(
        bottom: const HazardStripe(),
        title: const Text('Catálogo de renta'),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Configuración',
              onPressed: () => context.go('/settings')),
        ],
      ),
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
              // Agrupa oficio → subcategoría → productos. Los
              // vínculos n:m mandan; sin vínculo cae al oficio raíz
              // del import como "(directo)".
              const directo = '(directo en el oficio)';
              final tree = <String, Map<String, List<ToolModel>>>{};
              void add(String oficio, String sub, ToolModel m) {
                final subs = tree.putIfAbsent(oficio, () => {});
                final lista = subs.putIfAbsent(sub, () => []);
                if (!lista.any((x) => x.id == m.id)) lista.add(m);
              }

              for (final m in list) {
                final links = modelCats[m.id] ?? const <String>{};
                var colocado = false;
                for (final catId in links) {
                  final cat = byId[catId];
                  if (cat == null) continue;
                  if (cat.parentId != null) {
                    final root = byId[cat.parentId!];
                    add(root?.name ?? 'Sin oficio', cat.name, m);
                  } else {
                    add(cat.name, directo, m);
                  }
                  colocado = true;
                }
                if (!colocado) {
                  String? cid = m.categoryId;
                  while (cid != null && byId[cid]?.parentId != null) {
                    cid = byId[cid]!.parentId;
                  }
                  add(byId[cid ?? '']?.name ?? 'Sin oficio', directo, m);
                }
              }
              final oficios = tree.keys.toList()..sort();
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
                      leading: CircleAvatar(
                        backgroundColor:
                            AppTheme.blue.withValues(alpha: .12),
                        child: Icon(tradeIcon(oficio),
                            color: AppTheme.blue, size: 22),
                      ),
                      title: Text(oficio,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          '${tree[oficio]!.values.expand((l) => l).map((m) => m.id).toSet().length} modelos',
                          style: const TextStyle(fontSize: 11)),
                      children: [
                        for (final sub
                            in tree[oficio]!.keys.toList()..sort())
                          if (tree[oficio]!.length == 1 &&
                              sub == '(directo en el oficio)')
                            // Sin subcategorías: lista directa.
                            ...[
                            for (final m in tree[oficio]![sub]!)
                              _ModelTile(
                                model: m,
                                units:
                                    unitsByModel[m.id] ?? const [],
                                canonical: m.canonicalCode == null
                                    ? null
                                    : canonicalByCode[
                                        m.canonicalCode],
                              ),
                          ] else
                            ExpansionTile(
                              initiallyExpanded: _query.isNotEmpty,
                              tilePadding: const EdgeInsets.only(
                                  left: 28, right: 16),
                              childrenPadding:
                                  const EdgeInsets.only(left: 12),
                              leading: const Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 18),
                              title: Text(sub,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${tree[oficio]![sub]!.length} '
                                  'modelos',
                                  style:
                                      const TextStyle(fontSize: 10)),
                              children: [
                                for (final m in tree[oficio]![sub]!)
                                  _ModelTile(
                                    model: m,
                                    units: unitsByModel[m.id] ??
                                        const [],
                                    canonical: m.canonicalCode == null
                                        ? null
                                        : canonicalByCode[
                                            m.canonicalCode],
                                  ),
                              ],
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
  const _ModelTile(
      {required this.model, required this.units, this.canonical});

  final ToolModel model;
  final List<Asset> units;
  final Canonical? canonical;

  @override
  Widget build(BuildContext context) {
    final available =
        units.where((a) => a.status == 'available').length;
    return ListTile(
      dense: true,
      leading: productAvatar(model, canonical),
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
