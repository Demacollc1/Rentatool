import 'package:drift/drift.dart' hide Column, Table;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/sync/sync_service.dart';
import '../../data/repositories/rental_repository.dart';
import 'contract_pdf.dart';
import 'customer_picker.dart';
import 'rentals_screen.dart' show statusLabel;

/// Detalle del contrato: cliente, unidades, tarifas, entregar/devolver.
class ContractDetailScreen extends ConsumerWidget {
  const ContractDetailScreen({super.key, required this.contractId});

  final String contractId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(contractProvider(contractId));
    final lines = ref.watch(contractLinesProvider(contractId));
    final money = NumberFormat.currency(symbol: r'$');

    return contract.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (c) {
        if (c == null) {
          return const Scaffold(
              body: Center(child: Text('Contrato no encontrado')));
        }
        final draft = c.status == 'draft';
        final active = c.status == 'active';
        return Scaffold(
          appBar: AppBar(
            title: Text(c.contractNumber),
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined),
                tooltip: 'Contrato PDF',
                onPressed: () => _sharePdf(context, ref),
              ),
              if (draft)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Cancelar borrador',
                  onPressed: () => _cancel(context, ref),
                ),
            ],
          ),
          floatingActionButton: draft
              ? FloatingActionButton.extended(
                  onPressed: () => _deliver(context, ref),
                  icon: const Icon(Icons.local_shipping),
                  label: const Text('Entregar'),
                )
              : null,
          body: ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              _HeaderCard(contract: c, editable: draft),
              lines.when(
                loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator())),
                error: (e, _) => Text('Error: $e'),
                data: (list) {
                  final total = list.fold<double>(
                      0, (s, l) => s + l.line.amount);
                  return Column(children: [
                    for (final v in list)
                      _LineTile(view: v, contract: c),
                    if (draft || active)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(children: [
                          if (draft) ...[
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _addByScan(context, ref),
                                icon: const Icon(Icons.qr_code_scanner),
                                label: const Text('Escanear unidad'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _addFromList(context, ref),
                                icon: const Icon(Icons.list),
                                label: const Text('Elegir de lista'),
                              ),
                            ),
                          ],
                        ]),
                      ),
                    if (c.deliveryFee > 0)
                      ListTile(
                        dense: true,
                        title: const Text('Transporte'),
                        trailing: Text(money.format(c.deliveryFee)),
                      ),
                    ListTile(
                      title: const Text('Total',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(money.format(total + c.deliveryFee),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                    if (c.deposit > 0)
                      ListTile(
                        dense: true,
                        title: const Text('Garantía recibida'),
                        trailing: Text(money.format(c.deposit)),
                      ),
                  ]);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deliver(BuildContext context, WidgetRef ref) async {
    final err =
        await ref.read(rentalRepositoryProvider).deliver(contractId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err ??
            'Entregado ✔ — unidades en renta, kardex registrado')));
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final err =
        await ref.read(rentalRepositoryProvider).cancel(contractId);
    if (!context.mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err)));
    } else {
      context.go('/rentals');
    }
  }

  Future<void> _addByScan(BuildContext context, WidgetRef ref) async {
    final assetId = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const _AssetScanPage()));
    if (assetId == null || !context.mounted) return;
    final err = await ref
        .read(rentalRepositoryProvider)
        .addLine(contractId, assetId);
    if (context.mounted && err != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _addFromList(BuildContext context, WidgetRef ref) async {
    final assetId = await _pickAvailableAsset(context, ref);
    if (assetId == null || !context.mounted) return;
    final err = await ref
        .read(rentalRepositoryProvider)
        .addLine(contractId, assetId);
    if (context.mounted && err != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _sharePdf(BuildContext context, WidgetRef ref) async {
    final path = await buildContractPdf(ref, contractId);
    if (path == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No se pudo generar el PDF')));
      }
      return;
    }
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }
}

/// Cabecera: cliente, fechas y garantía (editables en borrador).
class _HeaderCard extends ConsumerWidget {
  const _HeaderCard({required this.contract, required this.editable});

  final RentalContract contract;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer =
        ref.watch(customerProvider(contract.customerId)).value;
    final df = DateFormat('dd/MM/yyyy HH:mm');
    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(customer?.name ?? '…'),
          subtitle: customer == null
              ? null
              : Text(
                  [
                    if (customer.idNumber != null)
                      'CI/RUC ${customer.idNumber}',
                    if (customer.phone != null) customer.phone!,
                  ].join(' · '),
                  style: const TextStyle(fontSize: 12)),
          trailing: editable
              ? IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () async {
                    final id = await pickCustomer(context, ref);
                    if (id != null) {
                      await ref
                          .read(rentalRepositoryProvider)
                          .updateContract(contract.id, customerId: id);
                    }
                  })
              : null,
        ),
        const Divider(height: 1),
        ListTile(
          dense: true,
          leading: const Icon(Icons.flag_outlined, size: 20),
          title: Text('Estado: ${statusLabel(contract.status)}'
              '${contract.startAt == null ? '' : ' · entregado ${df.format(contract.startAt!)}'}'
              '${contract.returnedAt == null ? '' : ' · devuelto ${df.format(contract.returnedAt!)}'}'),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.event, size: 20),
          title: Text(contract.dueAt == null
              ? 'Sin fechas — elige la tarifa manualmente por línea'
              : 'Devolución pactada: ${DateFormat('dd/MM/yyyy').format(contract.dueAt!)}'),
          subtitle: contract.dueAt == null
              ? const Text('Si defines la fecha, la tarifa y los '
                  'períodos se calculan solos',
                  style: TextStyle(fontSize: 11))
              : null,
          trailing: editable || contract.status == 'active'
              ? IconButton(
                  icon: const Icon(Icons.edit_calendar, size: 18),
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: contract.dueAt ?? DateTime.now(),
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2035),
                    );
                    if (d != null) {
                      await ref
                          .read(rentalRepositoryProvider)
                          .updateContract(contract.id, dueAt: d);
                    }
                  })
              : null,
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.savings_outlined, size: 20),
          title: Text('Garantía: '
              '${NumberFormat.currency(symbol: r'$').format(contract.deposit)}'),
          trailing: editable
              ? IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _editDeposit(context, ref))
              : null,
        ),
        _DeliveryTile(contract: contract, editable: editable),
      ]),
    );
  }

  Future<void> _editDeposit(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(
        text: contract.deposit == 0
            ? ''
            : contract.deposit.toStringAsFixed(2));
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Garantía (USD)'),
        content: TextField(
            controller: ctrl,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true)),
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
    if (ok == true) {
      await ref.read(rentalRepositoryProvider).updateContract(contract.id,
          deposit: double.tryParse(ctrl.text.replaceAll(',', '.')) ?? 0);
    }
  }
}

/// Entrega: retiro en local o envío por transporte a una obra.
class _DeliveryTile extends ConsumerWidget {
  const _DeliveryTile({required this.contract, required this.editable});

  final RentalContract contract;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(rentalRepositoryProvider);
    final delivery = contract.deliveryMethod == 'delivery';
    final site = contract.siteId == null
        ? null
        : ref.watch(siteProvider(contract.siteId!)).value;
    final money = NumberFormat.currency(symbol: r'$');
    return Column(children: [
      ListTile(
        dense: true,
        leading: Icon(
            delivery ? Icons.local_shipping_outlined : Icons.storefront,
            size: 20),
        title: Row(children: [
          Expanded(
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'pickup', label: Text('Retiro en local')),
                ButtonSegment(
                    value: 'delivery', label: Text('Envío a obra')),
              ],
              selected: {contract.deliveryMethod},
              onSelectionChanged: editable
                  ? (s) => repo.updateContract(contract.id,
                      deliveryMethod: s.first)
                  : null,
              showSelectedIcon: false,
            ),
          ),
        ]),
      ),
      if (delivery)
        ListTile(
          dense: true,
          leading: const Icon(Icons.place_outlined, size: 20),
          title: Text(site == null
              ? 'Elige la obra / dirección de entrega'
              : site.name),
          subtitle: site?.address == null
              ? null
              : Text(site!.address!,
                  style: const TextStyle(fontSize: 11)),
          trailing: editable
              ? const Icon(Icons.chevron_right)
              : null,
          onTap: editable
              ? () async {
                  final id = await pickSite(
                      context, ref, contract.customerId);
                  if (id != null) {
                    await repo.updateContract(contract.id, siteId: id);
                  }
                }
              : null,
        ),
      if (delivery)
        ListTile(
          dense: true,
          leading: const Icon(Icons.attach_money, size: 20),
          title: Text(
              'Transporte: ${money.format(contract.deliveryFee)}'),
          trailing: editable
              ? IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _editFee(context, ref))
              : null,
        ),
    ]);
  }

  Future<void> _editFee(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(
        text: contract.deliveryFee == 0
            ? ''
            : contract.deliveryFee.toStringAsFixed(2));
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Costo de transporte (USD)'),
        content: TextField(
            controller: ctrl,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true)),
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
    if (ok == true) {
      await ref.read(rentalRepositoryProvider).updateContract(contract.id,
          deliveryFee:
              double.tryParse(ctrl.text.replaceAll(',', '.')) ?? 0);
    }
  }
}

/// Selector de obra del cliente con alta rápida.
Future<String?> pickSite(
    BuildContext context, WidgetRef ref, String customerId) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => Consumer(builder: (ctx, ref, _) {
      final sites = ref.watch(customerSitesProvider(customerId));
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (ctx2, scroll) => ListView(
          controller: scroll,
          children: [
            ListTile(
              leading: const Icon(Icons.add_location_alt_outlined),
              title: const Text('Crear obra nueva'),
              onTap: () async {
                final id =
                    await _createSite(ctx2, ref, customerId);
                if (id != null && ctx2.mounted) {
                  Navigator.pop(ctx2, id);
                }
              },
            ),
            const Divider(height: 1),
            ...sites.when(
              loading: () => [
                const Padding(
                    padding: EdgeInsets.all(24),
                    child:
                        Center(child: CircularProgressIndicator()))
              ],
              error: (e, _) => [Text('Error: $e')],
              data: (list) => [
                for (final s in list)
                  ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(s.name),
                    subtitle: s.address == null
                        ? null
                        : Text(s.address!,
                            style: const TextStyle(fontSize: 11)),
                    onTap: () => Navigator.pop(ctx2, s.id),
                  ),
              ],
            ),
          ],
        ),
      );
    }),
  );
}

Future<String?> _createSite(
    BuildContext context, WidgetRef ref, String customerId) async {
  final name = TextEditingController();
  final address = TextEditingController();
  final contact = TextEditingController();
  final phone = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nueva obra del cliente'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: name,
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: 'Nombre de la obra *',
                  hintText: 'Ej. Edificio Norte')),
          TextField(
              controller: address,
              decoration:
                  const InputDecoration(labelText: 'Dirección')),
          TextField(
              controller: contact,
              decoration: const InputDecoration(
                  labelText: 'Contacto en obra')),
          TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Teléfono')),
        ]),
      ),
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
  return ref.read(rentalRepositoryProvider).saveSite(
        customerId: customerId,
        name: name.text.trim(),
        address:
            address.text.trim().isEmpty ? null : address.text.trim(),
        contactName:
            contact.text.trim().isEmpty ? null : contact.text.trim(),
        contactPhone:
            phone.text.trim().isEmpty ? null : phone.text.trim(),
      );
}

/// Línea: unidad + tarifa (kind/períodos editables) + devolver.
class _LineTile extends ConsumerWidget {
  const _LineTile({required this.view, required this.contract});

  final LineView view;
  final RentalContract contract;

  static const _kinds = [
    ('half_day', '4h'),
    ('day', 'Día'),
    ('week', 'Semana'),
    ('month', 'Mes'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = view.line;
    final money = NumberFormat.currency(symbol: r'$');
    final draft = contract.status == 'draft';
    final returned = l.returnedAt != null;
    // Con fechas definidas la tarifa se calcula sola y no se toca.
    final byDates = contract.dueAt != null;
    final manual = draft && !byDates;
    final repo = ref.read(rentalRepositoryProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${view.asset?.assetTag ?? '?'} · '
                        '${[view.asset?.brand, view.asset?.mfrModel].whereType<String>().join(' ')}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    Text(view.model?.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)),
                    if (returned)
                      Text(
                          'Devuelta '
                          '${DateFormat('dd/MM HH:mm').format(l.returnedAt!)}'
                          ' · condición ${switch (l.conditionIn) {
                            'good' => 'bien',
                            'fair' => 'regular',
                            'poor' => 'dañada',
                            _ => l.conditionIn ?? '-',
                          }}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.green)),
                  ]),
            ),
            if (draft)
              IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: 'Quitar',
                  onPressed: () => repo.removeLine(l.id)),
            if (contract.status == 'active' && !returned)
              FilledButton.tonalIcon(
                onPressed: () => _returnDialog(context, ref),
                icon: const Icon(Icons.assignment_return, size: 18),
                label: const Text('Devolver'),
              ),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            DropdownButton<String>(
              value: l.rateKind,
              isDense: true,
              items: [
                for (final (v, label) in _kinds)
                  DropdownMenuItem(value: v, child: Text(label)),
              ],
              onChanged: manual
                  ? (v) =>
                      v == null ? null : repo.updateLine(l.id, rateKind: v)
                  : null,
            ),
            const SizedBox(width: 12),
            IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20),
                onPressed: manual && l.periods > 1
                    ? () =>
                        repo.updateLine(l.id, periods: l.periods - 1)
                    : null),
            Text(l.periods.toStringAsFixed(0)),
            IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: manual
                    ? () =>
                        repo.updateLine(l.id, periods: l.periods + 1)
                    : null),
            const Spacer(),
            GestureDetector(
              onTap: manual ? () => _editRate(context, ref) : null,
              child: Text(
                  '${money.format(l.rate)} × '
                  '${l.periods.toStringAsFixed(0)} = '
                  '${money.format(l.amount)}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ]),
          if (byDates && !returned)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                  'Tarifa calculada por las fechas retiro → devolución',
                  style:
                      TextStyle(fontSize: 10, color: Colors.blueGrey)),
            ),
        ]),
      ),
    );
  }

  Future<void> _editRate(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(
        text: view.line.rate.toStringAsFixed(2));
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tarifa (USD)'),
        content: TextField(
            controller: ctrl,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true)),
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
    if (ok == true) {
      final v = double.tryParse(ctrl.text.replaceAll(',', '.'));
      if (v != null) {
        await ref
            .read(rentalRepositoryProvider)
            .updateLine(view.line.id, rate: v);
      }
    }
  }

  Future<void> _returnDialog(BuildContext context, WidgetRef ref) async {
    var condition = 'good';
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Devolver ${view.asset?.assetTag ?? ''}'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'good', label: Text('Bien')),
                ButtonSegment(value: 'fair', label: Text('Regular')),
                ButtonSegment(
                    value: 'poor', label: Text('Dañada')),
              ],
              selected: {condition},
              onSelectionChanged: (s) =>
                  setState(() => condition = s.first),
              showSelectedIcon: false,
            ),
            const SizedBox(height: 8),
            if (condition == 'poor')
              const Text('Irá a mantenimiento, no a disponible.',
                  style: TextStyle(fontSize: 12, color: Colors.red)),
            TextField(
                controller: notes,
                decoration: const InputDecoration(
                    labelText: 'Notas de recepción')),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Recibir')),
          ],
        ),
      ),
    );
    if (ok == true) {
      await ref.read(rentalRepositoryProvider).returnLine(view.line.id,
          conditionIn: condition,
          notes: notes.text.trim().isEmpty ? null : notes.text.trim());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Unidad recibida ✔ (kardex registrado)')));
      }
    }
  }
}

/// Escanea el QR de una unidad (demaco:asset:) y devuelve su id.
class _AssetScanPage extends StatefulWidget {
  const _AssetScanPage();

  @override
  State<_AssetScanPage> createState() => _AssetScanPageState();
}

class _AssetScanPageState extends State<_AssetScanPage> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanea la etiqueta de la unidad')),
      body: MobileScanner(onDetect: (capture) {
        if (_handled) return;
        final raw = capture.barcodes.firstOrNull?.rawValue ?? '';
        if (raw.startsWith('demaco:asset:')) {
          _handled = true;
          Navigator.pop(context,
              raw.substring('demaco:asset:'.length).split('|').first);
        } else if (raw.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Ese QR no es de una unidad')));
        }
      }),
    );
  }
}

/// Lista de unidades disponibles para agregar al contrato.
Future<String?> _pickAvailableAsset(
    BuildContext context, WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  final assets = await (db.select(db.assets)
        ..where((a) => a.deletedAt.isNull() & a.status.equals('available'))
        ..orderBy([(a) => OrderingTerm.asc(a.assetTag)]))
      .get();
  final models = <String, ToolModel?>{};
  for (final a in assets) {
    models[a.toolModelId] ??=
        await ref.read(catalogRepositoryProvider).getModel(a.toolModelId);
  }
  if (!context.mounted) return null;
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (ctx, scroll) => ListView(
        controller: scroll,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Unidades disponibles',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          for (final a in assets)
            ListTile(
              dense: true,
              leading: const Icon(Icons.qr_code_2),
              title: Text('${a.assetTag} · '
                  '${[a.brand, a.mfrModel].whereType<String>().join(' ')}'),
              subtitle: Text(models[a.toolModelId]?.name ?? '',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => Navigator.pop(ctx, a.id),
            ),
        ],
      ),
    ),
  );
}
