import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/location_repository.dart';
import '../dashboard/dashboard_screen.dart' show statusLabels;

/// Unidades y consumibles guardados en una ubicación.
class ItemsByLocationScreen extends ConsumerWidget {
  const ItemsByLocationScreen({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(locationPathProvider(locationId));
    final assets = ref.watch(allAssetsProvider);
    final consumables = ref.watch(consumablesProvider(''));
    final models = ref.watch(toolModelsProvider(''));

    final assetList = (assets.value ?? <Asset>[])
        .where((a) => a.locationId == locationId)
        .toList();
    final consList = (consumables.value ?? <Consumable>[])
        .where((c) => c.locationId == locationId)
        .toList();
    final modelById = {
      for (final m in models.value ?? <ToolModel>[]) m.id: m
    };

    return Scaffold(
      appBar:
          AppBar(title: Text(path.value ?? 'Ubicación')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (assetList.isEmpty && consList.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Nada guardado en esta ubicación todavía.',
                  textAlign: TextAlign.center),
            ),
          for (final a in assetList)
            Card(
              child: ListTile(
                leading: const Icon(Icons.qr_code_2),
                title: Text(
                    '${a.assetTag} — ${modelById[a.toolModelId]?.name ?? ''}'),
                subtitle: Text(statusLabels[a.status] ?? a.status,
                    style: const TextStyle(fontSize: 11)),
                onTap: () =>
                    context.go('/catalog/model/${a.toolModelId}'),
              ),
            ),
          for (final c in consList)
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(c.name),
                subtitle: Text(
                    'Stock ${c.stock.toStringAsFixed(0)} ${c.unit}',
                    style: const TextStyle(fontSize: 11)),
              ),
            ),
        ],
      ),
    );
  }
}
