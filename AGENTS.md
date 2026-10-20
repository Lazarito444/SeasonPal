# SeasonPal — Agent Instructions

SeasonPal is a cooking companion app: personal recipe library, AI cooking assistant, discovery feed, and cooking community. Product spec: **docs/PRODUCT.md**. Roadmap and current stage: **docs/ROADMAP.md**. Keep both updated when behavior or plans change.

## Stack

- **Backend:** ASP.NET Core (.NET 10, minimal APIs), EF Core 10, FluentValidation; tests with xUnit. OpenAPI via `AddOpenApi` + Scalar (dev only). Central package management: versions live only in `backend/Directory.Packages.props` — csproj `PackageReference` entries never carry a `Version`.
- **Database:** PostgreSQL 16 through Npgsql/EF Core (Docker Compose for local dev). EF Core abstracts the provider — no provider-specific SQL in Application/Domain layers.
- **Mobile:** Flutter 3.4x (current stable channel), Riverpod (hand-written providers, no riverpod_annotation/codegen), go_router, Dio, freezed.
- **v2 (planned):** Angular web client consuming the same API. Keep the API client-agnostic; no mobile-only response shapes.
- **AI:** provider-agnostic `IAiChatService` in Infrastructure, configured via appsettings (OpenAI-compatible by default). Keys only server-side, never in Flutter.

## Repository layout

```
SeasonPal/
  AGENTS.md
  docs/PRODUCT.md · docs/ROADMAP.md
  backend/
    SeasonPal.slnx
    src/SeasonPal.Domain/          entities, enums, value objects — no dependencies
    src/SeasonPal.Application/     services, DTOs, validation, specifications, interfaces — no EF/DI implementation details
    src/SeasonPal.Infrastructure/  EF DbContext, migrations, specification executor, IAiChatService, IMediaStorage, seed data
    src/SeasonPal.Api/             minimal API endpoints + Program.cs composition root
    tests/SeasonPal.UnitTests/
    tests/SeasonPal.IntegrationTests/
  mobile/                          Flutter app (lib/features/<feature>/{data,domain,presentation})
  docker-compose.dev.yml           postgres:16
```

## Commands

```bash
docker compose -f docker-compose.dev.yml up -d        # local Postgres
dotnet build backend/SeasonPal.slnx
dotnet watch --project backend/src/SeasonPal.Api
dotnet ef migrations add <Name> -p backend/src/SeasonPal.Infrastructure -s backend/src/SeasonPal.Api
dotnet test backend/SeasonPal.slnx
flutter pub get && flutter run --flavor dev           # mobile/
flutter test (mobile/); dart format mobile/lib
```

Flutter API base URL comes from `--dart-define-from-file` pointing at a per-environment JSON (e.g. `config/api_dev.json`), default targeting the dev backend.

## Backend rules

- Minimal API endpoints live in one file per feature (`RecipeEndpoints.cs`, …), each exposing a `RouteGroupBuilder` via an extension method called from `Program.cs`. Endpoints stay thin: validate → call Application service → return DTO. Business logic never lives in endpoints.
- Entities are never returned directly; every boundary crossing uses a DTO. Requests validated with FluentValidation. Raw exceptions go through `IExceptionHandler` → ProblemDetails; no 500 leaks.
- Business errors use the `Result<T>` pattern: `IsSuccess`/`Failure`, `Match`, `Bind`. Failed results carry typed errors with arg lists ready for i18n — no hardcoded user-facing strings in Application. Endpoints map failures to HTTP status + ProblemDetails.
- List queries are composed as `Specification<T>` objects in Application (criteria + selector + ordering + paging); Infrastructure executes them against EF Core. No IQueryable leaks beyond Infrastructure.
- Pagination on every list endpoint (`page`/`pageSize`, capped). Never return unbounded collections. Filtered queries translate fully to SQL (disable client evaluation).
- Enums stored as ints in EF. `double` for ingredient quantities (not money — exact decimals add Decimal↔Dart friction for no benefit); `DateOnly` where time is irrelevant; `DateTimeOffset`/UTC everywhere else.
- Secrets, connection strings, AI keys: user-secrets / environment only. Never in source, never to the client.
- Auth: ASP.NET Identity + short-lived JWT access tokens (15 min) with rotating refresh tokens. Scaffold `/auth/*` endpoints. CORS restricted to known origins; rate-limit auth endpoints; protect account-changing endpoints (confirm identity).
- Every recipe carries `visibility` (`private`/`public`), `isAiGenerated`, and — for adaptations — `sourceRecipeId`. These fields are not optional details; community vs. personal privacy and AI provenance depend on them.

## Flutter rules

- Features-first structure under `lib/features/`. Widgets stay presentational; state through Riverpod providers; routing via go_router with route names/paths centralized.
- One `ApiClient` (Dio) with auth interceptor handling access-token refresh. DTOs via freezed, mirroring API contracts. No API/business logic in widgets.
- Design: deep forest green + warm cream + sage + charcoal + restrained spice accent. Food-first, quiet decoration, real loading/empty/error states for every screen — use the `frontend-design` skill when starting UI work.
- Clearly label AI-generated recipes and any demo/seed content if ever shown as data.

## Testing & stage discipline

- Unit tests for Application services; integration tests per endpoint group (auth, recipes, AI, community) hitting a real EF context.
- Implement one roadmap stage at a time. After each: run critical flows, then update the stage checkboxes in docs/ROADMAP.md and the Status line below, and report what's done, what's limited, and the next step.
- Don't build UI affordances that do nothing; connected behavior or an explicit "planned" placeholder only. Don't invent features beyond docs/PRODUCT.md without asking.

## Status

Stage 0 (backend) and Stage 1 complete: `backend/` solution (Domain / Application / Infrastructure / Api + both test projects), `docker-compose.dev.yml`, InitialCreate migration, health endpoints verified live against the dev DB, 12 tests green (8 unit, 4 integration via Testcontainers Postgres). Flutter shell still pending. Next: Stage 2 — auth, onboarding & preferences. Local dev DB publishes on **port 5433** (host 5432 is occupied by the machine's own Postgres service).
