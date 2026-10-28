# SeasonPal — Agent Instructions

SeasonPal is a cooking companion app: personal recipe library, AI cooking assistant, discovery feed, and cooking community. Product spec: **docs/PRODUCT.md**. Roadmap and current stage: **docs/ROADMAP.md**. Keep both updated when behavior or plans change.

## Stack

- **Backend:** ASP.NET Core (.NET 10, minimal APIs), EF Core 10, FluentValidation; tests with xUnit. OpenAPI via `AddOpenApi` + Scalar (dev only). Central package management: versions live only in `backend/Directory.Packages.props` — csproj `PackageReference` entries never carry a `Version`. `TreatWarningsAsErrors` is on — new warnings fail the build.
- **Database:** PostgreSQL 16 through Npgsql/EF Core (Docker Compose for local dev). EF Core abstracts the provider — no provider-specific SQL in Application/Domain layers.
- **Mobile:** Flutter 3.4x (current stable channel), Riverpod (hand-written providers), go_router, Dio, hand-written immutable DTOs, slang (English and Spanish). No code generation beyond slang.
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
docker compose -f docker-compose.dev.yml up -d        # local Postgres + pgAdmin (reads .env)
dotnet build backend/SeasonPal.slnx
dotnet watch --project backend/src/SeasonPal.Api
dotnet ef migrations add <Name> -p backend/src/SeasonPal.Infrastructure -s backend/src/SeasonPal.Api
dotnet test backend/SeasonPal.slnx
flutter pub get && flutter run --flavor dev           # mobile/
flutter test (mobile/); dart format mobile/lib
dart run slang                                       # mobile/; regenerate translations
```

Copy `.env.example` to `.env` (git-ignored) and fill in the Postgres/pgAdmin credentials before the first `docker compose` run. Keep the `POSTGRES_*` values in sync with the API Development connection string.

Flutter API base URL comes from `--dart-define-from-file` pointing at a per-environment JSON (e.g. `config/api_dev.json`), default targeting the dev backend. The dev config uses `http://localhost:5209`, so run `adb reverse tcp:5209 tcp:5209` before launching on an Android emulator or USB-connected device.

pgAdmin runs at `http://localhost:5050` in desktop mode. Register the dev server with host `db`, port `5432`, and the database/user/password from `.env`.

## Backend rules

- Minimal API endpoints live in one file per feature (`RecipeEndpoints.cs`, …), each exposing a `RouteGroupBuilder` via a C# 14 `extension` member called from `Program.cs`. Endpoints stay thin: validate input → invoke aggregate behavior or a repository call → map the `Result` to DTO/ProblemDetails. Business logic lives in the domain, not endpoints.
- Domain-first (DDD): aggregates are the consistency boundary — `Recipe` (with `RecipeIngredient`, `RecipeStep`, `RecipeMedia` as children), `Collection`, and `AiConversation`; the other types are behavior-bearing entities or value objects. Invariants are enforced inside the domain (`Entity.Create` static factories returning `Result<T>`, guarded transitions, private setters + private EF materializer ctor, children built only through the root), never by an external class poking properties.
- No service classes by default: CRUD and single-aggregate flows are endpoint handler → repository → aggregate method. A dedicated service exists only for flows that orchestrate several aggregates or external systems (auth provisioning, AI pipelines, uploads) — and its name explains the flow, not "XService" for the rest.
- Each aggregate root gets one repository interface in Application, implemented in Infrastructure. The DbContext is the unit of work: handlers load through repositories, execute behavior, and `SaveChangesAsync` once.
- Entities are never returned directly; every boundary crossing uses a DTO. Requests validated with FluentValidation. Raw exceptions go through `IExceptionHandler` → ProblemDetails; no 500 leaks.
- Business errors use the `Result<T>` pattern (lives in `SeasonPal.Domain.Common` so aggregates can speak it; Application re-exports the convention): `IsSuccess`/`Failure`, `Match`, `Bind`. Failed results carry typed errors with arg lists ready for i18n — no hardcoded user-facing strings in Application. Endpoints map failures to HTTP status + ProblemDetails.
- List queries are composed as `Specification<T>` objects in Application (criteria + selector + ordering + paging); Infrastructure executes them against EF Core. No IQueryable leaks beyond Infrastructure.
- Pagination on every list endpoint (`page`/`pageSize`, capped). Never return unbounded collections. Filtered queries translate fully to SQL (disable client evaluation).
- Enums stored as ints in EF. `double` for ingredient quantities (not money — exact decimals add Decimal↔Dart friction for no benefit); `DateOnly` where time is irrelevant; `DateTimeOffset`/UTC everywhere else.
- Secrets, connection strings, AI keys: user-secrets / environment only. Never in source, never to the client.
- Auth: ASP.NET Identity + short-lived JWT access tokens (15 min) with rotating refresh tokens. Scaffold `/auth/*` endpoints. CORS restricted to known origins; rate-limit auth endpoints; protect account-changing endpoints (confirm identity).
- Every recipe carries `visibility` (`private`/`public`), `isAiGenerated`, and — for adaptations — `sourceRecipeId`. These fields are not optional details; community vs. personal privacy and AI provenance depend on them.

## Flutter rules

- Features-first structure under `lib/features/`. Widgets stay presentational; state through Riverpod providers; routing via go_router with route names/paths centralized.
- All user-facing copy goes through slang (`lib/i18n/<locale>.i18n.json`, generated `strings.g.dart`); no hardcoded UI strings. Persisted and API values stay canonical English and are localized only for display.
- One `ApiClient` (Dio) with auth interceptor handling access-token refresh. DTOs are hand-written immutable classes with explicit `fromJson` factories, mirroring API contracts. No API/business logic in widgets.
- Design: deep forest green + warm cream + sage + charcoal + restrained spice accent. Food-first, quiet decoration, real loading/empty/error states for every screen — use the `frontend-design` skill when starting UI work.
- Clearly label AI-generated recipes and any demo/seed content if ever shown as data.

## Testing & stage discipline

- Unit tests for Application services; integration tests per endpoint group (auth, recipes, AI, community) hitting a real EF context.
- Implement one roadmap stage at a time. After each: run critical flows, then update the stage checkboxes in docs/ROADMAP.md and the Status line below, and report what's done, what's limited, and the next step.
- Don't build UI affordances that do nothing; connected behavior or an explicit "planned" placeholder only. Don't invent features beyond docs/PRODUCT.md without asking.

## Status

Stage 0–5 complete: `backend/` solution (Domain / Application / Infrastructure / Api + both test projects), `docker-compose.dev.yml`, migrations, live health endpoints; auth with register/login/refresh/logout, per-IP rate limiting, `GET/PUT /me/preferences`; the Flutter shell with login/register and the five-step onboarding wizard rebuilt to the exports in `docs/design/onboarding/` (three-cuisine gate, recap with per-answer pencils, "skip for now" path, self-hosted Playfair Display + Plus Jakarta Sans on the cream/forest palette), and a home greeting driven by saved preferences; the Recipes/Collections API with recipe CRUD, draft→published transitions, unit normalization, paginated filtered lists, `Specification<T>` queries, save/unsave cascading into favorites and custom collections, and protected favorites; the Flutter library with a five-tab shell, Mine/Saved grid, recipe detail, seven-section create/edit form with media uploads and draft/publish, and collection screens; and discovery with a public published-only feed, composable cuisine/diet/meal/difficulty/max-time filters, case-insensitive search with weighted relevance, time-windowed trending, cuisine/diet recommendations v0, deterministic pantry matching, the Discover screen, Home rails and pantry shortcut, and the Pantry screen. 102 backend tests green (74 unit, 28 integration via Testcontainers Postgres) and 33 Flutter tests green (25 widget, 8 unit), with English/Spanish localization through slang and hand-written immutable DTOs. The Stage 4 acceptance flow (create → cover upload → publish → close → reopen → edit) was verified on an Android emulator against the live API. Next: Stage 6 — Seed content & demo data. Stage 2 limitations: password reset returns 202 without sending mail until SMTP exists; auth rate limiting is per client IP; refresh rotation has no optimistic concurrency; the three-cuisine gate, recap pencils and "skip for now" path are client-side behaviours (the API only stores `onboardingCompleted` plus the answer lists), and option cards use Material glyphs rather than bespoke illustrations. Stage 3 limitations: friends-only recipe visibility is deferred until follows exist at Stage 10, so non-owners only read published public recipes (others return 404 to avoid existence leaks); list pages default to 20 and cap at 50; reordering a collection requires the complete recipe-id list; unit normalization stores canonical spellings but performs no unit math until Stage 8. Stage 4 limitations: AI Cook and Profile are planned placeholders until Stages 7 and 10; drafts save with only a name while publishing needs at least one ingredient and one step; media accepts JPEG/PNG/WebP/GIF/MP4/MOV only (10 MB photos, 24 MB videos, 20 items) so HEIC is rejected; collection rename is API-only; iOS and physical devices were not exercised. Stage 5 limitations: discovery reads only published public recipes (friends-only waits for Stage 10); search is case-insensitive substring matching, not full-text/trigram; recommendations v0 have no fallback fill and use only cuisines/diet; trending uses a 200-recipe candidate pool and 10-item rails; pantry matching is substring-based, scores the 200 newest matching recipes, has no quantity/unit math until Stage 8, and caps at 30 terms; the pantry shortcut seeds the pantry screen and the shared provider reserved for the Stage 7 AI screen, which remains a placeholder. On this Windows host Smart App Control blocks locally built assemblies, so integration tests run in a Linux .NET SDK container against an external Postgres. Localization limitation: English/Spanish UI and coded API errors are translated client-side, but uncoded validation messages from the API remain English. The Flutter client targets Android and iOS only; its web target was removed. Local dev DB publishes on **port 5433** (host 5432 is occupied by the machine's own Postgres service).
