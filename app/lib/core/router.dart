import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_providers.dart';
import '../features/auth/login_screen.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/catalog/model_detail_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/import/import_screen.dart';
import '../features/locations/items_by_location_screen.dart';
import '../features/locations/locations_screen.dart';
import '../features/maintenance/maintenance_screen.dart';
import '../features/rentals/contract_detail_screen.dart';
import '../features/rentals/rentals_screen.dart';
import '../features/scan/scan_screen.dart';
import '../features/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final loggedIn = ref.watch(isLoggedInProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final atLogin = state.matchedLocation == '/login';
      if (!loggedIn) return atLogin ? null : '/login';
      if (atLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => Scaffold(
          body: shell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: shell.goBranch,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Inicio'),
              NavigationDestination(
                  icon: Icon(Icons.handyman_outlined),
                  selectedIcon: Icon(Icons.handyman),
                  label: 'Catálogo'),
              NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Rentas'),
              NavigationDestination(
                  icon: Icon(Icons.qr_code_scanner),
                  label: 'Escanear'),
              NavigationDestination(
                  icon: Icon(Icons.place_outlined),
                  selectedIcon: Icon(Icons.place),
                  label: 'Ubicaciones'),
            ],
          ),
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const DashboardScreen(),
              routes: [
                GoRoute(
                    path: 'import',
                    builder: (_, _) => const ImportScreen()),
                GoRoute(
                    path: 'settings',
                    builder: (_, _) => const SettingsScreen()),
                GoRoute(
                    path: 'maintenance',
                    builder: (_, _) => const MaintenanceScreen()),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/catalog',
              builder: (_, _) => const CatalogScreen(),
              routes: [
                GoRoute(
                  path: 'model/:id',
                  builder: (_, state) => ModelDetailScreen(
                      modelId: state.pathParameters['id']!,
                      highlightAssetId:
                          state.uri.queryParameters['asset']),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/rentals',
              builder: (_, _) => const RentalsScreen(),
              routes: [
                GoRoute(
                  path: 'contract/:id',
                  builder: (_, state) => ContractDetailScreen(
                      contractId: state.pathParameters['id']!),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/scan', builder: (_, _) => const ScanScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/locations',
              builder: (_, _) => const LocationsScreen(),
              routes: [
                GoRoute(
                  path: 'items/:id',
                  builder: (_, state) => ItemsByLocationScreen(
                      locationId: state.pathParameters['id']!),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});
