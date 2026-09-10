import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/rental_repository.dart';
import '../../data/sync/sync_service.dart';
import '../catalog/model_detail_screen.dart' show AssetSheet;
import '../rentals/rentals_screen.dart' show quickNewContract;

final _money = NumberFormat.currency(locale: 'es_EC', symbol: r'$');

const statusLabels = {
  'available': 'Disponible',
  'reserved': 'Reservado',
  'rented': 'Rentado',
  'maintenance': 'Mantenimiento',
  'quarantine': 'Cuarentena',
  'retired': 'De baja',
};

/// KPIs del negocio: cotizados sin contratar, por vencer y cuarentena.
class _KpiPill extends ConsumerWidget {
  const _KpiPill({required this.quarantine});

  final int quarantine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drafts =
        ref.watch(contractsProvider('draft')).value ?? const [];
    final actives =
        ref.watch(contractsProvider('active')).value ?? const [];
    final limite = DateTime.now().add(const Duration(days: 2));
    final porVencer = actives
        .where((v) =>
            v.contract.dueAt != null &&
            v.contract.dueAt!.isBefore(limite))
        .length;
    return Card(
      color: AppTheme.ink,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          _kpi(context, '${drafts.length}', 'Cotizados\nsin contratar',
              Icons.edit_note, Colors.amber, '/rentals'),
          _divider(),
          _kpi(context, '$porVencer', 'Contratos\npor vencer',
              Icons.timer_outlined,
              porVencer > 0 ? Colors.redAccent : Colors.white70,
              '/rentals'),
          _divider(),
          _kpi(context, '$quarantine', 'Herramientas\nen cuarentena',
              Icons.gpp_maybe_outlined,
              quarantine > 0 ? Colors.orange : Colors.white70,
              '/catalog'),
        ]),
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 44, color: Colors.white12);

  Widget _kpi(BuildContext context, String value, String label,
          IconData icon, Color color, String route) =>
      Expanded(
        child: InkWell(
          onTap: () => context.go(route),
          child: Column(children: [
            Icon(icon, color: color, size: 18),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w900)),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 10)),
          ]),
        ),
      );
}

/// Tarjeta de acción del grid del Inicio.
class _ActionCard extends StatelessWidget {
  const _ActionCard(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.onTap});

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            CircleAvatar(
              backgroundColor: AppTheme.yellow.withValues(alpha: .2),
              child: Icon(icon, color: AppTheme.ink, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                    Text(subtitle,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 10)),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Selector de producto para el alta rápida de unidad.
class _ModelPicker extends ConsumerStatefulWidget {
  const _ModelPicker();

  @override
  ConsumerState<_ModelPicker> createState() => _ModelPickerState();
}

class _ModelPickerState extends ConsumerState<_ModelPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final models = ref.watch(toolModelsProvider(_query));
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (ctx, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscar producto por código o nombre',
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
              controller: scroll,
              itemCount: list.length > 80 ? 80 : list.length,
              itemBuilder: (_, i) => ListTile(
                dense: true,
                leading: CircleAvatar(
                    radius: 20,
                    child: Text(list[i].ratCode ?? '?',
                        style: const TextStyle(fontSize: 8))),
                title: Text(list[i].name,
                    style: const TextStyle(fontSize: 13)),
                onTap: () => Navigator.pop(context, list[i]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _syncing = false;

  /// Alta rápida de unidad: elige el producto y abre la ficha de la
  /// unidad (con OCR de etiqueta y QR al guardar).
  Future<void> _quickAddUnit(BuildContext context) async {
    final model = await showModalBottomSheet<ToolModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ModelPicker(),
    );
    if (model == null || !context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AssetSheet(model: model),
    );
  }

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
        bottom: const HazardStripe(),
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
                              const Text('Capital en herramientas',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
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
                      // ── Píldora de KPIs ──
                      _KpiPill(
                          quarantine: byStatus['quarantine'] ?? 0),
                      const SizedBox(height: 12),
                      // ── Acciones rápidas ──
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.9,
                        children: [
                          _ActionCard(
                            icon: Icons.receipt_long,
                            label: 'Contrato rápido',
                            subtitle: 'Cliente → obra → responsable',
                            onTap: () =>
                                quickNewContract(context, ref),
                          ),
                          _ActionCard(
                            icon: Icons.add_box_outlined,
                            label: 'Ingresar unidad',
                            subtitle: 'Alta de inventario con QR',
                            onTap: () => _quickAddUnit(context),
                          ),
                        ],
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
