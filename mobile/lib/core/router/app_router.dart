import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/features/auth/presentation/auth_gate.dart';
import 'package:seasonpal/features/auth/presentation/login_screen.dart';
import 'package:seasonpal/features/auth/presentation/register_screen.dart';
import 'package:seasonpal/features/auth/presentation/splash_screen.dart';
import 'package:seasonpal/features/home/presentation/home_screen.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_screen.dart';

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
          // Any auth or splash route after sign-in lands home; future app
          // routes (recipes, discover) stay reachable once added.
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
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
