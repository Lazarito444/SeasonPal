import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/features/auth/data/auth_api.dart';
import 'package:seasonpal/features/auth/data/token_storage.dart';
import 'package:seasonpal/features/auth/domain/auth_session.dart';

/// Session lifecycle used by the auth controller.
abstract interface class AuthRepository {
  /// Restores a session from the stored refresh token; null when signed out.
  Future<AuthSession?> restore();

  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
  });

  Future<AuthSession> login({
    required String email,
    required String password,
    bool remember = true,
  });

  Future<AuthSession> refresh(AuthSession session);

  Future<void> logout(AuthSession session);

  /// Requests a reset link. The API always accepts, so the screen can show the
  /// same success state for known and unknown addresses.
  Future<void> forgotPassword(String email);
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
      final refreshed = await _api.refresh(refreshToken);
      return await _remember(refreshed);
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
    bool remember = true,
  }) async => _remember(
    await _api.login(email: email, password: password),
    persist: remember,
  );

  @override
  Future<AuthSession> refresh(AuthSession session) async {
    final refreshed = await _api.refresh(session.refreshToken);
    // Rotate only a token that is actually stored. Without "remember me" the
    // session lives in memory, so a 401 refresh must not start persisting it.
    final persist = (await _tokens.readRefreshToken()) != null;
    return _remember(refreshed, persist: persist);
  }

  @override
  Future<void> forgotPassword(String email) => _api.forgotPassword(email);

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

  Future<AuthSession> _remember(
    AuthSession session, {
    bool persist = true,
  }) async {
    if (persist) {
      await _tokens.writeRefreshToken(session.refreshToken);
    } else {
      await _tokens.clear();
    }

    return session;
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ApiAuthRepository(
    ref.watch(authApiProvider),
    ref.watch(tokenStorageProvider),
  ),
);
