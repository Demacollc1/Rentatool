import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config.dart';
import '../../data/sync/sync_service.dart';
import '../admin/admin_screen.dart';
import '../labels/qr_labels_pdf.dart';
import '../auth/auth_providers.dart';

/// Configuración del tamaño de etiqueta (para la impresora de rollo).
class _LabelSizeTile extends ConsumerStatefulWidget {
  @override
  ConsumerState<_LabelSizeTile> createState() => _LabelSizeTileState();
}

class _LabelSizeTileState extends ConsumerState<_LabelSizeTile> {
  double _w = defaultLabelWidthMm;
  double _h = defaultLabelHeightMm;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final (w, h) =
          await loadLabelSize(ref.read(syncServiceProvider));
      if (mounted) setState(() { _w = w; _h = h; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.sell_outlined),
      title: const Text('Tamaño de etiqueta'),
      subtitle: Text('${_w.toStringAsFixed(0)} × '
          '${_h.toStringAsFixed(0)} mm — una etiqueta por página '
          '(impresoras de rollo tipo DYMO)'),
      onTap: () async {
        final result = await showDialog<(double, double)>(
          context: context,
          builder: (ctx) {
            final wC = TextEditingController(
                text: _w.toStringAsFixed(0));
            final hC = TextEditingController(
                text: _h.toStringAsFixed(0));
            return AlertDialog(
              title: const Text('Tamaño de etiqueta'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                for (final (label, w, h) in const [
                  ('100 × 50 mm (rollo grande)', 100.0, 50.0),
                  ('50 × 40 mm', 50.0, 40.0),
                  ('89 × 36 mm (dirección DYMO)', 89.0, 36.0),
                ])
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.sell_outlined, size: 18),
                    title: Text(label),
                    onTap: () => Navigator.pop(ctx, (w, h)),
                  ),
                const Divider(),
                Row(children: [
                  Expanded(
                    child: TextField(
                        controller: wC,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Ancho (mm)')),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: hC,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Alto (mm)')),
                  ),
                  TextButton(
                    onPressed: () {
                      final w = double.tryParse(wC.text);
                      final h = double.tryParse(hC.text);
                      if (w != null && h != null && w > 20 && h > 15) {
                        Navigator.pop(ctx, (w, h));
                      }
                    },
                    child: const Text('Usar'),
                  ),
                ]),
              ]),
            );
          },
        );
        if (result != null) {
          await saveLabelSize(
              ref.read(syncServiceProvider), result.$1, result.$2);
          if (mounted) {
            setState(() { _w = result.$1; _h = result.$2; });
          }
        }
      },
    );
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  Future<void> _publish() async {
    setState(() => _busy = true);
    try {
      final res = await Supabase.instance.client.functions
          .invoke('connect-publish');
      if (!mounted) return;
      final ok = res.data is Map && res.data['ok'] == true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ok
              ? 'Publicado a YASTA: ${res.data['published']} ítems'
              : 'Error: ${res.data}')));
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(children: [
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Sincronizar ahora'),
          subtitle: Text(AppConfig.hasSupabase
              ? 'Servidor conectado'
              : 'Modo solo-local (sin credenciales de servidor)'),
          onTap: () async {
            final r = await ref.read(syncServiceProvider).syncAll();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(r.ok
                    ? 'Sincronizado: ${r.pushed}↑ ${r.pulled}↓'
                    : r.error!)));
          },
        ),
        ListTile(
          leading: const Icon(Icons.hub),
          title: const Text('Publicar disponibilidad a YASTA'),
          subtitle: const Text('Envía los modelos marcados como '
              'publicados a la red de socios YASTA'),
          trailing: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : null,
          enabled: AppConfig.hasSupabase && !_busy,
          onTap: _publish,
        ),
        _LabelSizeTile(),
        ListTile(
          leading: const Icon(Icons.admin_panel_settings_outlined),
          title: const Text('Administración'),
          subtitle: const Text('Códigos canónicos y atributos por '
              'familia'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AdminScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.upload_file),
          title: const Text('Importar portafolio'),
          onTap: () => context.go('/import'),
        ),
        const Divider(),
        if (AppConfig.hasSupabase)
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              await signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Alivio Constructor — Alquiler de Equipos y Herramientas'),
          subtitle: Text('Fase 1 — Inventario y ubicaciones · v0.1'),
        ),
      ]),
    );
  }
}
