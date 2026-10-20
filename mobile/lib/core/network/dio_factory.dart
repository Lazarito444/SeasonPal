import 'package:dio/dio.dart';

/// Creates the configured Dio used by both the authenticated API client and
/// the raw auth client. Timeouts stay short: a cooking app should fail visibly
/// rather than leave the cook staring at a spinner.
Dio createBaseDio(String baseUrl) => Dio(
  BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    headers: const {'Accept': 'application/json'},
  ),
);
