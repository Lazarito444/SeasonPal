import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/core/l10n/locale_controller.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Root widget; reads the router from Riverpod so auth redirects (Stage 2)
/// can be driven by session state without rebuilding the app shell.
class SeasonPalApp extends ConsumerWidget {
  const SeasonPalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return TranslationProvider(
      child: MaterialApp.router(
        title: 'SeasonPal',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        locale: locale.flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: ref.watch(appRouterProvider),
      ),
    );
  }
}
