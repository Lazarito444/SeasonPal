import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../data/health_repository.dart';
import '../domain/backend_health.dart';

final healthRepositoryProvider = Provider<HealthApi>((ref) {
  return HealthRepository(ref.watch(apiClientProvider).dio);
});

/// One probe per screen visit; "Check again" invalidates it and reruns.
final backendHealthProvider = FutureProvider<BackendHealth>((ref) {
  return ref.watch(healthRepositoryProvider).check();
});
