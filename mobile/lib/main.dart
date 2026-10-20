import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/l10n/locale_store.dart';
import 'core/network/api_client.dart';
import 'features/auth/presentation/auth_session_access.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final localeStore = PreferencesLocaleStore(preferences);
  final savedLocale = localeStore.read();
  if (savedLocale != null) {
    LocaleSettings.setLocaleSync(savedLocale);
  } else {
    LocaleSettings.useDeviceLocaleSync();
  }

  runApp(
    ProviderScope(
      overrides: [
        sessionAccessProvider.overrideWith(AuthSessionAccess.new),
        localeStoreProvider.overrideWithValue(localeStore),
      ],
      child: const SeasonPalApp(),
    ),
  );
}
