# SeasonPal mobile

Flutter client for SeasonPal (Android and iOS).

## Run locally

From the repository root, start Postgres and the API:

```bash
docker compose -f docker-compose.dev.yml up -d
dotnet run --project backend/src/SeasonPal.Api
```

Then, in `mobile/`:

```bash
flutter pub get
flutter run --dart-define-from-file=config/api_dev.json
```

The build-time settings live in `config/api_dev.json` (`API_BASE_URL`,
default `http://localhost:5209`). Override per run when the API is elsewhere —
for example the Android emulator's host loopback:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5209
```

## Localization

The app ships English and Spanish. Slang generates typed accessors from
`lib/i18n/en.i18n.json` and `lib/i18n/es.i18n.json`:

```bash
dart run slang             # regenerate lib/i18n/strings.g.dart
dart run slang analyze     # find missing or unused keys
```

The device locale is used on first launch; the language menu on Home switches
between English and Español and remembers the choice with shared preferences.
Canonical API values (cuisines, diets, interests) stay English and are mapped
to localized labels in the presentation layer, so saved preferences and future
filters keep working in either language.

## Checks

```bash
dart format lib test
flutter analyze
flutter test
flutter build apk --debug     # Android compile check
dart run build_runner build   # regenerate freezed models
```

### Android build note

`android/gradle.properties` turns off Kotlin incremental compilation. The pub
cache and this checkout live on different Windows drives (`C:` and `D:`), and
Kotlin's incremental caches cannot relativize paths across drives. Remove the
flag once both share a drive.

Flavors (`dev`/`prod`) land with the prod config in Stage 11; until then the
environment is selected through the `--dart-define-from-file` config files.
