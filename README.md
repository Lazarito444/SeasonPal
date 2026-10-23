# SeasonPal

Cooking companion: personal recipe library, AI cooking assistant, discovery feed, and a cooking community. Flutter client, ASP.NET Core API, PostgreSQL.

- Product spec: [docs/PRODUCT.md](docs/PRODUCT.md)
- Roadmap and current stage: [docs/ROADMAP.md](docs/ROADMAP.md)
- Conventions for contributors and agents: [AGENTS.md](AGENTS.md)

## Stack

| Layer | Tech |
| --- | --- |
| API | ASP.NET Core (.NET 10, minimal APIs), EF Core 10, FluentValidation, Serilog |
| Database | PostgreSQL 16 (Docker Compose, port **5433** on the host) |
| Mobile | Flutter 3.4x, Riverpod, go_router, Dio, slang (en/es) |

## Quick start

```bash
cp .env.example .env                                  # fill in Postgres + pgAdmin credentials
docker compose -f docker-compose.dev.yml up -d        # Postgres on :5433, pgAdmin on :5050
dotnet watch --project backend/src/SeasonPal.Api      # API on :5209, Scalar at /scalar
```

Copy the `POSTGRES_*` values into the API's Development connection string if you change them.

Mobile, from `mobile/`:

```bash
flutter pub get
adb reverse tcp:5209 tcp:5209                         # Android emulator / USB device only
flutter run                                           # defaults to the dev API on :5209
```

## Layout

```
backend/src/SeasonPal.Domain/          entities, enums, value objects, Result
backend/src/SeasonPal.Application/     DTOs, validation, specifications, interfaces
backend/src/SeasonPal.Infrastructure/  EF DbContext, migrations, storage, AI provider
backend/src/SeasonPal.Api/             minimal API endpoints, Program.cs
backend/tests/                         unit + integration tests (Testcontainers)
mobile/lib/features/<feature>/         data / domain / presentation per feature
docs/                                  product spec and roadmap
```

## Commands

```bash
dotnet build backend/SeasonPal.slnx
dotnet test backend/SeasonPal.slnx
dotnet ef migrations add <Name> -p backend/src/SeasonPal.Infrastructure -s backend/src/SeasonPal.Api

flutter test && dart format lib                       # from mobile/
dart run slang                                        # regenerate translations
```

Provider and JWT secrets go in user-secrets or environment variables, never in `appsettings*.json`.
