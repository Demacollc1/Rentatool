import 'package:drift/drift.dart' hide Column, Table;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/sync/sync_service.dart';
import '../../data/repositories/rental_repository.dart';
import 'closure_pdf.dart';
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
              if (c.status == 'closed')
                IconButton(
                  icon: const Icon(Icons.task_outlined),
                  tooltip: 'Comprobante de cierre',
                  onPressed: () => _shareClosure(context, ref),
                ),
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
              _AddendumHistory(contractId: contractId),
              if (c.status == 'draft' || c.status == 'active')
                _AcceptanceCard(contract: c),
              lines.when(
                loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator())),
                error: (e, _) => Text('Error: $e'),
                data: (list) {
                  final consumibles = ref
                          .watch(contractConsumablesProvider(contractId))
                          .value ??
                      const [];
                  final totalCons = consumibles.fold<double>(
                      0, (s, x) => s + x.$1.amount);
                  final total = list.fold<double>(
                          0, (s, l) => s + l.line.amount) +
                      totalCons;
                  return Column(children: [
                    for (final v in list)
                      _LineTile(view: v, contract: c),
                    if (consumibles.isNotEmpty)
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: Column(children: [
                          const ListTile(
                              dense: true,
                              title: Text(
                                  'Consumibles y accesorios',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700))),
                          for (final (cc, cons) in consumibles)
                            ListTile(
                              dense: true,
                              leading: Icon(
                                  cc.kind == 'incluido'
                                      ? Icons.link
                                      : Icons.add_circle_outline,
                                  size: 18),
                              title: Text(cons.name,
                                  style: const TextStyle(
                                      fontSize: 13)),
                              subtitle: Text(
                                  cc.kind == 'incluido'
                                      ? 'Incluido con el equipo'
                                      : 'Opcional',
                                  style: const TextStyle(
                                      fontSize: 11)),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(cc.amount == 0
                                        ? 'Sin costo'
                                        : money.format(cc.amount)),
                                    if (draft &&
                                        cc.kind == 'opcional')
                                      IconButton(
                                          icon: const Icon(
                                              Icons.close,
                                              size: 16),
                                          onPressed: () => ref
                                              .read(
                                                  rentalRepositoryProvider)
                                              .removeContractConsumable(
                                                  cc.id)),
                                  ]),
                            ),
                        ]),
                      ),
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
                          if (active &&
                              list.any((v) =>
                                  v.line.returnedAt == null)) ...[
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: () => _returnGate(
                                    context, ref,
                                    line: null),
                                icon: const Icon(
                                    Icons.assignment_return),
                                label:
                                    const Text('Devolver todo'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _extendDates(context, ref, c),
                                icon: const Icon(
                                    Icons.edit_calendar),
                                label: const Text(
                                    'Extender / modificar'),
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
                        title: Text(c.depositReleasedAt == null
                            ? 'Garantía recibida'
                            : 'Garantía liberada '
                                '${DateFormat('dd/MM').format(c.depositReleasedAt!)}'
                                '${c.depositRetained > 0 ? ' · retenida ${money.format(c.depositRetained)}' : ''}'),
                        subtitle: c.depositNotes == null
                            ? null
                            : Text(c.depositNotes!,
                                style:
                                    const TextStyle(fontSize: 11)),
                        trailing: Text(money.format(c.deposit)),
                      ),
                    if (c.status == 'closed' &&
                        c.deposit > 0 &&
                        c.depositReleasedAt == null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: FilledButton.tonalIcon(
                          onPressed: () =>
                              _releaseDeposit(context, ref, c),
                          icon: const Icon(Icons.savings),
                          label: const Text(
                              'Liberar garantía y cerrar'),
                        ),
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
    final repo = ref.read(rentalRepositoryProvider);
    // Foto obligatoria de la entrega (si aún no hay).
    final fotos =
        await ref.read(contractPhotosProvider(contractId).future);
    if (!fotos.any((p) => p.kind == 'delivery')) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Toma la foto de la entrega para continuar')));
      final picked = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 1600,
          imageQuality: 80);
      if (picked == null) return; // sin foto no hay entrega
      await repo.addLinePhoto(
          contractId: contractId,
          kind: 'delivery',
          pickedPath: picked.path);
    }
    final err = await repo.deliver(contractId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err ??
            'Entregado ✔ — unidades en renta, kardex registrado')));
  }

  /// Compuerta de devolución: escanear el QR del equipo o aprobar con
  /// botón (→ los equipos van a CUARENTENA para revisión).
  /// line == null → devolver todo.
  Future<void> _returnGate(BuildContext context, WidgetRef ref,
      {LineView? line}) async {
    final opcion = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(line == null
            ? 'Devolver todos los equipos'
            : 'Devolver ${line.asset?.assetTag ?? ''}'),
        content: const Text(
            'Escanea el QR del equipo para confirmar su recepción, o '
            'aprueba sin escanear: en ese caso los equipos pasan a '
            'CUARENTENA para revisión y mantenimiento.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          OutlinedButton.icon(
              onPressed: () => Navigator.pop(ctx, 'scan'),
              icon: const Icon(Icons.qr_code_scanner, size: 18),
              label: const Text('Escanear QR')),
          FilledButton.icon(
              onPressed: () => Navigator.pop(ctx, 'aprobar'),
              icon: const Icon(Icons.gpp_maybe, size: 18),
              label: const Text('Aprobar → cuarentena')),
        ],
      ),
    );
    if (opcion == null || !context.mounted) return;
    final repo = ref.read(rentalRepositoryProvider);

    if (opcion == 'scan') {
      final scannedId = await Navigator.of(context).push<String>(
          MaterialPageRoute(builder: (_) => const _AssetScanPage()));
      if (scannedId == null || !context.mounted) return;
      if (line != null) {
        if (scannedId != line.line.assetId) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Ese QR no corresponde a esta unidad')));
          return;
        }
        await _conditionAndReturn(context, ref, line.line.id,
            tag: line.asset?.assetTag);
      } else {
        // Devolver todo escaneando: confirma la unidad escaneada y
        // repite hasta terminar (una por escaneo).
        final lines = await ref
            .read(contractLinesProvider(contractId).future);
        final match = lines
            .where((v) =>
                v.line.assetId == scannedId &&
                v.line.returnedAt == null)
            .toList();
        if (match.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    'Ese QR no es de una unidad pendiente de este '
                    'contrato')));
          }
          return;
        }
        if (context.mounted) {
          await _conditionAndReturn(context, ref, match.first.line.id,
              tag: match.first.asset?.assetTag);
        }
      }
      return;
    }

    // Aprobación sin escaneo → cuarentena para todos (o la línea).
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Aprobar devolución → cuarentena'),
        content: TextField(
            controller: notes,
            decoration: const InputDecoration(
                labelText: 'Notas de recepción')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Aprobar')),
        ],
      ),
    );
    if (ok != true) return;
    if (line != null) {
      await repo.returnLine(line.line.id,
          toQuarantine: true,
          notes:
              notes.text.trim().isEmpty ? null : notes.text.trim());
    } else {
      await repo.returnAll(contractId,
          toQuarantine: true,
          notes:
              notes.text.trim().isEmpty ? null : notes.text.trim());
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Equipos en cuarentena para revisión ✔ (kardex '
              'registrado)')));
    }
  }

  /// Diálogo de condición y devolución normal (tras escanear el QR).
  Future<void> _conditionAndReturn(
      BuildContext context, WidgetRef ref, String lineId,
      {String? tag}) async {
    var condition = 'good';
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Recibir ${tag ?? ''}'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'good', label: Text('Bien')),
                ButtonSegment(value: 'fair', label: Text('Regular')),
                ButtonSegment(value: 'poor', label: Text('Dañada')),
              ],
              selected: {condition},
              onSelectionChanged: (s) =>
                  setState(() => condition = s.first),
              showSelectedIcon: false,
            ),
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
    if (ok != true) return;
    await ref.read(rentalRepositoryProvider).returnLine(lineId,
        conditionIn: condition,
        notes: notes.text.trim().isEmpty ? null : notes.text.trim());
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unidad recibida ✔ (kardex registrado)')));
    }
  }

  /// Extensión/modificación de fechas: queda como addendum.
  Future<void> _extendDates(BuildContext context, WidgetRef ref,
      RentalContract c) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026),
      lastDate: DateTime(2035),
      initialDateRange: c.dueAt == null
          ? null
          : DateTimeRange(
              start: c.startAt ?? c.pickupAt ?? DateTime.now(),
              end: c.dueAt!),
      helpText: 'Nuevas fechas (queda como addendum)',
      saveText: 'Continuar',
    );
    if (range == null || !context.mounted) return;
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Addendum al contrato'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Devolución: '
              '${c.dueAt == null ? '—' : DateFormat('dd/MM/yyyy').format(c.dueAt!)}'
              ' → ${DateFormat('dd/MM/yyyy').format(range.end)}\n'
              'La tarifa se recalcula y el cambio queda en el '
              'historial del contrato.'),
          TextField(
              controller: notes,
              decoration:
                  const InputDecoration(labelText: 'Motivo / notas')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Registrar addendum')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(rentalRepositoryProvider).extendContract(c.id,
        newPickupAt: range.start,
        newDueAt: range.end,
        notes: notes.text.trim().isEmpty ? null : notes.text.trim());
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Addendum registrado ✔')));
    }
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
    await _addAsset(context, ref, assetId);
  }

  Future<void> _addFromList(BuildContext context, WidgetRef ref) async {
    final assetId = await _pickAvailableAsset(context, ref);
    if (assetId == null || !context.mounted) return;
    await _addAsset(context, ref, assetId);
  }

  /// Agrega la unidad; los incluidos entran solos y los opcionales
  /// del producto se ofrecen para elegir.
  Future<void> _addAsset(
      BuildContext context, WidgetRef ref, String assetId) async {
    final repo = ref.read(rentalRepositoryProvider);
    final err = await repo.addLine(contractId, assetId);
    if (err != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err)));
      }
      return;
    }
    final opcionales = await repo.optionalConsumablesFor(assetId);
    if (opcionales.isEmpty || !context.mounted) return;
    final elegidos = await showModalBottomSheet<Set<String>>(
      context: context,
      builder: (_) => _OptionalConsumablesSheet(options: opcionales),
    );
    if (elegidos == null || elegidos.isEmpty) return;
    final lineId = await repo.findLineId(contractId, assetId);
    for (final (link, cons) in opcionales) {
      if (elegidos.contains(cons.id)) {
        await repo.addContractConsumable(
          contractId: contractId,
          lineId: lineId,
          consumableId: cons.id,
          kind: 'opcional',
          price: link.extraPrice > 0 ? link.extraPrice : cons.salePrice,
        );
      }
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

  Future<void> _shareClosure(BuildContext context, WidgetRef ref) async {
    final path = await buildClosurePdf(ref, contractId);
    if (path == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No se pudo generar el comprobante')));
      }
      return;
    }
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }

  Future<void> _releaseDeposit(
      BuildContext context, WidgetRef ref, RentalContract c) async {
    final retained = TextEditingController();
    final notes = TextEditingController();
    final money = NumberFormat.currency(symbol: r'$');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Liberar garantía'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Garantía recibida: ${money.format(c.deposit)}'),
          TextField(
              controller: retained,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Monto retenido (0 si se devuelve todo)')),
          TextField(
              controller: notes,
              decoration: const InputDecoration(
                  labelText: 'Motivo de la retención')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Liberar')),
        ],
      ),
    );
    if (ok != true) return;
    final err = await ref.read(rentalRepositoryProvider).releaseDeposit(
        contractId,
        retained: double.tryParse(
                retained.text.replaceAll(',', '.').trim()) ??
            0,
        notes: notes.text.trim().isEmpty ? null : notes.text.trim());
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err ??
              'Garantía liberada ✔ — genera el comprobante de cierre')));
    }
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
    final site = contract.siteId == null
        ? null
        : ref.watch(siteProvider(contract.siteId!)).value;
    final contact = contract.contactId == null
        ? null
        : ref.watch(siteContactProvider(contract.contactId!)).value;
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
          leading: const Icon(Icons.place_outlined, size: 20),
          title: Text(site == null
              ? 'Elige el proyecto / dirección de entrega'
              : site.name),
          subtitle: site?.address == null
              ? null
              : Text(site!.address!,
                  style: const TextStyle(fontSize: 11)),
          trailing:
              editable ? const Icon(Icons.chevron_right) : null,
          onTap: editable
              ? () async {
                  final id = await pickSite(
                      context, ref, contract.customerId);
                  if (id != null) {
                    // Obra nueva → el responsable anterior ya no aplica.
                    await ref
                        .read(rentalRepositoryProvider)
                        .updateContract(contract.id, siteId: id);
                    if (context.mounted) {
                      final cid = await pickContact(context, ref, id);
                      if (cid != null) {
                        await ref
                            .read(rentalRepositoryProvider)
                            .updateContract(contract.id,
                                contactId: cid);
                      }
                    }
                  }
                }
              : null,
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.engineering_outlined, size: 20),
          title: Text(contact == null
              ? 'Elige el responsable de la herramienta'
              : contact.name),
          subtitle: contact == null
              ? null
              : Text(
                  [
                    if (contact.role != null) contact.role!,
                    if (contact.idNumber != null)
                      'CI ${contact.idNumber}',
                    if (contact.phone != null) contact.phone!,
                  ].join(' · '),
                  style: const TextStyle(fontSize: 11)),
          trailing:
              editable ? const Icon(Icons.chevron_right) : null,
          onTap: editable && contract.siteId != null
              ? () async {
                  final id = await pickContact(
                      context, ref, contract.siteId!);
                  if (id != null) {
                    await ref
                        .read(rentalRepositoryProvider)
                        .updateContract(contract.id, contactId: id);
                  }
                }
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
          title: Text(() {
            final df = DateFormat('dd/MM/yyyy');
            final retiro = contract.startAt ?? contract.pickupAt;
            if (contract.dueAt == null) {
              return 'Sin fechas — elige la tarifa manualmente por línea';
            }
            return 'Retiro ${retiro == null ? '?' : df.format(retiro)} → '
                'Devolución ${df.format(contract.dueAt!)}';
          }()),
          subtitle: contract.dueAt == null
              ? const Text('Si defines retiro y devolución, la tarifa '
                  'y los períodos se calculan solos',
                  style: TextStyle(fontSize: 11))
              : null,
          trailing: editable || contract.status == 'active'
              ? IconButton(
                  icon: const Icon(Icons.edit_calendar, size: 18),
                  tooltip: 'Fechas de retiro y devolución',
                  onPressed: () async {
                    final now = DateTime.now();
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2035),
                      initialDateRange: contract.dueAt == null
                          ? null
                          : DateTimeRange(
                              start: contract.startAt ??
                                  contract.pickupAt ??
                                  now,
                              end: contract.dueAt!),
                      helpText: 'Retiro → devolución pactada',
                      saveText: 'Guardar',
                    );
                    if (range != null) {
                      await ref
                          .read(rentalRepositoryProvider)
                          .updateContract(contract.id,
                              pickupAt: range.start, dueAt: range.end);
                    }
                  })
              : null,
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.savings_outlined, size: 20),
          title: Text('Garantía: '
              '${NumberFormat.currency(symbol: r'$').format(contract.deposit)}'
              '${!contract.depositRequired ? ' (exonerada)' : contract.depositManual ? ' (manual)' : ' (automática)'}'),
          subtitle: contract.depositRequired && !contract.depositManual
              ? const Text(
                  '100% nuevo · 50% frecuente · 30% con contrato',
                  style: TextStyle(fontSize: 10))
              : null,
          trailing: editable
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  Switch(
                    value: contract.depositRequired,
                    onChanged: (v) => ref
                        .read(rentalRepositoryProvider)
                        .updateContract(contract.id,
                            depositRequired: v),
                  ),
                  IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _editDeposit(context, ref)),
                ])
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

/// Aceptación documental del cliente: QR en mostrador o link por
/// WhatsApp/email; muestra el checklist cuando el cliente firma.
class _AcceptanceCard extends ConsumerWidget {
  const _AcceptanceCard({required this.contract});

  final RentalContract contract;

  static const _portalBase = 'https://demaco-portal.demacollc.workers.dev';

  String? get _url => contract.acceptanceToken == null
      ? null
      : '$_portalBase/?t=${contract.acceptanceToken}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acc = ref.watch(acceptanceProvider(contract.id)).value;
    final firmado = acc?.acceptedAt != null;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(firmado ? Icons.verified : Icons.pending_actions,
                    size: 20,
                    color: firmado ? Colors.green : Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      firmado
                          ? 'Aceptado y firmado por el cliente'
                          : 'Aceptación del cliente pendiente',
                      style:
                          const TextStyle(fontWeight: FontWeight.w600)),
                ),
                IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    tooltip: 'Actualizar estado',
                    onPressed: () async {
                      await ref
                          .read(syncServiceProvider)
                          .syncAll();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Estado actualizado')));
                      }
                    }),
              ]),
              if (firmado) ...[
                _check('Contrato firmado por ${acc!.signerName ?? ''}'),
                _check('Términos y condiciones aceptados'),
                _check('Recepción de herramienta confirmada'),
                _check(acc.idPhotoPath != null
                    ? 'Cédula registrada con foto '
                        '(${acc.signerIdNumber ?? ''})'
                    : 'Cédula: ${acc.signerIdNumber ?? ''}'),
              ] else if (_url != null)
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showQr(context, ref),
                      icon: const Icon(Icons.qr_code_2),
                      label: const Text('QR mostrador'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        // El link solo vive cuando el contrato está
                        // en el servidor: sincroniza antes de enviar.
                        await ref
                            .read(syncServiceProvider)
                            .syncAll();
                        await SharePlus.instance.share(ShareParams(
                            text: 'Alivio Constructor — contrato '
                                '${contract.contractNumber}. Revisa, '
                                'acepta y firma aquí: $_url'));
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar link'),
                    ),
                  ),
                ])
              else
                const Text('Sincroniza una vez para generar el link',
                    style: TextStyle(fontSize: 12)),
            ]),
      ),
    );
  }

  Widget _check(String texto) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 6),
          Expanded(child: Text(texto, style: const TextStyle(fontSize: 13))),
        ]),
      );

  void _showQr(BuildContext context, WidgetRef ref) {
    // Sincroniza en paralelo: cuando el cliente termine de escanear y
    // abrir, el contrato ya debe estar en el servidor.
    final syncing = ref.read(syncServiceProvider).syncAll();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Escanea con tu teléfono\n'
            '(${contract.contractNumber})'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 260,
            height: 260,
            child: QrImageView(
              data: _url!,
              backgroundColor: Colors.white,
            ),
          ),
          FutureBuilder(
            future: syncing,
            builder: (_, snap) => snap.connectionState !=
                    ConnectionState.done
                ? const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2)),
                          SizedBox(width: 8),
                          Text('Activando el link…',
                              style: TextStyle(fontSize: 12)),
                        ]),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                        snap.data?.ok ?? false
                            ? 'Link activo ✔'
                            : 'Sin conexión: el cliente debe escanear '
                                'cuando vuelva la señal',
                        style: TextStyle(
                            fontSize: 12,
                            color: (snap.data?.ok ?? false)
                                ? Colors.green
                                : Colors.orange)),
                  ),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cerrar')),
        ],
      ),
    );
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
            _PhotoButton(
                contractId: contract.id,
                line: l,
                enabled: draft || contract.status == 'active'),
            if (draft)
              IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: 'Quitar',
                  onPressed: () => repo.removeLine(l.id)),
            if (contract.status == 'active' && !returned)
              FilledButton.tonalIcon(
                onPressed: () => ContractDetailScreen(
                        contractId: contract.id)
                    ._returnGate(context, ref, line: view),
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

}

/// Botón de evidencias: toma foto del estado al entregar/recibir y
/// muestra cuántas hay.
class _PhotoButton extends ConsumerWidget {
  const _PhotoButton(
      {required this.contractId,
      required this.line,
      required this.enabled});

  final String contractId;
  final RentalLine line;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(linePhotosProvider(line.id)).value ?? [];
    return Stack(alignment: Alignment.topRight, children: [
      PopupMenuButton<String>(
        enabled: enabled,
        icon: Icon(Icons.photo_camera_outlined,
            size: 20,
            color: photos.isEmpty ? null : Colors.green),
        tooltip: 'Fotos de evidencia',
        onSelected: (kind) => _takePhoto(context, ref, kind),
        itemBuilder: (_) => const [
          PopupMenuItem(
              value: 'delivery',
              child: Text('Foto al ENTREGAR')),
          PopupMenuItem(
              value: 'return', child: Text('Foto al RECIBIR')),
        ],
      ),
      if (photos.isNotEmpty)
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
              color: Colors.green, shape: BoxShape.circle),
          child: Text('${photos.length}',
              style: const TextStyle(
                  fontSize: 9, color: Colors.white)),
        ),
    ]);
  }

  Future<void> _takePhoto(
      BuildContext context, WidgetRef ref, String kind) async {
    final picked = await ImagePicker().pickImage(
        source: ImageSource.camera, maxWidth: 1600, imageQuality: 80);
    if (picked == null) return;
    await ref.read(rentalRepositoryProvider).addLinePhoto(
        contractId: contractId,
        lineId: line.id,
        kind: kind,
        pickedPath: picked.path);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(kind == 'delivery'
              ? 'Evidencia de entrega guardada ✔ (sube en el sync)'
              : 'Evidencia de recepción guardada ✔ (sube en el sync)')));
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

/// Lista de unidades disponibles con buscador (código o nombre).
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
    builder: (_) =>
        _AvailableAssetSheet(assets: assets, models: models),
  );
}

class _AvailableAssetSheet extends StatefulWidget {
  const _AvailableAssetSheet(
      {required this.assets, required this.models});

  final List<Asset> assets;
  final Map<String, ToolModel?> models;

  @override
  State<_AvailableAssetSheet> createState() =>
      _AvailableAssetSheetState();
}

class _AvailableAssetSheetState extends State<_AvailableAssetSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toUpperCase();
    final list = q.isEmpty
        ? widget.assets
        : widget.assets.where((a) {
            final m = widget.models[a.toolModelId];
            final texto = [
              a.assetTag,
              a.brand ?? '',
              a.mfrModel ?? '',
              a.serial ?? '',
              m?.ratCode ?? '',
              m?.name ?? '',
            ].join(' ').toUpperCase();
            return texto.contains(q);
          }).toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (ctx, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscar por código, nombre, marca o serie',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView(
            controller: scroll,
            children: [
              for (final a in list)
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.qr_code_2),
                  title: Text(
                      '${widget.models[a.toolModelId]?.ratCode ?? ''} · '
                      '${a.assetTag} · '
                      '${[a.brand, a.mfrModel].whereType<String>().join(' ')}'),
                  subtitle: Text(
                      widget.models[a.toolModelId]?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.pop(context, a.id),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}


/// Historial de addendums (extensiones/modificaciones de fechas).
class _AddendumHistory extends ConsumerWidget {
  const _AddendumHistory({required this.contractId});

  final String contractId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addendums =
        ref.watch(addendumsProvider(contractId)).value ?? const [];
    if (addendums.isEmpty) return const SizedBox.shrink();
    final df = DateFormat('dd/MM/yyyy');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(children: [
        const ListTile(
            dense: true,
            leading: Icon(Icons.history, size: 20),
            title: Text('Historial del contrato',
                style: TextStyle(fontWeight: FontWeight.w700))),
        for (final a in addendums)
          ListTile(
            dense: true,
            leading: Icon(
                a.kind == 'extension'
                    ? Icons.update
                    : Icons.edit_calendar,
                size: 18),
            title: Text(
                '${a.kind == 'extension' ? 'Extensión' : 'Modificación'}: '
                'devolución '
                '${a.oldDueAt == null ? '—' : df.format(a.oldDueAt!)} → '
                '${a.newDueAt == null ? '—' : df.format(a.newDueAt!)}',
                style: const TextStyle(fontSize: 13)),
            subtitle: Text(
                '${DateFormat('dd/MM/yyyy HH:mm').format(a.updatedAt)}'
                '${a.notes == null ? '' : ' · ${a.notes}'}',
                style: const TextStyle(fontSize: 11)),
          ),
      ]),
    );
  }
}

/// Selección de consumibles opcionales al agregar una unidad.
class _OptionalConsumablesSheet extends StatefulWidget {
  const _OptionalConsumablesSheet({required this.options});

  final List<(ToolModelConsumable, Consumable)> options;

  @override
  State<_OptionalConsumablesSheet> createState() =>
      _OptionalConsumablesSheetState();
}

class _OptionalConsumablesSheetState
    extends State<_OptionalConsumablesSheet> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(symbol: r'\$');
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Text('Accesorios y consumibles opcionales',
              style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        for (final (link, cons) in widget.options)
          CheckboxListTile(
            dense: true,
            value: _selected.contains(cons.id),
            title: Text(cons.name,
                style: const TextStyle(fontSize: 13)),
            subtitle: Text(
                (link.extraPrice > 0
                        ? money.format(link.extraPrice)
                        : cons.salePrice > 0
                            ? money.format(cons.salePrice)
                            : 'Sin costo adicional'),
                style: const TextStyle(fontSize: 11)),
            onChanged: (v) => setState(() => v == true
                ? _selected.add(cons.id)
                : _selected.remove(cons.id)),
          ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () =>
                    Navigator.pop(context, <String>{}),
                child: const Text('Ninguno'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.pop(context, _selected),
                child: Text('Agregar (${_selected.length})'),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
