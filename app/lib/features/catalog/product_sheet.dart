import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../data/seed/canonicals.dart';

/// Selector de canónico (busca entre ~1,700 subgrupos del ERP).
Future<Canonical?> pickCanonical(
    BuildContext context, WidgetRef ref) async {
  final all = await ref.read(canonicalsProvider.future);
  if (!context.mounted) return null;
  return showModalBottomSheet<Canonical>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _CanonicalPicker(all: all),
  );
}

class _CanonicalPicker extends StatefulWidget {
  const _CanonicalPicker({required this.all});

  final List<Canonical> all;

  @override
  State<_CanonicalPicker> createState() => _CanonicalPickerState();
}

class _CanonicalPickerState extends State<_CanonicalPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final matches = q.isEmpty
        ? widget.all.take(30).toList()
        : widget.all
            .where((c) =>
                c.code.toLowerCase().contains(q) ||
                c.name.toLowerCase().contains(q))
            .take(50)
            .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (ctx, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscar canónico por código o nombre',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scroll,
            itemCount: matches.length,
            itemBuilder: (_, i) => ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 20,
                child: Text(matches[i].code,
                    style: const TextStyle(fontSize: 9)),
              ),
              title: Text(matches[i].name,
                  style: const TextStyle(fontSize: 13)),
              onTap: () => Navigator.pop(context, matches[i]),
            ),
          ),
        ),
      ]),
    );
  }
}

/// Selector de proveedor con alta rápida (nombre + RUC).
Future<String?> pickSupplier(BuildContext context, WidgetRef ref) async {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _SupplierPicker(),
  );
}

class _SupplierPicker extends ConsumerStatefulWidget {
  const _SupplierPicker();

  @override
  ConsumerState<_SupplierPicker> createState() =>
      _SupplierPickerState();
}

class _SupplierPickerState extends ConsumerState<_SupplierPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(suppliersProvider(_query));
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (ctx, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar proveedor por nombre o RUC',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add_business),
          title: const Text('Crear proveedor nuevo'),
          onTap: () async {
            final id = await _createSupplier(context, ref);
            if (id != null && context.mounted) {
              Navigator.pop(context, id);
            }
          },
        ),
        const Divider(height: 1),
        Expanded(
          child: suppliers.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) => ListView(
              controller: scroll,
              children: [
                for (final s in list)
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: Text(s.name),
                    subtitle: s.ruc == null
                        ? null
                        : Text('RUC ${s.ruc}',
                            style: const TextStyle(fontSize: 11)),
                    onTap: () => Navigator.pop(context, s.id),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

Future<String?> _createSupplier(
    BuildContext context, WidgetRef ref) async {
  final name = TextEditingController();
  final ruc = TextEditingController();
  final phone = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nuevo proveedor'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
            controller: name,
            autofocus: true,
            decoration:
                const InputDecoration(labelText: 'Nombre / razón social *')),
        TextField(
            controller: ruc,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'RUC')),
        TextField(
            controller: phone,
            decoration: const InputDecoration(labelText: 'Teléfono')),
      ]),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Crear')),
      ],
    ),
  );
  if (ok != true || name.text.trim().isEmpty) return null;
  return ref.read(supplierRepositoryProvider).save(
        name: name.text.trim(),
        ruc: ruc.text.trim().isEmpty ? null : ruc.text.trim(),
        phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
      );
}

/// Alta/edición de producto (modelo) con canónico + código automático.
class ProductSheet extends ConsumerStatefulWidget {
  const ProductSheet({super.key, this.existing});

  final ToolModel? existing;

  @override
  ConsumerState<ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends ConsumerState<ProductSheet> {
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _variant =
      TextEditingController(text: widget.existing?.variant);
  late final _brand = TextEditingController(text: widget.existing?.brand);
  late final _supplierCode =
      TextEditingController(text: widget.existing?.supplierCode);
  late final _cost = TextEditingController(
      text: widget.existing == null
          ? ''
          : widget.existing!.listCost.toStringAsFixed(2));
  late String _line = widget.existing?.line ?? 'ind';
  Canonical? _canonical;
  String? _ratCode;
  String? _supplierId;
  String? _supplierName;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e?.canonicalCode != null) {
      _canonical =
          Canonical(code: e!.canonicalCode!, name: e.canonicalName ?? '');
      _ratCode = e.ratCode;
    }
    if (e?.supplierId != null) {
      Future.microtask(() async {
        final s = await ref
            .read(supplierRepositoryProvider)
            .getById(e!.supplierId!);
        if (mounted) setState(() => _supplierName = s?.name);
      });
      _supplierId = e?.supplierId;
    }
  }

  Future<void> _chooseCanonical() async {
    final c = await pickCanonical(context, ref);
    if (c == null || !mounted) return;
    final code = widget.existing?.ratCode != null &&
            widget.existing?.canonicalCode == c.code
        ? widget.existing!.ratCode
        : await ref.read(catalogRepositoryProvider).nextRatCode(c.code);
    if (!mounted) return;
    setState(() {
      _canonical = c;
      _ratCode = code;
      if (_name.text.trim().isEmpty) _name.text = c.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                widget.existing == null
                    ? 'Nuevo producto'
                    : 'Editar producto',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            // ── Canónico + código automático ──
            Card(
              child: ListTile(
                leading: const Icon(Icons.category_outlined),
                title: Text(_canonical == null
                    ? 'Elegir canónico *'
                    : '${_canonical!.code} — ${_canonical!.name}'),
                subtitle: Text(
                    _ratCode == null
                        ? 'El código Rent a Tool se genera solo '
                            '(canónico + secuencial)'
                        : 'Código Rent a Tool: $_ratCode',
                    style: const TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.search),
                onTap: _chooseCanonical,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
                controller: _name,
                decoration: const InputDecoration(
                    labelText: 'Nombre del producto (por especificación) *',
                    hintText:
                        'Ej. Esmeriladora angular 4 1/2" Industrial 1400-1500W')),
            const SizedBox(height: 8),
            TextField(
                controller: _variant,
                decoration: const InputDecoration(
                    labelText: 'Variación (opcional)',
                    hintText: 'Ej. kit 2 baterías, 220V, 7-1/4"')),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                    controller: _brand,
                    decoration: const InputDecoration(
                        labelText: 'Marca de referencia (opcional)')),
              ),
              const SizedBox(width: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'ind', label: Text('IND')),
                  ButtonSegment(value: 'diy', label: Text('DIY')),
                ],
                selected: {_line},
                onSelectionChanged: (s) =>
                    setState(() => _line = s.first),
              ),
            ]),
            const SizedBox(height: 8),
            TextField(
                controller: _supplierCode,
                decoration: const InputDecoration(
                    labelText: 'Modelo de referencia para compra (opcional)',
                    hintText: 'Ej. D28114 — la marca/modelo real va en cada unidad')),
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
            TextField(
                controller: _cost,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                    labelText: 'Costo (\$) — precarga las tarifas',
                    helperText:
                        '4h 14% · día 20% · semana 70% · mes 200%')),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.save),
              label: const Text('Guardar producto'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _canonical == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Elige el canónico y escribe el nombre')));
      return;
    }
    setState(() => _busy = true);
    try {
      final cost =
          double.tryParse(_cost.text.replaceAll(',', '.')) ?? 0;
      final e = widget.existing;
      await ref.read(catalogRepositoryProvider).saveModel(
            id: e?.id,
            name: _name.text.trim(),
            spec: e?.spec,
            line: _line,
            brand:
                _brand.text.trim().isEmpty ? null : _brand.text.trim(),
            supplierCode: _supplierCode.text.trim().isEmpty
                ? null
                : _supplierCode.text.trim(),
            description: e?.description,
            categoryId: e?.categoryId,
            listCost: cost,
            rateHalfDay: cost > 0
                ? _r2(cost * RentalRates.halfDayPct)
                : e?.rateHalfDay,
            rateDay:
                cost > 0 ? _r2(cost * RentalRates.dayPct) : e?.rateDay,
            rateWeek:
                cost > 0 ? _r2(cost * RentalRates.weekPct) : e?.rateWeek,
            rateMonth: cost > 0
                ? _r2(cost * RentalRates.monthPct)
                : e?.rateMonth,
            b87Qty: e?.b87Qty ?? 0,
            published: e?.published ?? false,
            notes: e?.notes,
            ratCode: _ratCode,
            canonicalCode: _canonical!.code,
            canonicalName: _canonical!.name,
            variant: _variant.text.trim().isEmpty
                ? null
                : _variant.text.trim(),
            supplierId: _supplierId,
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static double _r2(double v) => (v * 100).roundToDouble() / 100;
}
