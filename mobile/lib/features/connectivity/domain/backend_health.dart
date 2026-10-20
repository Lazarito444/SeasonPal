import 'package:freezed_annotation/freezed_annotation.dart';

part 'backend_health.freezed.dart';

/// What a readiness probe found. `degraded` means the API answered but a
/// dependency (Postgres) did not — a useful distinction in dev, where the
/// container is the usual suspect.
enum BackendAvailability { online, degraded, unreachable }

/// Immutable outcome of one health check, including latency so the dev screen
/// can show something more useful than a green dot.
@freezed
abstract class BackendHealth with _$BackendHealth {
  const factory BackendHealth({
    required BackendAvailability availability,
    required DateTime checkedAt,
    required Duration latency,
    int? statusCode,
    String? detail,
  }) = _BackendHealth;

  const BackendHealth._();

  bool get isOnline => availability == BackendAvailability.online;
}
