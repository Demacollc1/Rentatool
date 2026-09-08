import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/ocr/label_parser.dart';

import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/location_repository.dart';
import '../../data/repositories/supplier_repository.dart';
import '../dashboard/dashboard_screen.dart' show statusLabels;
import '../labels/qr_labels_pdf.dart';
import '../locations/location_picker.dart';
import 'category_tree_picker.dart';
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
                      Text(m.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      Text(
                          [
                            m.line == 'ind'
                                ? 'Línea industrial'
                                : 'Línea DIY',
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
                      if ((m.description?.isNotEmpty ?? false) ||
                          m.supplierCode != null) ...[
                        const SizedBox(height: 8),
                        const Text('Modelos de referencia',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        for (final line in (m.description ?? '')
                            .split('\n')
                            .where((l) => l.trim().isNotEmpty))
                          Text('• ${line.trim()}',
                              style: const TextStyle(fontSize: 12)),
                        if (m.supplierCode != null)
                          Text(
                              '• Compra preferida: '
                              '${m.brand ?? ''} ${m.supplierCode}'.trim(),
                              style: const TextStyle(fontSize: 12)),
                      ],
                      const Divider(),
                      Text('Costo de referencia: '
                          '\$${m.listCost.toStringAsFixed(2)}'
                          '${m.b87Qty > 0 ? ' · B87: ${m.b87Qty.toStringAsFixed(0)} u.' : ''}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _CategoriesCard(model: m),
              const SizedBox(height: 8),
              _AttributesCard(model: m),
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

/// Categorías del producto (oficios y subgrupos), selección múltiple.
class _CategoriesCard extends ConsumerWidget {
  const _CategoriesCard({required this.model});

  final ToolModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(categoriesProvider);
    final selected =
        ref.watch(modelCategoryIdsProvider(model.id)).value ?? {};
    final byId = {for (final c in cats.value ?? <Category>[]) c.id: c};

    // Sin vínculos aún: hereda la categoría del import como efectiva.
    final effective = selected.isNotEmpty
        ? selected
        : {if (model.categoryId != null) model.categoryId!};

    String label(String id) {
      final c = byId[id];
      if (c == null) return '?';
      final parent = c.parentId == null ? null : byId[c.parentId!];
      return parent == null ? c.name : '${parent.name} › ${c.name}';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(
                child: Text('Categorías',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextButton.icon(
                onPressed: () async {
                  final picked = await pickCategorySet(context, ref,
                      initial: effective.cast<String>());
                  if (picked != null) {
                    await ref
                        .read(catalogRepositoryProvider)
                        .setModelCategories(model.id, picked);
                  }
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Editar'),
              ),
            ]),
            if (effective.isEmpty)
              const Text('Sin categorías asignadas.',
                  style: TextStyle(fontSize: 12))
            else
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  for (final id in effective)
                    Chip(
                      label: Text(label(id),
                          style: const TextStyle(fontSize: 11)),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Atributos del producto: los mínimos que debe cumplir cualquier
/// modelo alternativo para pertenecer a este código. La plantilla de
/// nombres se hereda del canónico y crece al agregar nuevos.
class _AttributesCard extends ConsumerWidget {
  const _AttributesCard({required this.model});

  final ToolModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attrs = ref.watch(modelAttrsProvider(model.id));
    final template = model.canonicalCode == null
        ? const AsyncValue<List<CanonicalAttribute>>.data([])
        : ref.watch(canonicalAttrsProvider(model.canonicalCode!));

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(
                child: Text('Atributos del producto',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextButton.icon(
                onPressed: () => _editAttr(context, ref, null, null),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Atributo'),
              ),
            ]),
            const Text(
                'Mínimos que debe cumplir cualquier modelo alternativo '
                'para entrar en este código.',
                style: TextStyle(fontSize: 11)),
            const SizedBox(height: 6),
            attrs.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (list) {
                // Atributos de la plantilla del canónico aún sin valor.
                final pending = (template.value ?? [])
                    .where((t) =>
                        !list.any((a) => a.name == t.name))
                    .toList();
                if (list.isEmpty && pending.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Sin atributos definidos todavía. '
                        'Agrégalos con "+ Atributo" (ej. Potencia (W): '
                        '1400-1500).'),
                  );
                }
                return Column(children: [
                  for (final a in list)
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.rule, size: 18),
                      title: Text(a.name,
                          style: const TextStyle(fontSize: 13)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(a.value,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 16),
                            onPressed: () =>
                                _editAttr(context, ref, a.name, a.value),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 16),
                            onPressed: () => ref
                                .read(catalogRepositoryProvider)
                                .deleteModelAttr(a.id),
                          ),
                        ],
                      ),
                    ),
                  for (final t in pending)
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.help_outline,
                          size: 18, color: Colors.orange),
                      title: Text(t.name,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.orange)),
                      subtitle: const Text(
                          'Definido en la familia — falta el valor',
                          style: TextStyle(fontSize: 10)),
                      trailing: TextButton(
                        onPressed: () =>
                            _editAttr(context, ref, t.name, null),
                        child: const Text('Definir'),
                      ),
                    ),
                ]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editAttr(BuildContext context, WidgetRef ref,
      String? name, String? value) async {
    final nameC = TextEditingController(text: name);
    final valueC = TextEditingController(text: value);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(name ?? 'Nuevo atributo'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          if (name == null)
            TextField(
                controller: nameC,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: 'Atributo',
                    hintText: 'Ej. Potencia (W), Disco (mm), Uso')),
          TextField(
              controller: valueC,
              autofocus: name != null,
              decoration: const InputDecoration(
                  labelText: 'Valor mínimo / rango',
                  hintText: 'Ej. 1400-1500, ≥115, Industrial')),
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
    final attrName = (name ?? nameC.text).trim();
    final attrValue = valueC.text.trim();
    if (attrName.isEmpty || attrValue.isEmpty) return;
    await ref.read(catalogRepositoryProvider).saveModelAttr(
          toolModelId: model.id,
          name: attrName,
          value: attrValue,
          canonicalCode: model.canonicalCode,
        );
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
          if (v == 'datasheet') {
            final url = asset.datasheetUrl;
            if (url != null && url.isNotEmpty) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            }
          } else if (v == 'edit') {
            final model =
                await repo.getModel(asset.toolModelId);
            if (model != null && context.mounted) {
              await showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) =>
                    AssetSheet(model: model, existing: asset),
              );
            }
          } else if (v == 'move') {
            final locId = await pickLocation(context, ref);
            if (locId != null) await repo.moveAsset(asset.id, locId);
          } else {
            await repo.setAssetStatus(asset.id, v);
          }
        },
        itemBuilder: (_) => [
          if (asset.datasheetUrl?.isNotEmpty ?? false)
            const PopupMenuItem(
                value: 'datasheet',
                child: Text('📄 Abrir ficha técnica')),
          const PopupMenuItem(
              value: 'edit',
              child: Text('Editar (serie, marca, factura…)')),
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
  const AssetSheet({super.key, required this.model, this.existing});

  final ToolModel model;
  final Asset? existing;

  @override
  ConsumerState<AssetSheet> createState() => _AssetSheetState();
}

class _AssetSheetState extends ConsumerState<AssetSheet> {
  late final _serial =
      TextEditingController(text: widget.existing?.serial);
  late final _invoice =
      TextEditingController(text: widget.existing?.invoiceNumber);
  late final _datasheet =
      TextEditingController(text: widget.existing?.datasheetUrl);
  late final _brand =
      TextEditingController(text: widget.existing?.brand);
  late final _mfrModel =
      TextEditingController(text: widget.existing?.mfrModel);
  late final TextEditingController _cost = TextEditingController(
      text: (widget.existing?.purchaseCost ?? widget.model.listCost)
          .toStringAsFixed(2));
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
            Text(
                widget.existing == null
                    ? 'Nueva unidad — ${widget.model.name}'
                    : 'Editar ${widget.existing!.assetTag}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy ? null : _scanLabel,
              icon: const Icon(Icons.document_scanner_outlined),
              label: const Text(
                  'Fotografiar etiqueta (reconoce serie y modelo)'),
            ),
            const SizedBox(height: 8),
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
                  labelText: 'Número de serie',
                  helperText: 'Vacío = se genera solo: lote + fecha '
                      'de ingreso (ej. DEM-0007-20260908)'),
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
            TextField(
              controller: _datasheet,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                  labelText: 'Link a la ficha técnica (opcional)',
                  hintText: 'https://…'),
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
            if (widget.existing == null)
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
              icon: Icon(widget.existing == null
                  ? Icons.qr_code
                  : Icons.save),
              label: Text(widget.existing == null
                  ? 'Registrar y generar etiqueta'
                  : 'Guardar cambios'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// Foto a la etiqueta/caja → OCR en el dispositivo → prellena
  /// marca, modelo y serie (solo los campos que estén vacíos).
  Future<void> _scanLabel() async {
    final picked = await ImagePicker().pickImage(
        source: ImageSource.camera, maxWidth: 1920, imageQuality: 90);
    if (picked == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final recognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final result = await recognizer
          .processImage(InputImage.fromFilePath(picked.path));
      await recognizer.close();
      final guess = parseLabelText(result.text);
      if (!mounted) return;
      if (guess.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No se reconoció serie ni modelo en la '
                'foto. Intenta con más luz y la etiqueta plana.')));
        return;
      }
      setState(() {
        if (guess.brand != null && _brand.text.trim().isEmpty) {
          _brand.text = guess.brand!;
        }
        if (guess.model != null && _mfrModel.text.trim().isEmpty) {
          _mfrModel.text = guess.model!;
        }
        if (guess.serial != null && _serial.text.trim().isEmpty) {
          _serial.text = guess.serial!;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Reconocido: '
              '${[
            if (guess.brand != null) 'marca ${guess.brand}',
            if (guess.model != null) 'modelo ${guess.model}',
            if (guess.serial != null) 'serie ${guess.serial}',
          ].join(' · ')} — revisa y corrige si hace falta')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final repo = ref.read(catalogRepositoryProvider);
      if (widget.existing != null) {
        await repo.updateAsset(
          id: widget.existing!.id,
          serial:
              _serial.text.trim().isEmpty ? null : _serial.text.trim(),
          brand: _brand.text.trim().isEmpty ? null : _brand.text.trim(),
          mfrModel: _mfrModel.text.trim().isEmpty
              ? null
              : _mfrModel.text.trim(),
          purchaseCost:
              double.tryParse(_cost.text.replaceAll(',', '.')),
          invoiceNumber:
              _invoice.text.trim().isEmpty ? null : _invoice.text.trim(),
          supplierId: _supplierId ?? widget.existing!.supplierId,
          condition: widget.existing!.condition,
          notes: widget.existing!.notes,
          datasheetUrl: _datasheet.text.trim().isEmpty
              ? null
              : _datasheet.text.trim(),
        );
        if (mounted) Navigator.pop(context);
        return;
      }
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
        datasheetUrl: _datasheet.text.trim().isEmpty
            ? null
            : _datasheet.text.trim(),
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
