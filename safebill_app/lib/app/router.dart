import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'scaffold_with_navbar.dart';
import '../features/chat/chat_screen.dart';
import '../features/claims/claim_wizard_screen.dart';
import '../features/document_detail/document_detail_screen.dart';
import '../features/locker/locker_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/reminders/reminders_screen.dart';
import '../features/scan/scan_screen.dart';
import '../features/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: OnboardingScreen.routePath,
    routes: [
      GoRoute(
        path: OnboardingScreen.routePath,
        name: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: LockerScreen.routePath,
                name: LockerScreen.routeName,
                builder: (context, state) => const LockerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ChatScreen.routePath,
                name: ChatScreen.routeName,
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RemindersScreen.routePath,
                name: RemindersScreen.routeName,
                builder: (context, state) => const RemindersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: SettingsScreen.routePath,
                name: SettingsScreen.routeName,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: ScanScreen.routePath,
        name: ScanScreen.routeName,
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: DocumentDetailScreen.routePath,
        name: DocumentDetailScreen.routeName,
        builder: (context, state) {
          final docId = state.pathParameters['id']!;
          return DocumentDetailScreen(docId: docId);
        },
      ),
      GoRoute(
        path: ClaimWizardScreen.routePath,
        name: ClaimWizardScreen.routeName,
        builder: (context, state) => const ClaimWizardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Route ${state.uri} not found',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ),
  ),
);
