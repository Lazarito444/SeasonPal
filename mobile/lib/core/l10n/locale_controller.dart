import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/strings.g.dart';
import 'locale_store.dart';

/// The active app language. Slang already exposes the generated catalog, so the
/// provider only mirrors it for widgets that need to show the current choice.
final localeControllerProvider = NotifierProvider<LocaleController, AppLocale>(
  LocaleController.new,
);

final class LocaleController extends Notifier<AppLocale> {
  @override
  AppLocale build() {
    // Keep the MaterialApp locale in sync with slang, including device-locale
    // changes while the app is running.
    final subscription = LocaleSettings.getLocaleStream().listen((locale) {
      state = locale;
    });
    ref.onDispose(subscription.cancel);

    return LocaleSettings.currentLocale;
  }

  /// Applies the locale immediately, then persists it. A failed write only
  /// loses the preference, not the language already shown in this session.
  Future<void> setLocale(AppLocale locale) async {
    LocaleSettings.setLocaleSync(locale);
    state = locale;

    try {
      await ref.read(localeStoreProvider).write(locale);
    } on Object {
      // Storage is best-effort; the in-memory switch already succeeded.
    }
  }
}
