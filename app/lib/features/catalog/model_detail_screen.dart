import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/location_repository.dart';
import '../../data/repositories/supplier_repository.dart';
import '../dashboard/dashboard_screen.dart' show statusLabels;
import '../labels/qr_labels_pdf.dart';
import '../locations/location_picker.dart';
import 'product_sheet.dart';

class ModelDetailScreen extends ConsumerWidget {
  const ModelDetailScreen({super.key, required this.modelId});

  final String modelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(toolModelProvider(modelId));
    final units = ref.watch(modelAssetsProvider(modelId));
    final consumables = ref.watch(modelConsumablesProvider(modelId));

    return model.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (m) {
        if (m == null) {
          return const Scaffold(
              body: Center(child: Text('Modelo no encontrado')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(m.ratCode == null ? m.name : '${m.ratCode} · ${m.name}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Editar producto',
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => ProductSheet(existing: m),
                ).then((_) =>
                    ref.invalidate(toolModelProvider(modelId))),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => AssetSheet(model: m),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Unidad'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.description ?? m.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      Text(
                          [
                            m.line == 'ind'
                                ? 'Línea industrial'
                                : 'Línea DIY',
                            if (m.brand != null) m.brand!,
                            if (m.supplierCode != null)
                              'Cód. proveedor: ${m.supplierCode}',
                            if (m.variant != null) m.variant!,
                          ].join(' · '),
                          style: const TextStyle(fontSize: 12)),
                      if (m.canonicalCode != null)
                        Text(
                            'Canónico ${m.canonicalCode} — '
                            '${m.canonicalName ?? ''}',
                            style: const TextStyle(fontSize: 11)),
                      if (m.spec?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(m.spec!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700)),
                        ),
                      const Divider(),
                      Text('Costo de referencia: '
                          '\$${m.listCost.toStringAsFixed(2)}'
                          '${m.b87Qty > 0 ? ' · B87: ${m.b87Qty.toStringAsFixed(0)} u.' : ''}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _RatesCard(model: m),
              const SizedBox(height: 8),
              consumables.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
                data: (list) => list.isEmpty
                    ? const SizedBox.shrink()
                    : Card(
                        child: Column(children: [
                          const ListTile(
                              dense: true,
                              title: Text('Consumibles del equipo',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          for (final c in list)
                            ListTile(
                              dense: true,
                              leading: const Icon(
                                  Icons.circle_outlined,
                                  size: 16),
                              title: Text(c.name,
                                  style:
                                      const TextStyle(fontSize: 13)),
                              subtitle: Text(c.code ?? '',
                                  style:
                                      const TextStyle(fontSize: 11)),
                              trailing: Text(
                                  '\$${c.cost.toStringAsFixed(2)}'),
                            ),
                        ]),
                      ),
              ),
              const SizedBox(height: 8),
              units.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (list) => Card(
                  child: Column(children: [
                    ListTile(
                      dense: true,
                      title: Text('Unidades físicas (${list.length})',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      trailing: list.isEmpty
                          ? null
                          : TextButton.icon(
                              onPressed: () =>
                                  _printLabels(context, ref, m, list),
                              icon: const Icon(Icons.qr_code, size: 18),
                              label: const Text('Etiquetas'),
                            ),
                    ),
                    if (list.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Aún no hay unidades. Usa "+ Unidad" '
                            'para registrar cada equipo físico y '
                            'generar su etiqueta QR.'),
                      ),
                    for (final a in list) _AssetTile(asset: a),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _printLabels(BuildContext context, WidgetRef ref,
      ToolModel m, List<Asset> list) async {
    final locRepo = ref.read(locationRepositoryProvider);
    final labels = <QrLabel>[];
    for (final a in list) {
      final path = a.locationId == null
          ? null
          : await locRepo.fullPath(a.locationId!);
      final brandModel =
          '${a.brand ?? ''} ${a.mfrModel ?? ''}'.trim();
      labels.add(QrLabel(
        title:
            '${a.assetTag}${brandModel.isEmpty ? '' : ' · $brandModel'}',
        subtitle: [
          if (m.ratCode != null) m.ratCode!,
          m.name,
          if (a.serial?.isNotEmpty ?? false) 'SN ${a.serial}',
          if (path != null && path.isNotEmpty) path,
        ].join(' · '),
        data: qrForAssetFull(
          id: a.id,
          ratCode: m.ratCode,
          brandModel: brandModel,
          lote: a.assetTag,
          serial: a.serial,
        ),
      ));
    }
    final pdf = await buildQrLabelsPdf(
      title: m.name,
      labels: labels,
      fileName: 'etiquetas_${m.supplierCode ?? m.id}',
    );
    await SharePlus.instance.share(ShareParams(files: [XFile(pdf)]));
  }
}

class _RatesCard extends ConsumerWidget {
  const _RatesCard({required this.model});

  final ToolModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rates = [
      ('4 horas', model.rateHalfDay),
      ('Día', model.rateDay),
      ('Semana', model.rateWeek),
      ('Mes', model.rateMonth),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('Tarifas de renta',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _editRates(context, ref),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Editar'),
              ),
            ]),
            Row(
              children: [
                for (final (label, value) in rates)
                  Expanded(
                    child: Column(children: [
                      Text(label,
                          style: const TextStyle(fontSize: 11)),
                      Text(
                          value == null
                              ? '—'
                              : '\$${value.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editRates(BuildContext context, WidgetRef ref) async {
    final half = TextEditingController(
        text: model.rateHalfDay?.toStringAsFixed(2) ?? '');
    final day = TextEditingController(
        text: model.rateDay?.toStringAsFixed(2) ?? '');
    final week = TextEditingController(
        text: model.rateWeek?.toStringAsFixed(2) ?? '');
    final month = TextEditingController(
        text: model.rateMonth?.toStringAsFixed(2) ?? '');
    double? parse(TextEditingController c) =>
        double.tryParse(c.text.replaceAll(',', '.'));
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tarifas de renta'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: half,
              decoration:
                  const InputDecoration(labelText: '4 horas (\$)')),
          TextField(
              controller: day,
              decoration: const InputDecoration(labelText: 'Día (\$)')),
          TextField(
              controller: week,
              decoration:
                  const InputDecoration(labelText: 'Semana (\$)')),
          TextField(
              controller: month,
              decoration: const InputDecoration(labelText: 'Mes (\$)')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Guardar')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(catalogRepositoryProvider).saveModel(
          id: model.id,
          name: model.name,
          spec: model.spec,
          line: model.line,
          brand: model.brand,
          supplierCode: model.supplierCode,
          description: model.description,
          categoryId: model.categoryId,
          listCost: model.listCost,
          rateHalfDay: parse(half),
          rateDay: parse(day),
          rateWeek: parse(week),
          rateMonth: parse(month),
          b87Qty: model.b87Qty,
          published: model.published,
          notes: model.notes,
        );
    ref.invalidate(toolModelProvider(model.id));
  }
}

class _AssetTile extends ConsumerWidget {
  const _AssetTile({required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = asset.locationId == null
        ? null
        : ref.watch(locationPathProvider(asset.locationId!)).value;
    return ListTile(
      dense: true,
      leading: Icon(
        Icons.qr_code_2,
        color: asset.status == 'available'
            ? Colors.green
            : asset.status == 'rented'
                ? Colors.orange
                : Colors.grey,
      ),
      title: Text(
          [
            asset.assetTag,
            if (asset.brand != null || asset.mfrModel != null)
              '${asset.brand ?? ''} ${asset.mfrModel ?? ''}'.trim(),
          ].join(' · '),
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        [
          statusLabels[asset.status] ?? asset.status,
          if (path != null && path.isNotEmpty) path,
          if (asset.serial?.isNotEmpty ?? false) 'S/N ${asset.serial}',
        ].join(' · '),
        style: const TextStyle(fontSize: 11),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (v) async {
          final repo = ref.read(catalogRepositoryProvider);
          if (v == 'move') {
            final locId = await pickLocation(context, ref);
            if (locId != null) await repo.moveAsset(asset.id, locId);
          } else {
            await repo.setAssetStatus(asset.id, v);
          }
        },
        itemBuilder: (_) => [
          const PopupMenuItem(
              value: 'move', child: Text('Mover de ubicación')),
          for (final s in statusLabels.entries)
            if (s.key != asset.status)
              PopupMenuItem(
                  value: s.key, child: Text('Marcar ${s.value}')),
        ],
      ),
    );
  }
}

/// Alta/edición de unidad física con etiqueta inmediata.
class AssetSheet extends ConsumerStatefulWidget {
  const AssetSheet({super.key, required this.model});

  final ToolModel model;

  @override
  ConsumerState<AssetSheet> createState() => _AssetSheetState();
}

class _AssetSheetState extends ConsumerState<AssetSheet> {
  final _serial = TextEditingController();
  final _invoice = TextEditingController();
  final _brand = TextEditingController();
  final _mfrModel = TextEditingController();
  late final TextEditingController _cost = TextEditingController(
      text: widget.model.listCost.toStringAsFixed(2));
  String? _locationId;
  String? _locationPath;
  String? _supplierId;
  String? _supplierName;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nueva unidad — ${widget.model.name}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _brand,
                  decoration:
                      const InputDecoration(labelText: 'Marca *',
                          hintText: 'DeWalt, Bosch…'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _mfrModel,
                  decoration: const InputDecoration(
                      labelText: 'Modelo *', hintText: 'D28114'),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            TextField(
              controller: _serial,
              decoration: const InputDecoration(
                  labelText: 'Número de serie (opcional)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cost,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Costo de compra (\$)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _invoice,
              decoration: const InputDecoration(
                  labelText: 'N° de factura de compra (opcional)'),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.business_outlined),
              title: Text(_supplierName ?? 'Sin proveedor'),
              trailing: TextButton(
                onPressed: () async {
                  final id = await pickSupplier(context, ref);
                  if (id != null && mounted) {
                    final s = await ref
                        .read(supplierRepositoryProvider)
                        .getById(id);
                    setState(() {
                      _supplierId = id;
                      _supplierName = s?.name;
                    });
                  }
                },
                child: const Text('Elegir'),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.place_outlined),
              title: Text(_locationPath ?? 'Sin ubicación'),
              trailing: TextButton(
                onPressed: () async {
                  final id = await pickLocation(context, ref);
                  if (id != null && mounted) {
                    final path = await ref
                        .read(locationRepositoryProvider)
                        .fullPath(id);
                    setState(() {
                      _locationId = id;
                      _locationPath = path;
                    });
                  }
                },
                child: const Text('Elegir'),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.qr_code),
              label: const Text('Registrar y generar etiqueta'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final tag = await repo.nextAssetTag();
      final id = await repo.createAsset(
        toolModelId: widget.model.id,
        assetTag: tag,
        serial: _serial.text.trim().isEmpty ? null : _serial.text.trim(),
        locationId: _locationId,
        purchaseCost:
            double.tryParse(_cost.text.replaceAll(',', '.')) ?? 0,
        purchaseDate: DateTime.now(),
        supplierId: _supplierId,
        invoiceNumber:
            _invoice.text.trim().isEmpty ? null : _invoice.text.trim(),
        brand: _brand.text.trim().isEmpty ? null : _brand.text.trim(),
        mfrModel: _mfrModel.text.trim().isEmpty
            ? null
            : _mfrModel.text.trim(),
      );
      final brandModel =
          '${_brand.text.trim()} ${_mfrModel.text.trim()}'.trim();
      final pdf = await buildQrLabelsPdf(
        title: widget.model.name,
        labels: [
          QrLabel(
            title: '$tag${brandModel.isEmpty ? '' : ' · $brandModel'}',
            subtitle: [
              if (widget.model.ratCode != null) widget.model.ratCode!,
              widget.model.name,
              if (_serial.text.trim().isNotEmpty)
                'SN ${_serial.text.trim()}',
              if (_locationPath != null) _locationPath!,
            ].join(' · '),
            data: qrForAssetFull(
              id: id,
              ratCode: widget.model.ratCode,
              brandModel: brandModel,
              lote: tag,
              serial: _serial.text.trim(),
            ),
          ),
        ],
        fileName: 'etiqueta_$tag',
      );
      if (!mounted) return;
      Navigator.pop(context);
      await SharePlus.instance.share(ShareParams(files: [XFile(pdf)]));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
