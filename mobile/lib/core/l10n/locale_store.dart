import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasonpal/i18n/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads and writes the persisted app-language override.
///
/// A missing value means "follow the device locale". Keeping the store behind
/// an interface lets widget tests use [MemoryLocaleStore] without platform
/// channels.
abstract interface class LocaleStore {
  AppLocale? read();

  Future<void> write(AppLocale locale);
}

final localeStoreProvider = Provider<LocaleStore>((ref) => MemoryLocaleStore());

/// Session-only store used by tests and by any embedding that does not care
/// about persistence.
final class MemoryLocaleStore implements LocaleStore {
  AppLocale? _locale;

  @override
  AppLocale? read() => _locale;

  @override
  Future<void> write(AppLocale locale) async => _locale = locale;
}

/// Persists the choice in shared preferences so the app reopens in the same
/// language instead of falling back to the device locale.
final class PreferencesLocaleStore implements LocaleStore {
  PreferencesLocaleStore(this._preferences);

  static const _key = 'seasonpal.locale';

  final SharedPreferences _preferences;

  @override
  AppLocale? read() {
    final raw = _preferences.getString(_key);
    return raw == null ? null : AppLocaleUtils.parse(raw);
  }

  @override
  Future<void> write(AppLocale locale) => _preferences.setString(_key, locale.languageCode);
}
