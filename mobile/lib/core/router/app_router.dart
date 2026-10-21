import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/features/auth/presentation/auth_gate.dart';
import 'package:seasonpal/features/auth/presentation/login_screen.dart';
import 'package:seasonpal/features/auth/presentation/register_screen.dart';
import 'package:seasonpal/features/auth/presentation/splash_screen.dart';
import 'package:seasonpal/features/discovery/presentation/discovery_screen.dart';
import 'package:seasonpal/features/discovery/presentation/pantry_screen.dart';
import 'package:seasonpal/features/home/presentation/home_screen.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_screen.dart';
import 'package:seasonpal/features/recipes/presentation/collection_detail_screen.dart';
import 'package:seasonpal/features/recipes/presentation/collections_screen.dart';
import 'package:seasonpal/features/recipes/presentation/library_screen.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_detail_screen.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_editor_screen.dart';
import 'package:seasonpal/features/shell/presentation/app_shell.dart';
import 'package:seasonpal/features/shell/presentation/coming_soon_screen.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Route paths and names in one place so redirects and widgets never carry
/// string literals.
abstract final class AppRoutes {
  static const splash = '/';
  static const splashName = 'splash';
  static const login = '/login';
  static const loginName = 'login';
  static const register = '/register';
  static const registerName = 'register';
  static const onboarding = '/onboarding';
  static const onboardingName = 'onboarding';
  static const home = '/home';
  static const homeName = 'home';
  static const discover = '/discover';
  static const discoverName = 'discover';
  static const pantry = '/pantry';
  static const pantryName = 'pantry';
  static const aiCook = '/ai-cook';
  static const aiCookName = 'aiCook';
  static const library = '/library';
  static const libraryName = 'library';
  static const profile = '/profile';
  static const profileName = 'profile';
  static const recipeNew = '/recipes/new';
  static const recipeNewName = 'recipeNew';
  static const recipeDetail = '/recipes/:id';
  static const recipeDetailName = 'recipeDetail';
  static const recipeEdit = '/recipes/:id/edit';
  static const recipeEditName = 'recipeEdit';
  static const collections = '/collections';
  static const collectionsName = 'collections';
  static const collectionDetail = '/collections/:id';
  static const collectionDetailName = 'collectionDetail';
}

/// Rebuilds only when the auth gate changes, not on every token refresh. The
/// redirect then keeps each part of the app on its only valid destination.
final appRouterProvider = Provider<GoRouter>((ref) {
  final gate = ref.watch(authGateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final location = state.matchedLocation;

      switch (gate) {
        case AuthGate.restoring:
        case AuthGate.error:
          return location == AppRoutes.splash ? null : AppRoutes.splash;
        case AuthGate.signedOut:
          return location == AppRoutes.login || location == AppRoutes.register ? null : AppRoutes.login;
        case AuthGate.onboarding:
          return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
        case AuthGate.ready:
          // Any auth or splash route after sign-in lands home; app routes
          // (library, recipes, collections) stay reachable.
          if (location == AppRoutes.splash || location == AppRoutes.login || location == AppRoutes.register || location == AppRoutes.onboarding) {
            return AppRoutes.home;
          }

          return null;
      }
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.homeName,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.discover,
                name: AppRoutes.discoverName,
                builder: (context, state) => const DiscoveryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.aiCook,
                name: AppRoutes.aiCookName,
                builder: (context, state) {
                  final t = Translations.of(context);
                  return ComingSoonScreen(
                    eyebrow: t.comingSoon.aiCook.eyebrow,
                    title: t.comingSoon.aiCook.title,
                    body: t.comingSoon.aiCook.body,
                    icon: Icons.auto_awesome_rounded,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.library,
                name: AppRoutes.libraryName,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: AppRoutes.profileName,
                builder: (context, state) {
                  final t = Translations.of(context);
                  return ComingSoonScreen(
                    eyebrow: t.comingSoon.profile.eyebrow,
                    title: t.comingSoon.profile.title,
                    body: t.comingSoon.profile.body,
                    icon: Icons.person_rounded,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.pantry,
        name: AppRoutes.pantryName,
        builder: (context, state) => const PantryScreen(),
      ),
      GoRoute(
        path: AppRoutes.recipeNew,
        name: AppRoutes.recipeNewName,
        builder: (context, state) => const RecipeEditorScreen(),
      ),
      GoRoute(
        path: AppRoutes.recipeEdit,
        name: AppRoutes.recipeEditName,
        builder: (context, state) => RecipeEditorScreen(recipeId: state.pathParameters['id']),
      ),
      GoRoute(
        path: AppRoutes.recipeDetail,
        name: AppRoutes.recipeDetailName,
        builder: (context, state) => RecipeDetailScreen(recipeId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.collections,
        name: AppRoutes.collectionsName,
        builder: (context, state) => const CollectionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.collectionDetail,
        name: AppRoutes.collectionDetailName,
        builder: (context, state) => CollectionDetailScreen(
          collectionId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});
