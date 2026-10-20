import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../domain/auth_session.dart';
import 'auth_api.dart';
import 'token_storage.dart';

/// Session lifecycle used by the auth controller.
abstract interface class AuthRepository {
  /// Restores a session from the stored refresh token; null when signed out.
  Future<AuthSession?> restore();

  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
  });

  Future<AuthSession> login({required String email, required String password});

  Future<AuthSession> refresh(AuthSession session);

  Future<void> logout(AuthSession session);
}

final class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository(this._api, this._tokens);

  final AuthApi _api;
  final TokenStorage _tokens;

  @override
  Future<AuthSession?> restore() async {
    final refreshToken = await _tokens.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      return _remember(await _api.refresh(refreshToken));
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await _tokens.clear();
        return null;
      }

      rethrow;
    }
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
  }) async => _remember(
    await _api.register(
      email: email,
      password: password,
      displayName: displayName,
    ),
  );

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async => _remember(await _api.login(email: email, password: password));

  @override
  Future<AuthSession> refresh(AuthSession session) async =>
      _remember(await _api.refresh(session.refreshToken));

  @override
  Future<void> logout(AuthSession session) async {
    try {
      await _api.logout(session.refreshToken);
    } on ApiException {
      // Local sign-out must succeed even when the server cannot be reached.
    } finally {
      await _tokens.clear();
    }
  }

  Future<AuthSession> _remember(AuthSession session) async {
    await _tokens.writeRefreshToken(session.refreshToken);
    return session;
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ApiAuthRepository(
    ref.watch(authApiProvider),
    ref.watch(tokenStorageProvider),
  ),
);
