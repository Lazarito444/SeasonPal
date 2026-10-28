import 'package:flutter_test/flutter_test.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/features/auth/data/auth_api.dart';
import 'package:seasonpal/features/auth/data/auth_repository.dart';
import 'package:seasonpal/features/auth/data/token_storage.dart';
import 'package:seasonpal/features/auth/domain/auth_session.dart';

void main() {
  late _MemoryTokenStorage tokens;
  late _StubAuthApi api;
  late ApiAuthRepository repository;

  setUp(() {
    tokens = _MemoryTokenStorage();
    api = _StubAuthApi();
    repository = ApiAuthRepository(api, tokens);
  });

  test('signing in with "keep me signed in" stores the refresh token', () async {
    final session = await repository.login(
      email: 'ava@seasonpal.test',
      password: 'Saffron123!',
    );

    expect(tokens.token, session.refreshToken);
  });

  test('signing in without "keep me signed in" clears storage', () async {
    tokens.token = 'previous-session';

    final session = await repository.login(
      email: 'ava@seasonpal.test',
      password: 'Saffron123!',
      remember: false,
    );

    expect(session.refreshToken, 'refresh-token');
    expect(tokens.token, isNull);
  });

  test('refreshing does not persist a session that was not remembered', () async {
    final session = await repository.login(
      email: 'ava@seasonpal.test',
      password: 'Saffron123!',
      remember: false,
    );

    final refreshed = await repository.refresh(session);

    expect(refreshed.refreshToken, 'rotated-token');
    expect(tokens.token, isNull);
  });

  test('refreshing rotates the stored token when the session is remembered', () async {
    final session = await repository.login(
      email: 'ava@seasonpal.test',
      password: 'Saffron123!',
    );

    final refreshed = await repository.refresh(session);

    expect(refreshed.refreshToken, 'rotated-token');
    expect(tokens.token, 'rotated-token');
  });

  test('a reset request goes through the API unchanged', () async {
    await repository.forgotPassword('ava@seasonpal.test');

    expect(api.forgotEmails, ['ava@seasonpal.test']);
  });

  test('signing out clears storage even when the API call fails', () async {
    tokens.token = 'refresh-token';
    api.logoutError = true;

    await repository.logout(_session());

    expect(tokens.token, isNull);
  });
}

AuthSession _session() => AuthSession(
  accessToken: 'access-token',
  accessTokenExpiresAt: DateTime.utc(2026, 10, 20, 13),
  refreshToken: 'refresh-token',
  refreshTokenExpiresAt: DateTime.utc(2026, 11, 19),
  user: const AuthUser(
    id: 'user-1',
    email: 'ava@seasonpal.test',
    displayName: 'Ava Stone',
    onboardingCompleted: true,
  ),
);

final class _MemoryTokenStorage implements TokenStorage {
  String? token;

  @override
  Future<void> clear() async => token = null;

  @override
  Future<String?> readRefreshToken() async => token;

  @override
  Future<void> writeRefreshToken(String value) async => token = value;
}

final class _StubAuthApi implements AuthApi {
  final List<String> forgotEmails = [];
  bool logoutError = false;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async => _session();

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
  }) async => _session();

  @override
  Future<AuthSession> refresh(String refreshToken) async => _session().copyWith(refreshToken: 'rotated-token');

  @override
  Future<void> logout(String refreshToken) async {
    if (logoutError) {
      throw const ApiException(message: 'offline');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    forgotEmails.add(email);
  }
}
