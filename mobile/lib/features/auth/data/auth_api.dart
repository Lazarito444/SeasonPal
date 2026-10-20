import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/core/config/app_config.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/network/dio_factory.dart';
import 'package:seasonpal/features/auth/domain/auth_session.dart';

/// Wire-level auth calls. Uses a raw Dio without the auth interceptor so a 401
/// on refresh cannot recursively trigger another refresh.
abstract interface class AuthApi {
  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
  });

  Future<AuthSession> login({required String email, required String password});

  Future<AuthSession> refresh(String refreshToken);

  Future<void> logout(String refreshToken);
}

final class DioAuthApi implements AuthApi {
  const DioAuthApi(this._dio);

  final Dio _dio;

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
  }) => _postSession('/auth/register', {
    'email': email,
    'password': password,
    if (displayName != null && displayName.trim().isNotEmpty) 'displayName': displayName.trim(),
  });

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) => _postSession('/auth/login', {'email': email, 'password': password});

  @override
  Future<AuthSession> refresh(String refreshToken) => _postSession('/auth/refresh', {'refreshToken': refreshToken});

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<void>(
        '/auth/logout',
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (error) {
      // A token that is already revoked is a successful local sign-out.
      if (error.response?.statusCode != 401) {
        throw ApiException.fromDio(error);
      }
    }
  }

  Future<AuthSession> _postSession(
    String path,
    Map<String, Object?> body,
  ) async {
    try {
      final response = await _dio.post<Object?>(path, data: body);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ApiException(
          message: 'The server returned an unexpected response.',
          code: 'client.unexpected-response',
        );
      }

      return AuthSession.fromJson(data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

final authDioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  return createBaseDio(config.apiBaseUrl);
});

final authApiProvider = Provider<AuthApi>(
  (ref) => DioAuthApi(ref.watch(authDioProvider)),
);
