import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/rental_repository.dart';

/// Selector de cliente con alta rápida (nombre + cédula/RUC + teléfono).
Future<String?> pickCustomer(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _CustomerPicker(),
  );
}

class _CustomerPicker extends ConsumerStatefulWidget {
  const _CustomerPicker();

  @override
  ConsumerState<_CustomerPicker> createState() => _CustomerPickerState();
}

class _CustomerPickerState extends ConsumerState<_CustomerPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider(_query));
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (ctx, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscar cliente por nombre o cédula/RUC',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_add),
          title: const Text('Crear cliente nuevo'),
          onTap: () async {
            final id = await createCustomer(context, ref,
                initialName: _query);
            if (id != null && context.mounted) {
              Navigator.pop(context, id);
            }
          },
        ),
        const Divider(height: 1),
        Expanded(
          child: customers.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) => ListView(
              controller: scroll,
              children: [
                for (final c in list)
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(c.name),
                    subtitle: c.idNumber == null && c.phone == null
                        ? null
                        : Text(
                            [
                              if (c.idNumber != null) c.idNumber!,
                              if (c.phone != null) c.phone!,
                            ].join(' · '),
                            style: const TextStyle(fontSize: 11)),
                    onTap: () => Navigator.pop(context, c.id),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

/// Selector de obra/dirección de entrega del cliente, con alta rápida.
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
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('Proyecto / dirección de entrega',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.add_location_alt_outlined),
              title: const Text('Crear obra nueva'),
              onTap: () async {
                final id = await createSite(ctx2, ref, customerId);
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
                    child: Center(child: CircularProgressIndicator()))
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

/// Alta rápida de obra. Devuelve el id creado o null.
Future<String?> createSite(
    BuildContext context, WidgetRef ref, String customerId) async {
  final name = TextEditingController();
  final address = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nueva obra del cliente'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
            controller: name,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: 'Nombre de la obra *',
                hintText: 'Ej. Edificio Norte')),
        TextField(
            controller: address,
            decoration: const InputDecoration(labelText: 'Dirección')),
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
  return ref.read(rentalRepositoryProvider).saveSite(
        customerId: customerId,
        name: name.text.trim(),
        address:
            address.text.trim().isEmpty ? null : address.text.trim(),
      );
}

/// Selector del responsable de la herramienta en la obra.
Future<String?> pickContact(
    BuildContext context, WidgetRef ref, String siteId) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => Consumer(builder: (ctx, ref, _) {
      final contacts = ref.watch(siteContactsProvider(siteId));
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (ctx2, scroll) => ListView(
          controller: scroll,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('Responsable de la herramienta',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('Crear responsable nuevo'),
              onTap: () async {
                final id = await createContact(ctx2, ref, siteId);
                if (id != null && ctx2.mounted) {
                  Navigator.pop(ctx2, id);
                }
              },
            ),
            const Divider(height: 1),
            ...contacts.when(
              loading: () => [
                const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()))
              ],
              error: (e, _) => [Text('Error: $e')],
              data: (list) => [
                for (final c in list)
                  ListTile(
                    leading: const Icon(Icons.engineering_outlined),
                    title: Text(c.name),
                    subtitle: Text(
                        [
                          if (c.role != null) c.role!,
                          if (c.idNumber != null) 'CI ${c.idNumber}',
                          if (c.phone != null) c.phone!,
                        ].join(' · '),
                        style: const TextStyle(fontSize: 11)),
                    onTap: () => Navigator.pop(ctx2, c.id),
                  ),
              ],
            ),
          ],
        ),
      );
    }),
  );
}

/// Alta rápida de responsable. Devuelve el id creado o null.
Future<String?> createContact(
    BuildContext context, WidgetRef ref, String siteId) async {
  final name = TextEditingController();
  final idNumber = TextEditingController();
  final phone = TextEditingController();
  final role = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nuevo responsable en la obra'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration:
                  const InputDecoration(labelText: 'Nombre *')),
          TextField(
              controller: idNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cédula')),
          TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Teléfono')),
          TextField(
              controller: role,
              decoration: const InputDecoration(
                  labelText: 'Cargo',
                  hintText: 'Residente de obra, bodeguero…')),
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
  return ref.read(rentalRepositoryProvider).saveContact(
        siteId: siteId,
        name: name.text.trim(),
        idNumber:
            idNumber.text.trim().isEmpty ? null : idNumber.text.trim(),
        phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
        role: role.text.trim().isEmpty ? null : role.text.trim(),
      );
}

/// Alta rápida de cliente. Devuelve el id creado o null.
Future<String?> createCustomer(BuildContext context, WidgetRef ref,
    {String initialName = ''}) async {
  final name = TextEditingController(text: initialName);
  final idNumber = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nuevo cliente'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: name,
              autofocus: initialName.isEmpty,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  labelText: 'Nombre / razón social *')),
          TextField(
              controller: idNumber,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Cédula / RUC')),
          TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Teléfono')),
          TextField(
              controller: address,
              decoration: const InputDecoration(labelText: 'Dirección')),
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
  return ref.read(rentalRepositoryProvider).saveCustomer(
        name: name.text.trim(),
        idNumber:
            idNumber.text.trim().isEmpty ? null : idNumber.text.trim(),
        phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
        address:
            address.text.trim().isEmpty ? null : address.text.trim(),
      );
}
