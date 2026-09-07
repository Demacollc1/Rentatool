import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/sync/sync_service.dart';

final _money = NumberFormat.currency(locale: 'es_EC', symbol: r'$');

const statusLabels = {
  'available': 'Disponible',
  'reserved': 'Reservado',
  'rented': 'Rentado',
  'maintenance': 'Mantenimiento',
  'retired': 'De baja',
};

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _syncing = false;

  Future<void> _sync() async {
    setState(() => _syncing = true);
    final r = await ref.read(syncServiceProvider).syncAll();
    if (!mounted) return;
    setState(() => _syncing = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(r.ok
            ? 'Sincronizado: ${r.pushed} subidos, ${r.pulled} bajados'
            : r.error!)));
  }

  @override
  Widget build(BuildContext context) {
    final models = ref.watch(toolModelsProvider(''));
    final assets = ref.watch(allAssetsProvider);
    final cats = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Icon(Icons.handyman, color: AppTheme.yellow),
          SizedBox(width: 8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('DEMACO RENT A TOOL',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, letterSpacing: 2)),
            ),
          ),
        ]),
        actions: [
          IconButton(
            icon: _syncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.yellow))
                : const Icon(Icons.sync),
            tooltip: 'Sincronizar',
            onPressed: _syncing ? null : _sync,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          models.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (modelList) {
              if (modelList.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      const Text('El catálogo está vacío.',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                          'Importa el portafolio DEMACO (92 modelos en '
                          '11 oficios con tarifas precargadas) para '
                          'arrancar.'),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => context.go('/import'),
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Importar portafolio'),
                      ),
                    ]),
                  ),
                );
              }
              return assets.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (assetList) {
                  final vivos = assetList
                      .where((a) => a.status != 'retired')
                      .toList();
                  final capital = vivos.fold<double>(
                      0, (s, a) => s + a.purchaseCost);
                  final byStatus = <String, int>{};
                  for (final a in assetList) {
                    byStatus[a.status] = (byStatus[a.status] ?? 0) + 1;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Capital ──
                      Card(
                        color: AppTheme.ink,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text('CAPITAL EN HERRAMIENTAS',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      letterSpacing: 2)),
                              Text(_money.format(capital),
                                  style: const TextStyle(
                                      color: AppTheme.yellow,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900)),
                              Text(
                                  '${vivos.length} unidades físicas · '
                                  '${modelList.length} modelos en catálogo',
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // ── Estados ──
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final s in statusLabels.entries)
                            Chip(
                              avatar: CircleAvatar(
                                backgroundColor: s.key == 'available'
                                    ? Colors.green
                                    : s.key == 'rented'
                                        ? Colors.orange
                                        : Colors.grey,
                                child: Text(
                                    '${byStatus[s.key] ?? 0}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white)),
                              ),
                              label: Text(s.value),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // ── Por oficio ──
                      cats.when(
                        loading: () => const SizedBox.shrink(),
                        error: (e, _) => const SizedBox.shrink(),
                        data: (catList) {
                          final oficios = catList
                              .where((c) => c.level == 0)
                              .toList();
                          final byCat = <String, int>{};
                          for (final m in modelList) {
                            // sube al oficio raíz
                            String? cid = m.categoryId;
                            final byId = {
                              for (final c in catList) c.id: c
                            };
                            while (cid != null &&
                                byId[cid]?.parentId != null) {
                              cid = byId[cid]!.parentId;
                            }
                            if (cid != null) {
                              byCat[cid] = (byCat[cid] ?? 0) + 1;
                            }
                          }
                          return Card(
                            child: Column(children: [
                              const ListTile(
                                  title: Text('Modelos por oficio',
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold))),
                              for (final o in oficios)
                                if ((byCat[o.id] ?? 0) > 0)
                                  ListTile(
                                    dense: true,
                                    title: Text(o.name),
                                    trailing: Text('${byCat[o.id]}',
                                        style: const TextStyle(
                                            fontWeight:
                                                FontWeight.bold)),
                                  ),
                            ]),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
