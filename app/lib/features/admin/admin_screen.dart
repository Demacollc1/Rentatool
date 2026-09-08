import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/local/database.dart';
import '../../data/repositories/canonical_repository.dart';
import '../../data/repositories/catalog_repository.dart';
import 'categories_admin_screen.dart';

/// Hub de administración.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administración')),
      body: ListView(children: [
        ListTile(
          leading: const Icon(Icons.qr_code_2),
          title: const Text('Códigos canónicos'),
          subtitle: const Text('Familias del ERP, íconos y plantillas '
              'de atributos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const CanonicalsAdminScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.category_outlined),
          title: const Text('Categorías'),
          subtitle: const Text('Oficios y grupos del catálogo '
              '(Albañilería, Electricidad…)'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const CategoriesAdminScreen())),
        ),
      ]),
    );
  }
}

/// Administración de códigos canónicos y sus plantillas de atributos.
class CanonicalsAdminScreen extends ConsumerStatefulWidget {
  const CanonicalsAdminScreen({super.key});

  @override
  ConsumerState<CanonicalsAdminScreen> createState() =>
      _CanonicalsAdminScreenState();
}

class _CanonicalsAdminScreenState
    extends ConsumerState<CanonicalsAdminScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final canonicals = ref.watch(canonicalsDbProvider(_query));

    return Scaffold(
      appBar: AppBar(title: const Text('Canónicos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editCanonical(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Canónico'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar por código o nombre',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: canonicals.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) => ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: list.length > 100 ? 100 : list.length,
              itemBuilder: (_, i) {
                final c = list[i];
                return ListTile(
                  dense: true,
                  leading: canonicalAvatar(c),
                  title: Text(c.name,
                      style: const TextStyle(fontSize: 13)),
                  subtitle: const Text(
                      'Toca para administrar sus atributos',
                      style: TextStyle(fontSize: 10)),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'edit') {
                        await _editCanonical(context, c);
                      } else if (v == 'icon') {
                        await _pickIcon(c);
                      } else if (v == 'delete') {
                        final err = await ref
                            .read(canonicalRepositoryProvider)
                            .delete(c.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(err ??
                                      '${c.code} eliminado ✔')));
                        }
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                          value: 'edit', child: Text('Editar nombre')),
                      PopupMenuItem(
                          value: 'icon',
                          child: Text('Subir / cambiar ícono')),
                      PopupMenuItem(
                          value: 'delete',
                          child: Text('Eliminar (si no está en uso)')),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) =>
                              CanonicalTemplateScreen(canonical: c))),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _pickIcon(Canonical c) async {
    final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 512, imageQuality: 85);
    if (picked == null) return;
    await ref
        .read(canonicalRepositoryProvider)
        .setIcon(c.id, picked.path);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ícono de ${c.code} guardado ✔ '
              '(se sube al servidor en el próximo sync)')));
    }
  }

  Future<void> _editCanonical(
      BuildContext context, Canonical? existing) async {
    final code = TextEditingController(text: existing?.code);
    final name = TextEditingController(text: existing?.name);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            existing == null ? 'Nuevo canónico' : 'Editar canónico'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: code,
              enabled: existing == null,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                  labelText: 'Código *', hintText: 'Ej. ESM, AAQ')),
          TextField(
              controller: name,
              decoration: const InputDecoration(
                  labelText: 'Nombre completo *',
                  hintText: 'Descripción 1 + Descripción 2')),
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
        name.text.trim().isEmpty) {
      return;
    }
    await ref.read(canonicalRepositoryProvider).save(
          id: existing?.id,
          code: code.text,
          name: name.text,
        );
  }
}

/// Avatar del canónico: su ícono si existe, o el código como texto.
Widget canonicalAvatar(Canonical c, {double radius = 20}) {
  final path = c.iconLocalPath;
  if (path != null && File(path).existsSync()) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: FileImage(File(path)),
    );
  }
  return CircleAvatar(
    radius: radius,
    child: Text(c.code, style: const TextStyle(fontSize: 9)),
  );
}

/// Plantilla de atributos de una familia: qué se exige definir en
/// todo producto de este canónico.
class CanonicalTemplateScreen extends ConsumerWidget {
  const CanonicalTemplateScreen({super.key, required this.canonical});

  final Canonical canonical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attrs = ref.watch(canonicalAttrsProvider(canonical.code));

    return Scaffold(
      appBar: AppBar(title: Text('${canonical.code} · Atributos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final c = TextEditingController();
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Nuevo atributo de la familia'),
              content: TextField(
                  controller: c,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Atributo',
                      hintText: 'Ej. Potencia (W), Disco (mm)')),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar')),
                FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Agregar')),
              ],
            ),
          );
          if (ok == true && c.text.trim().isNotEmpty) {
            await ref
                .read(catalogRepositoryProvider)
                .saveCanonicalAttr(canonical.code, c.text.trim());
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Atributo'),
      ),
      body: attrs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                    '${canonical.name}\n\nEstos atributos aparecerán '
                    'como pendientes de valor en cada producto de la '
                    'familia. El valor mínimo se define producto por '
                    'producto.',
                    style: const TextStyle(fontSize: 12)),
              ),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Sin atributos definidos para esta familia.',
                    textAlign: TextAlign.center),
              ),
            for (final a in list)
              ListTile(
                leading: const Icon(Icons.rule),
                title: Text(a.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => ref
                      .read(catalogRepositoryProvider)
                      .deleteCanonicalAttr(a.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
