import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasonpal/app.dart';
import 'package:seasonpal/core/l10n/locale_store.dart';
import 'package:seasonpal/core/network/api_client.dart';
import 'package:seasonpal/features/auth/presentation/auth_session_access.dart';
import 'package:seasonpal/i18n/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
