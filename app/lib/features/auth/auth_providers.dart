import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config.dart';

final authChangesProvider = StreamProvider<AuthState>((ref) =>
    AppConfig.hasSupabase
        ? Supabase.instance.client.auth.onAuthStateChange
        : const Stream.empty());

/// En modo solo-local (sin credenciales Supabase) siempre "logueado".
final isLoggedInProvider = Provider<bool>((ref) {
  if (!AppConfig.hasSupabase) return true;
  ref.watch(authChangesProvider);
  return Supabase.instance.client.auth.currentSession != null;
});

Future<void> signIn(String email, String password) => Supabase
    .instance.client.auth
    .signInWithPassword(email: email, password: password);

Future<void> signOut() => Supabase.instance.client.auth.signOut();
