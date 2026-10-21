import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/core/config/app_config.dart';

/// Turns a stored media location into something Flutter can render.
///
/// The API stores self-hosted uploads as root-relative paths (`/media/…`) so the
/// same row works behind any host. External http(s) URLs pass through untouched.
String resolveMediaUrl(String location, {required String apiBaseUrl}) {
  final trimmed = location.trim();
  final uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return trimmed;
  }

  if (uri.hasScheme) {
    return trimmed;
  }

  if (!trimmed.startsWith('/') || trimmed.startsWith('//')) {
    return trimmed;
  }

  final base = Uri.tryParse(apiBaseUrl);
  return base == null ? trimmed : base.resolve(trimmed).toString();
}

/// Resolves stored media for widgets; screens never need to know the API host.
final mediaUrlResolverProvider = Provider<String Function(String)>((ref) {
  final config = ref.watch(appConfigProvider);
  return (location) => resolveMediaUrl(location, apiBaseUrl: config.apiBaseUrl);
});
