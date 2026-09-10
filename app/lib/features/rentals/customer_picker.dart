import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/repositories/rental_repository.dart';
import '../../data/sync/sync_service.dart';

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
                    title: Text(c.tradeName ?? c.name),
                    subtitle: Text(
                        [
                          if (c.tradeName != null) c.name,
                          if (c.kind != null)
                            customerKindLabel(c.kind),
                          if (c.idNumber != null) 'RUC ${c.idNumber}',
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
                    subtitle: Text(
                        [
                          if (s.address != null) s.address!,
                          if (s.postalCode != null)
                            'CP ${s.postalCode}',
                          s.paymentMethod == 'credito'
                              ? 'Crédito'
                              : 'Prepago',
                        ].join(' · '),
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

/// Nombre completo del código postal: Descripción 1 + Descripción 2
/// del ERP concatenadas (la 2 completa a la 1).
String postalFullName(PostalCode c) =>
    c.parish == null ? c.city : '${c.city} ${c.parish}';

/// Selector de código postal interno DEMACO (código → ciudad y
/// parroquia), con alta rápida a la lista.
Future<PostalCode?> pickPostalCode(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<PostalCode>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (ctx2, scroll) => _PostalList(scroll: scroll),
    ),
  );
}

class _PostalList extends ConsumerStatefulWidget {
  const _PostalList({required this.scroll});

  final ScrollController scroll;

  @override
  ConsumerState<_PostalList> createState() => _PostalListState();
}

class _PostalListState extends ConsumerState<_PostalList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final codes = ref.watch(postalCodesProvider(_query));
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Buscar código, ciudad o parroquia',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.add_location_alt_outlined),
        title: const Text('Agregar código postal a la lista'),
        onTap: () async {
          final pc = await _createPostalCode(context, ref);
          if (pc != null && context.mounted) {
            Navigator.pop(context, pc);
          }
        },
      ),
      const Divider(height: 1),
      Expanded(
        child: codes.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (list) => ListView(
            controller: widget.scroll,
            children: [
              for (final c in list)
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.tag),
                  title: Text(c.code),
                  subtitle: Text(postalFullName(c),
                      style: const TextStyle(fontSize: 11)),
                  onTap: () => Navigator.pop(context, c),
                ),
            ],
          ),
        ),
      ),
    ]);
  }
}

Future<PostalCode?> _createPostalCode(
    BuildContext context, WidgetRef ref) async {
  final code = TextEditingController();
  final city = TextEditingController();
  final parish = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nuevo código postal interno'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
            controller: code,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(labelText: 'Código *')),
        TextField(
            controller: city,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Ciudad *')),
        TextField(
            controller: parish,
            textCapitalization: TextCapitalization.words,
            decoration:
                const InputDecoration(labelText: 'Parroquia')),
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
  if (ok != true ||
      code.text.trim().isEmpty ||
      city.text.trim().isEmpty) {
    return null;
  }
  final repo = ref.read(rentalRepositoryProvider);
  final id = await repo.savePostalCode(
      code: code.text.trim().toUpperCase(),
      city: city.text.trim(),
      parish: parish.text.trim().isEmpty ? null : parish.text.trim());
  final list = await repo.watchPostalCodes().first;
  return list.firstWhere((c) => c.id == id);
}

/// Alta de obra: dirección, código postal interno, GPS, contacto
/// (copiable de facturación), orden de compra y forma de pago.
Future<String?> createSite(
    BuildContext context, WidgetRef ref, String customerId) async {
  final db = ref.read(appDatabaseProvider);
  final customer = await (db.select(db.customers)
        ..where((c) => c.id.equals(customerId)))
      .getSingleOrNull();
  if (!context.mounted) return null;

  final name = TextEditingController();
  final address = TextEditingController();
  final gps = TextEditingController();
  final contactName = TextEditingController();
  final contactPhone = TextEditingController();
  final contactEmail = TextEditingController();
  final purchaseOrder = TextEditingController();
  PostalCode? postal;
  var sameAsBilling = false;
  var paymentMethod = 'prepago';

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Nuevo proyecto / dirección de entrega'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: name,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: 'Nombre del proyecto *',
                    hintText: 'Ej. Edificio Norte')),
            TextField(
                controller: address,
                decoration:
                    const InputDecoration(labelText: 'Dirección *')),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(Icons.tag, size: 20),
              title: Text(postal == null
                  ? 'Código postal interno *'
                  : '${postal!.code} · ${postalFullName(postal!)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final pc = await pickPostalCode(ctx, ref);
                if (pc != null) setState(() => postal = pc);
              },
            ),
            TextField(
                controller: gps,
                decoration: const InputDecoration(
                    labelText: 'GPS (lat, lng)',
                    hintText: '-2.170998, -79.922359')),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Contacto en obra',
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(ctx).colorScheme.primary)),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: sameAsBilling,
              title: const Text('Misma información de facturación',
                  style: TextStyle(fontSize: 13)),
              onChanged: (v) => setState(() {
                sameAsBilling = v ?? false;
                if (sameAsBilling && customer != null) {
                  contactName.text =
                      customer.tradeName ?? customer.name;
                  contactPhone.text = customer.phone ?? '';
                  contactEmail.text = customer.email ?? '';
                }
              }),
            ),
            TextField(
                controller: contactName,
                enabled: !sameAsBilling,
                decoration:
                    const InputDecoration(labelText: 'Nombre')),
            TextField(
                controller: contactPhone,
                enabled: !sameAsBilling,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: 'Teléfono')),
            TextField(
                controller: contactEmail,
                enabled: !sameAsBilling,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(
                controller: purchaseOrder,
                decoration: const InputDecoration(
                    labelText: 'Nº orden de compra / documento')),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'prepago', label: Text('Prepago')),
                ButtonSegment(
                    value: 'credito', label: Text('Crédito')),
              ],
              selected: {paymentMethod},
              onSelectionChanged: (s) =>
                  setState(() => paymentMethod = s.first),
              showSelectedIcon: false,
            ),
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
    ),
  );
  if (ok != true || name.text.trim().isEmpty) return null;

  double? lat;
  double? lng;
  final gpsParts = gps.text.split(',');
  if (gpsParts.length == 2) {
    lat = double.tryParse(gpsParts[0].trim());
    lng = double.tryParse(gpsParts[1].trim());
  }
  return ref.read(rentalRepositoryProvider).saveSite(
        customerId: customerId,
        name: name.text.trim(),
        address:
            address.text.trim().isEmpty ? null : address.text.trim(),
        postalCode: postal?.code,
        gpsLat: lat,
        gpsLng: lng,
        contactName: contactName.text.trim().isEmpty
            ? null
            : contactName.text.trim(),
        contactPhone: contactPhone.text.trim().isEmpty
            ? null
            : contactPhone.text.trim(),
        contactEmail: contactEmail.text.trim().isEmpty
            ? null
            : contactEmail.text.trim(),
        purchaseOrder: purchaseOrder.text.trim().isEmpty
            ? null
            : purchaseOrder.text.trim(),
        paymentMethod: paymentMethod,
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

/// Clasificación de clientes DEMACO.
const customerKinds = [
  ('maestro', 'Maestro'),
  ('constructora', 'Constructora'),
  ('diyer', 'DIYer'),
  ('mantenimiento', 'Empresa de mantenimiento'),
  ('obra_eventual', 'Obra eventual'),
];

String customerKindLabel(String? kind) => customerKinds
    .firstWhere((k) => k.$1 == kind, orElse: () => ('', ''))
    .$2;

/// Alta de cliente: RUC, nombre legal y comercial, contacto y tipo.
Future<String?> createCustomer(BuildContext context, WidgetRef ref,
    {String initialName = ''}) async {
  final ruc = TextEditingController();
  final name = TextEditingController(text: initialName);
  final tradeName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  String? kind;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Nuevo cliente'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: ruc,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'RUC / cédula *')),
            TextField(
                controller: name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Nombre legal / razón social *')),
            TextField(
                controller: tradeName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Nombre comercial')),
            TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: 'Teléfono')),
            TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: address,
                decoration: const InputDecoration(
                    labelText: 'Dirección (facturación)')),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: kind,
              decoration:
                  const InputDecoration(labelText: 'Tipo de cliente *'),
              items: [
                for (final (v, label) in customerKinds)
                  DropdownMenuItem(value: v, child: Text(label)),
              ],
              onChanged: (v) => setState(() => kind = v),
            ),
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
    ),
  );
  if (ok != true || name.text.trim().isEmpty) return null;
  return ref.read(rentalRepositoryProvider).saveCustomer(
        name: name.text.trim(),
        tradeName: tradeName.text.trim().isEmpty
            ? null
            : tradeName.text.trim(),
        kind: kind,
        idNumber: ruc.text.trim().isEmpty ? null : ruc.text.trim(),
        phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
        email: email.text.trim().isEmpty ? null : email.text.trim(),
        address:
            address.text.trim().isEmpty ? null : address.text.trim(),
      );
}
