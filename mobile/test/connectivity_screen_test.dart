import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonpal/core/config/app_config.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/features/connectivity/data/health_repository.dart';
import 'package:seasonpal/features/connectivity/domain/backend_health.dart';
import 'package:seasonpal/features/connectivity/presentation/connectivity_providers.dart';
import 'package:seasonpal/features/connectivity/presentation/connectivity_screen.dart';

void main() {
  testWidgets('reports a healthy API with its round-trip time', (tester) async {
    final api = _StubHealthApi(
      BackendHealth(
        availability: BackendAvailability.online,
        checkedAt: DateTime.utc(2026, 10, 20),
        latency: const Duration(milliseconds: 42),
        statusCode: 200,
      ),
    );

    await tester.pumpWidget(_harness(api));
    await tester.pumpAndSettle();

    expect(find.text('CONNECTED'), findsOneWidget);
    expect(find.text('Backend connected'), findsOneWidget);
    expect(find.textContaining('42 ms'), findsOneWidget);
    expect(find.text('http://localhost:5209'), findsOneWidget);
  });

  testWidgets('explains a degraded API instead of calling it offline', (
    tester,
  ) async {
    final api = _StubHealthApi(
      BackendHealth(
        availability: BackendAvailability.degraded,
        checkedAt: DateTime.utc(2026, 10, 20),
        latency: const Duration(milliseconds: 8),
        statusCode: 503,
        detail: 'The API answered, but its readiness check failed.',
      ),
    );

    await tester.pumpWidget(_harness(api));
    await tester.pumpAndSettle();

    expect(find.text('NOT READY'), findsOneWidget);
    expect(find.text('API is up, database is not'), findsOneWidget);
  });

  testWidgets('offers a retry that runs the check again', (tester) async {
    final api = _StubHealthApi(
      BackendHealth(
        availability: BackendAvailability.unreachable,
        checkedAt: DateTime.utc(2026, 10, 20),
        latency: const Duration(milliseconds: 3),
        detail: 'Could not reach the API. Check that the backend is running.',
      ),
    );

    await tester.pumpWidget(_harness(api));
    await tester.pumpAndSettle();

    expect(find.text('Backend unreachable'), findsOneWidget);
    expect(api.calls, 1);

    await tester.tap(find.byKey(const Key('retry-button')));
    await tester.pumpAndSettle();

    expect(api.calls, 2);
  });
}

Widget _harness(HealthApi api) {
  return ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(
        const AppConfig(apiBaseUrl: 'http://localhost:5209'),
      ),
      healthRepositoryProvider.overrideWithValue(api),
    ],
    child: MaterialApp(
      theme: buildAppTheme(),
      home: const ConnectivityScreen(),
    ),
  );
}

final class _StubHealthApi implements HealthApi {
  _StubHealthApi(this.result);

  final BackendHealth result;
  int calls = 0;

  @override
  Future<BackendHealth> check() async {
    calls += 1;
    return result;
  }
}
