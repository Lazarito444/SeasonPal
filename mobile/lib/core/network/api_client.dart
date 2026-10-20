import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

/// The app's only HTTP client.
///
/// Auth (access token plus rotating refresh) attaches here as an interceptor
/// in Stage 2, so features never build their own Dio instances and never see
/// token handling. Timeouts are short on purpose: a cooking app should fail
/// visibly rather than leave the cook staring at a spinner.
final class ApiClient {
  ApiClient({required String baseUrl})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: const {'Accept': 'application/json'},
        ),
      );

  final Dio dio;
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(baseUrl: config.apiBaseUrl);
});
