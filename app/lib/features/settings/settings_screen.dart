import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config.dart';
import '../../data/sync/sync_service.dart';
import '../admin/admin_screen.dart';
import '../auth/auth_providers.dart';

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
          title: Text('DEMACO Rent a Tool'),
          subtitle: Text('Fase 1 — Inventario y ubicaciones · v0.1'),
        ),
      ]),
    );
  }
}
