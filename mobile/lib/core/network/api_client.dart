import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'dio_factory.dart';
import 'session_access.dart';

/// The app's only authenticated HTTP client. Features depend on this; auth
/// endpoints use the raw client in the auth feature to avoid a refresh loop.
final class ApiClient {
  ApiClient({
    required String baseUrl,
    required String? Function() accessToken,
    required Future<bool> Function() refreshSession,
  }) : dio = createBaseDio(baseUrl) {
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        accessToken: accessToken,
        refreshSession: refreshSession,
      ),
    );
  }

  final Dio dio;
}

/// Wired in main.dart to the auth controller.
final sessionAccessProvider = Provider<SessionAccess>(
  (ref) => throw StateError(
    'sessionAccessProvider must be overridden at the ProviderScope root.',
  ),
);

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final session = ref.watch(sessionAccessProvider);

  return ApiClient(
    baseUrl: config.apiBaseUrl,
    accessToken: () => session.accessToken,
    refreshSession: session.refreshSession,
  );
});
