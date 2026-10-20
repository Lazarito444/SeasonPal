import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../domain/backend_health.dart';

/// Readiness probe contract; presentation and tests depend on this rather
/// than on Dio.
abstract interface class HealthApi {
  Future<BackendHealth> check();
}

/// Probes `GET /health/ready`, the endpoint that also checks Postgres.
///
/// Network failures become data (`unreachable`/`degraded`) rather than
/// exceptions so the connectivity screen has no error branch to special-case.
final class HealthRepository implements HealthApi {
  const HealthRepository(this._dio);

  final Dio _dio;

  @override
  Future<BackendHealth> check() async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _dio.get<Object>('/health/ready');
      stopwatch.stop();

      final statusCode = response.statusCode ?? 0;
      return BackendHealth(
        availability: BackendAvailability.online,
        checkedAt: DateTime.now(),
        latency: stopwatch.elapsed,
        statusCode: statusCode,
      );
    } on DioException catch (error, stackTrace) {
      stopwatch.stop();
      final statusCode = error.response?.statusCode;

      // A response means the API is alive but unhealthy; no response means we
      // never reached it at all.
      final availability = statusCode == null
          ? BackendAvailability.unreachable
          : BackendAvailability.degraded;

      debugPrint('Health check failed (${error.type}): $error\n$stackTrace');

      return BackendHealth(
        availability: availability,
        checkedAt: DateTime.now(),
        latency: stopwatch.elapsed,
        statusCode: statusCode,
        detail: _describe(error),
      );
    }
  }

  String _describe(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => 'The API did not answer in time.',
      DioExceptionType.connectionError =>
        'Could not reach the API. Check that the backend is running.',
      DioExceptionType.badResponse =>
        'The API answered, but its readiness check failed.',
      DioExceptionType.cancel => 'The check was cancelled.',
      DioExceptionType.badCertificate =>
        'The API certificate could not be verified.',
      DioExceptionType.unknown => 'The health check failed unexpectedly.',
    };
  }
}
