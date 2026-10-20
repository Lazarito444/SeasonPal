import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'features/auth/presentation/auth_session_access.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [sessionAccessProvider.overrideWith(AuthSessionAccess.new)],
      child: const SeasonPalApp(),
    ),
  );
}
