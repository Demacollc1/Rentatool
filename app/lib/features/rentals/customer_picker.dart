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
