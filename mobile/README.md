# SeasonPal mobile

Flutter client for SeasonPal (Android and iOS; the web target is kept for
quick local checks in a browser).

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

A browser check (the dev API allows `http://localhost:8095`):

```bash
flutter run -d web-server --web-port 8095 \
  --dart-define-from-file=config/api_dev.json
```

## Checks

```bash
dart format lib test
flutter analyze
flutter test
dart run build_runner build   # regenerate freezed models
```

Flavors (`dev`/`prod`) land with the prod config in Stage 11; until then the
environment is selected through the `--dart-define-from-file` config files.
