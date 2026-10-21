import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/features/discovery/data/discovery_repository.dart';
import 'package:seasonpal/features/discovery/domain/discovery_models.dart';

/// Home's three rails. Auto-disposed when the tab is left so the next visit
/// reflects saves and new publications from other cooks.
final discoveryHomeProvider = FutureProvider.autoDispose<DiscoveryHome>(
  (ref) => ref.watch(discoveryRepositoryProvider).home(),
);
