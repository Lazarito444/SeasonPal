import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';

/// Routing state derived from the session. A token refresh produces the same
/// gate value (and the same user), so GoRouter is not rebuilt for it.
enum AuthGate { restoring, error, signedOut, onboarding, ready }

final authGateProvider = Provider<AuthGate>((ref) {
  final auth = ref.watch(authControllerProvider);

  if (auth.isLoading) {
    return AuthGate.restoring;
  }

  if (auth.hasError) {
    return AuthGate.error;
  }

  final session = auth.value;
  if (session == null) {
    return AuthGate.signedOut;
  }

  return session.user.onboardingCompleted
      ? AuthGate.ready
      : AuthGate.onboarding;
});
