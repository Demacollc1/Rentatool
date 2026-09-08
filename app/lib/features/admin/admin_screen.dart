import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/repositories/canonical_repository.dart';
import '../../data/repositories/catalog_repository.dart';

/// Administración: códigos canónicos y sus plantillas de atributos.
class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final canonicals = ref.watch(canonicalsDbProvider(_query));

    return Scaffold(
      appBar: AppBar(title: const Text('Administración · Canónicos')),
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
                  leading: CircleAvatar(
                    radius: 20,
                    child: Text(c.code,
                        style: const TextStyle(fontSize: 9)),
                  ),
                  title: Text(c.name,
                      style: const TextStyle(fontSize: 13)),
                  subtitle: const Text(
                      'Toca para administrar sus atributos',
                      style: TextStyle(fontSize: 10)),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => _editCanonical(context, c),
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
