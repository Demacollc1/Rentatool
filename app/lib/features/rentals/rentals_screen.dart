import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/rental_repository.dart';
import 'customer_picker.dart';

/// Lista de contratos de renta por estado + alta de contrato.
class RentalsScreen extends ConsumerStatefulWidget {
  const RentalsScreen({super.key});

  @override
  ConsumerState<RentalsScreen> createState() => _RentalsScreenState();
}

class _RentalsScreenState extends ConsumerState<RentalsScreen> {
  String? _status = 'active';

  static const _tabs = [
    ('active', 'Activas'),
    ('draft', 'Borradores'),
    ('closed', 'Cerradas'),
    (null, 'Todas'),
  ];

  @override
  Widget build(BuildContext context) {
    final contracts = ref.watch(contractsProvider(_status));
    final money = NumberFormat.currency(symbol: r'$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rentas'),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Configuración',
              onPressed: () => context.go('/settings')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newContract(context),
        icon: const Icon(Icons.add),
        label: const Text('Renta'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: SegmentedButton<String?>(
            segments: [
              for (final (v, label) in _tabs)
                ButtonSegment(value: v, label: Text(label)),
            ],
            selected: {_status},
            onSelectionChanged: (s) =>
                setState(() => _status = s.first),
            showSelectedIcon: false,
          ),
        ),
        Expanded(
          child: contracts.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) => list.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Sin contratos aquí.\n'
                          'Crea una renta con el botón +.'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final v = list[i];
                      final c = v.contract;
                      final overdue = c.status == 'active' &&
                          c.dueAt != null &&
                          c.dueAt!.isBefore(DateTime.now());
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _statusColor(c.status)
                              .withValues(alpha: 0.15),
                          child: Icon(_statusIcon(c.status),
                              color: _statusColor(c.status), size: 20),
                        ),
                        title: Text(
                            '${c.contractNumber} · '
                            '${v.customer?.name ?? 'Sin cliente'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        subtitle: Text(
                          '${statusLabel(c.status)} · ${v.lines} '
                          'unidad${v.lines == 1 ? '' : 'es'} · '
                          '${money.format(v.total)}'
                          '${c.dueAt == null ? '' : ' · vence ${DateFormat('dd/MM').format(c.dueAt!)}'}',
                          style: TextStyle(
                              fontSize: 12,
                              color: overdue ? Colors.red : null,
                              fontWeight:
                                  overdue ? FontWeight.bold : null),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.go('/rentals/contract/${c.id}'),
                      );
                    },
                  ),
          ),
        ),
      ]),
    );
  }

  /// Cadena obligatoria: cliente → proyecto/dirección de entrega →
  /// responsable de la herramienta → contrato.
  Future<void> _newContract(BuildContext context) async {
    final customerId = await pickCustomer(context, ref);
    if (customerId == null || !context.mounted) return;
    final siteId = await pickSite(context, ref, customerId);
    if (siteId == null || !context.mounted) return;
    final contactId = await pickContact(context, ref, siteId);
    if (contactId == null || !context.mounted) return;
    final id = await ref.read(rentalRepositoryProvider).createContract(
        customerId: customerId, siteId: siteId, contactId: contactId);
    if (context.mounted) context.go('/rentals/contract/$id');
  }
}

String statusLabel(String s) => switch (s) {
      'draft' => 'Borrador',
      'active' => 'Activa',
      'closed' => 'Cerrada',
      'cancelled' => 'Cancelada',
      _ => s,
    };

Color _statusColor(String s) => switch (s) {
      'draft' => Colors.orange,
      'active' => Colors.green,
      'closed' => Colors.blueGrey,
      _ => Colors.grey,
    };

IconData _statusIcon(String s) => switch (s) {
      'draft' => Icons.edit_note,
      'active' => Icons.handyman,
      'closed' => Icons.check_circle_outline,
      _ => Icons.block,
    };
