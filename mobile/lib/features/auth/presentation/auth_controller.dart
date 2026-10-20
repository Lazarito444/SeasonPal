import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/auth_repository.dart';
import '../domain/auth_session.dart';

/// The single source of truth for the signed-in session.
final authControllerProvider = AsyncNotifierProvider<AuthController, AuthSession?>(
  AuthController.new,
  // Restore failures are surfaced on the splash with a manual retry; no silent
  // background retry loop against a possibly offline API.
  retry: (retryCount, error) => null,
);

final class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() => ref.watch(authRepositoryProvider).restore();

  Future<void> login({required String email, required String password}) async {
    final session = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    state = AsyncData(session);
  }

  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final session = await ref
        .read(authRepositoryProvider)
        .register(email: email, password: password, displayName: displayName);
    state = AsyncData(session);
  }

  /// Called by the API interceptor after a 401. A network failure keeps the
  /// session (the request still fails) while an invalid refresh token signs out.
  Future<bool> refreshSession() async {
    final current = state.value;
    if (current == null) {
      return false;
    }

    try {
      final refreshed = await ref.read(authRepositoryProvider).refresh(current);
      state = AsyncData(refreshed);
      return true;
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        state = const AsyncData(null);
      }

      return false;
    } on Object {
      return false;
    }
  }

  /// Flips the session flag after the wizard saved its answers so the router can
  /// move to home without another round trip.
  void markOnboardingCompleted() {
    final current = state.value;
    if (current == null || current.user.onboardingCompleted) {
      return;
    }

    state = AsyncData(
      current.copyWith(user: current.user.copyWith(onboardingCompleted: true)),
    );
  }

  Future<void> logout() async {
    final current = state.value;
    if (current != null) {
      await ref.read(authRepositoryProvider).logout(current);
    }

    state = const AsyncData(null);
  }
}
