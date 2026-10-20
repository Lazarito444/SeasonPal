import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/connectivity/presentation/connectivity_screen.dart';

/// Route paths and names in one place so Stage 2 auth redirects and the
/// Stage 4 shell can be added without string literals leaking into widgets.
abstract final class AppRoutes {
  static const connectivity = '/';
  static const connectivityName = 'connectivity';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.connectivity,
    routes: [
      GoRoute(
        path: AppRoutes.connectivity,
        name: AppRoutes.connectivityName,
        builder: (context, state) => const ConnectivityScreen(),
      ),
    ],
  );
});
