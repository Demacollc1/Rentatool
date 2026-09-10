import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart' show HazardStripe;
import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/maintenance_repository.dart';
import '../locations/location_picker.dart';

/// F4 — Cuarentena y mantenimiento: revisar lo devuelto, órdenes con
/// costos y horómetro, preventivos por plan, y re-almacenamiento.
class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(allAssetsProvider).value ?? const [];
    final enCuarentena =
        assets.where((a) => a.status == 'quarantine').toList();
    final abiertas =
        ref.watch(maintenanceOrdersProvider('open')).value ?? const [];
    final cerradas =
        ref.watch(maintenanceOrdersProvider('done')).value ?? const [];
    final vencidos = ref.watch(duePreventivesProvider).value ?? const [];
    final money = NumberFormat.currency(symbol: r'$');

    return Scaffold(
      appBar: AppBar(
        bottom: const HazardStripe(),
        title: const Text('Cuarentena y mantenimiento'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          // ── Cuarentena ──
          _section('En cuarentena (por revisar)', enCuarentena.length),
          if (enCuarentena.isEmpty)
            const _Empty('Nada en cuarentena. Las devoluciones '
                'aprobadas sin escaneo llegan aquí.'),
          for (final a in enCuarentena)
            _AssetRow(
              asset: a,
              trailing: FilledButton.tonal(
                onPressed: () => _openOrder(context, ref, a),
                child: const Text('Revisar'),
              ),
            ),

          // ── Preventivos vencidos ──
          _section('Preventivos por ejecutar', vencidos.length),
          if (vencidos.isEmpty)
            const _Empty('Ningún plan preventivo vencido. Los planes '
                'se configuran en cada producto.'),
          for (final d in vencidos)
            ListTile(
              dense: true,
              leading: const Icon(Icons.schedule, color: Colors.orange),
              title: Text('${d.asset.assetTag} · ${d.plan.name}',
                  style: const TextStyle(fontSize: 13)),
              subtitle: Text(
                  '${d.model?.name ?? ''} · ${d.reason}',
                  style: const TextStyle(fontSize: 11)),
              trailing: OutlinedButton(
                onPressed: () => _openOrder(context, ref, d.asset,
                    kind: 'preventivo',
                    notes: 'Plan: ${d.plan.name}'),
                child: const Text('Abrir orden'),
              ),
            ),

          // ── Órdenes abiertas ──
          _section('Órdenes en curso', abiertas.length),
          if (abiertas.isEmpty)
            const _Empty('Sin órdenes en curso.'),
          for (final o in abiertas)
            ListTile(
              dense: true,
              leading: const Icon(Icons.build_circle_outlined),
              title: Text(
                  '${o.asset?.assetTag ?? ''} · '
                  '${_kindLabel(o.order.kind)}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: Text(
                  '${o.model?.name ?? ''}\n'
                  'Abierta ${DateFormat('dd/MM HH:mm').format(o.order.openedAt)}'
                  '${o.order.notes == null ? '' : ' · ${o.order.notes}'}',
                  style: const TextStyle(fontSize: 11)),
              isThreeLine: true,
              trailing: FilledButton(
                onPressed: () => _closeOrder(context, ref, o),
                child: const Text('Completar'),
              ),
            ),

          // ── Historial ──
          _section('Órdenes cerradas', cerradas.length),
          for (final o in cerradas.take(20))
            ListTile(
              dense: true,
              leading: const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 20),
              title: Text(
                  '${o.asset?.assetTag ?? ''} · '
                  '${_kindLabel(o.order.kind)} · '
                  '${money.format(o.order.totalCost)}',
                  style: const TextStyle(fontSize: 13)),
              subtitle: Text(
                  '${o.order.closedAt == null ? '' : DateFormat('dd/MM/yyyy').format(o.order.closedAt!)}'
                  ' · MO ${money.format(o.order.laborCost)}'
                  ' · Rep ${money.format(o.order.partsCost)}'
                  '${o.order.hoursMeter == null ? '' : ' · ${o.order.hoursMeter!.toStringAsFixed(0)} h'}',
                  style: const TextStyle(fontSize: 11)),
            ),
        ],
      ),
    );
  }

  static String _kindLabel(String k) => switch (k) {
        'preventivo' => 'Preventivo',
        'correctivo' => 'Correctivo',
        _ => 'Revisión post-renta',
      };

  Widget _section(String titulo, int n) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
        child: Text('$titulo ($n)',
            style: const TextStyle(
                fontWeight: FontWeight.w800, fontSize: 14)),
      );

  Future<void> _openOrder(
      BuildContext context, WidgetRef ref, Asset asset,
      {String kind = 'revision', String? notes}) async {
    final err = await ref.read(maintenanceRepositoryProvider).openOrder(
        assetId: asset.id, kind: kind, notes: notes);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err ??
              '${asset.assetTag} en mantenimiento — orden abierta ✔')));
    }
  }

  Future<void> _closeOrder(
      BuildContext context, WidgetRef ref, OrderView o) async {
    final repo = ref.read(maintenanceRepositoryProvider);
    final asset = o.asset!;
    final labor = TextEditingController();
    final parts = TextEditingController();
    final other = TextEditingController();
    // Depreciación sugerida: 1% del costo de la unidad por revisión.
    final depre = TextEditingController(
        text: (asset.purchaseCost * 0.01).toStringAsFixed(2));
    final horas = TextEditingController(
        text: repo.estimatedHours(asset).toStringAsFixed(0));
    final notas = TextEditingController();
    var condition = 'good';
    var retirar = false;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Completar orden · ${asset.assetTag}'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  controller: labor,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Mano de obra (USD)')),
              TextField(
                  controller: parts,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Repuestos (USD)')),
              TextField(
                  controller: other,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Otros costos (USD)')),
              TextField(
                  controller: depre,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Depreciación (auto 1% del costo)')),
              TextField(
                  controller: horas,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: InputDecoration(
                      labelText: 'Horómetro (h)',
                      helperText: 'Actual '
                          '${asset.hoursMeter.toStringAsFixed(0)} h · '
                          'sugerido por fórmula',
                      helperMaxLines: 2)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'good', label: Text('Bien')),
                  ButtonSegment(value: 'fair', label: Text('Regular')),
                  ButtonSegment(value: 'poor', label: Text('Mala')),
                ],
                selected: {condition},
                onSelectionChanged: (s) =>
                    setState(() => condition = s.first),
                showSelectedIcon: false,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: retirar,
                title: const Text('Dar de baja (sin arreglo)',
                    style: TextStyle(fontSize: 13)),
                onChanged: (v) =>
                    setState(() => retirar = v ?? false),
              ),
              TextField(
                  controller: notas,
                  decoration: const InputDecoration(
                      labelText: 'Trabajo realizado / notas')),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Cerrar orden')),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;

    String? locationId;
    if (!retirar) {
      // Sale de cuarentena a su ubicación definitiva.
      locationId = await pickLocation(context, ref);
    }
    double n(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '.').trim()) ?? 0;
    final err = await repo.closeOrder(
      o.order.id,
      laborCost: n(labor),
      partsCost: n(parts),
      otherCost: n(other),
      depreciationCost: n(depre),
      hoursMeter: double.tryParse(horas.text.replaceAll(',', '.')),
      locationId: locationId,
      condition: condition,
      retire: retirar,
      notes: notas.text.trim().isEmpty ? null : notas.text.trim(),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err ??
              (retirar
                  ? 'Unidad dada de baja — orden cerrada ✔'
                  : 'Orden cerrada ✔ — unidad disponible en su '
                      'ubicación'))));
    }
  }
}

class _AssetRow extends ConsumerWidget {
  const _AssetRow({required this.asset, required this.trailing});

  final Asset asset;
  final Widget trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref
        .watch(toolModelProvider(asset.toolModelId))
        .value;
    return ListTile(
      dense: true,
      leading: const Icon(Icons.gpp_maybe, color: Colors.orange),
      title: Text(
          '${asset.assetTag} · '
          '${[asset.brand, asset.mfrModel].whereType<String>().join(' ')}',
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text(model?.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11)),
      trailing: trailing,
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Text(texto,
            style: TextStyle(
                fontSize: 12, color: Colors.grey.shade600)),
      );
}
