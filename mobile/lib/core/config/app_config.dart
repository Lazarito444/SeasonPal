import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Environment configuration, supplied at build time with
/// `--dart-define-from-file=config/api_dev.json`.
///
/// Values carry `String.fromEnvironment` defaults so a plain `flutter run`
/// still boots against the local dev API; a per-environment JSON overrides
/// them without touching source.
final class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  /// Defaults match `backend/src/SeasonPal.Api/Properties/launchSettings.json`.
  static const AppConfig fromEnvironment = AppConfig(
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:5209',
    ),
  );

  final String apiBaseUrl;
}

/// Single source of truth for build-time settings; override it in tests.
final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment,
);
