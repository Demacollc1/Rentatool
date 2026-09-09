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
                      _LineTile(
                          view: v,
                          contractStatus: c.status,
                          contractId: contractId),
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
                    ListTile(
                      title: const Text('Total',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(money.format(total),
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
              ? 'Sin fecha pactada de devolución'
              : 'Devolución pactada: ${DateFormat('dd/MM/yyyy').format(contract.dueAt!)}'),
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

/// Línea: unidad + tarifa (kind/períodos editables) + devolver.
class _LineTile extends ConsumerWidget {
  const _LineTile(
      {required this.view,
      required this.contractStatus,
      required this.contractId});

  final LineView view;
  final String contractStatus;
  final String contractId;

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
    final draft = contractStatus == 'draft';
    final returned = l.returnedAt != null;
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
                          ' · condición ${l.conditionIn ?? '-'}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.green)),
                  ]),
            ),
            if (draft)
              IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: 'Quitar',
                  onPressed: () => repo.removeLine(l.id)),
            if (contractStatus == 'active' && !returned)
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
              onChanged: draft
                  ? (v) =>
                      v == null ? null : repo.updateLine(l.id, rateKind: v)
                  : null,
            ),
            const SizedBox(width: 12),
            IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20),
                onPressed: draft && l.periods > 1
                    ? () =>
                        repo.updateLine(l.id, periods: l.periods - 1)
                    : null),
            Text(l.periods.toStringAsFixed(0)),
            IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: draft
                    ? () =>
                        repo.updateLine(l.id, periods: l.periods + 1)
                    : null),
            const Spacer(),
            GestureDetector(
              onTap: draft ? () => _editRate(context, ref) : null,
              child: Text(
                  '${money.format(l.rate)} × '
                  '${l.periods.toStringAsFixed(0)} = '
                  '${money.format(l.amount)}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ]),
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
