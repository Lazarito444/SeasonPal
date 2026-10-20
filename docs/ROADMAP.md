# SeasonPal — Development Roadmap

Backend: ASP.NET Core (.NET 10, minimal APIs) · Mobile: Flutter · DB: PostgreSQL 16 · Web client (v2): Angular.
Related docs: `docs/PRODUCT.md` (product spec), `AGENTS.md` (conventions).

## Steps checklist

- [x] Stage 0 — Repo, solution & Flutter shell
- [x] Stage 1 — Data model & migrations
- [x] Stage 2 — Auth, onboarding & preferences
- [ ] Stage 3 — Recipes API: CRUD, saving & collections
- [ ] Stage 4 — Flutter library: auth, collection & recipe editor screens
- [ ] Stage 5 — Discovery: browse, search, filters, home feed
- [ ] Stage 6 — Seed content & demo data
- [ ] Stage 7 — AI cooking companion v1
- [ ] Stage 8 — Cooking mode & serving adjustment
- [ ] Stage 9 — Personalization & recommendations
- [ ] Stage 10 — Community: profiles, publishing, likes, comments, follows
- [ ] Stage 11 — Polish: states, accessibility, performance, release prep

Phases map as: Phase 1 = stages 0–7, Phase 2 = stages 8–9, Phase 3 = stage 10, v2 web = after stage 11.

## Assumptions (review before Stage 0)

1. **Database:** PostgreSQL 16 via Docker Compose locally. EF Core abstracts it; switching to SQL Server later is a provider + migration change, not a redesign.
2. **AI provider:** any OpenAI-compatible endpoint (OpenAI, Azure OpenAI, OpenRouter, local Ollama) configured by key/URL in server config. Key lives server-side only, never bundled in the app.
3. **Target platforms for Flutter:** Android + iOS from a single codebase. Environments are selected with `--dart-define-from-file` (`config/api_dev.json`); native flavors (`dev`/`prod`) arrive together at Stage 11.
4. **Media:** images (and videos — user content per spec §3A) go through an `IMediaStorage` abstraction (local disk folder in dev). Swappable for S3/Blob later; client always loads URLs, never binary payloads through DTOs. Video uploads enforce a per-file size cap.
5. **Email:** no SMTP in dev → password reset and email confirmation are deferred (noted limitation in Stage 2, built when SMTP config exists or at Stage 11).
6. **Push notifications:** deferred to Stage 10+; the Notification entity exists from Stage 1 so no retrofit.

## Stage 0 — Repo, solution & Flutter shell

**Deliverables**
- `git init`, `.gitignore` (dotnet + Flutter + secrets), first commit.
- `backend/SeasonPal.slnx` with Domain / Application / Infrastructure / Api projects wired by DI in `Program.cs`; empty-solution builds clean. xUnit test projects reference the right layers.
- `docker-compose.dev.yml` (postgres:16, healthcheck, named volume). Scalar UI enabled at `/scalar` in dev only.
- Flutter app `mobile/` created, Riverpod + go_router + Dio + freezed wired; app opens to a temporary "connectivity check" screen that calls `GET /health` and shows the backend status (proves the DevOps path end-to-end).
- `--dart-define-from-file` per-environment JSON (`config/api_dev.json`) handling in one config file.

**Acceptance:** `dotnet test` green with health-endpoint integration test; `flutter run` boots and shows live backend status; single commit of everything above.

## Stage 1 — Data model & migrations

**Entities (EF Core, PostgreSQL)**
- `User` (Identity) + `UserPreference` (cuisines, diet restrictions, skill level, preferred cook time, interests, onboarding-completed flag).
- `Recipe`: title, description, cover-image URL plus optional photo/video media list, servings, prep/cook times, difficulty, meal tags, `visibility` (private/public), `isAiGenerated`, `status` (draft/published/coming at stage 10), `sourceRecipeId` (adaptation provenance), author FK, timestamps.
- `RecipeIngredient` (recipeId, order, quantity double, unit, name, note) · `RecipeStep` (recipeId, order, text, tip, optional `timerSeconds`).
- `Collection` (userId, name, description, isDefaultFavorites) · `CollectionRecipe` (many-to-many).
- `SavedRecipe` (userId, recipeId, context: saved/favorites warm path), `Rating`, `Comment`, `Follow`, `CookingHistoryEntry`, `AiConversation` + `AiMessage`, `Notification`.
- Indexes: recipes by author, visibility + status, created-at for feeds; ingredient name lowercase index for search.

**Acceptance:** initial migration generates; `Application` layer references only `Domain` types; integration test constructs the context and round-trips one recipe with 3 ingredients and 4 steps.

## Stage 2 — Auth, onboarding & preferences

**API endpoints** (`AuthEndpoints.cs`, `OnboardingEndpoints.cs`): register, login (JWT access 15min + rotating refresh, httpOnly-free mobile flow: token response in body), refresh, logout, `GET/PUT /me/preferences`, password reset stub returning a dev-only flow after SMTP exists.

**Mobile:** login / register screens, onboarding wizard (welcome → cuisines → diet → skill + time → done), preference chips reused later on Profile.

**Acceptance:** integration tests cover register→login→refresh→me; invalid login yields ProblemDetails with rate limiting applied; Flutter wizard persists preferences and lands on a placeholder home that already greets by preference data.

## Stage 3 — Recipes API: CRUD, saving & collections

- `RecipeEndpoints.cs`: create (draft), read (own + any public-or-friends-visible), update, delete, publish/unpublish (enabled at Stage 10 but implemented now), list own by page with filters (cuisine, time, difficulty, diet, tag).
- `CollectionEndpoints.cs`: CRUD collections, add/remove/save recipes, reorder.
- Saving semantics: save-to-favorites in one call; save-to-collection optional second parameter.
- Ownership/authorization enforced at the application boundary (handler guards + aggregate invariants — user can only mutate own recipes/collections); no `XService` classes for plain CRUD: repositories plus aggregate behavior carry the DDD conventions in AGENTS.md.
- Ingredient quantities: double with unit normalization helper in Domain (no unit math here — that's Stage 8).

**Acceptance:** full CRUD integration tests incl. authorization failures (other user's recipe → 403/404); list endpoint pagination + filter tests.

## Stage 4 — Flutter library: collection & recipe editor screens

- Bottom navigation with the five product sections (Home, Discover, AI Cook, My Recipes, Profile) — panels that aren't built yet show a tasteful "coming next" state, no fake buttons.
- My Recipes: grid/list of saved + own recipes (tabs), create → structured editor form (7 sections per product spec), ingredient rows add/delete/reorder.
- Recipe detail screen: cover image, meta, ingredients, steps, save/collection actions, edit for own recipes, and an "adapt/ask AI" affordance only where wired.
- Media picking (photos and videos) → multipart upload endpoint (`IMediaStorage`, per-file size caps), URLs stored on the recipe.
- Design system starts here: define color tokens (forest green palette per PRODUCT.md), typography scale, recipe card component. Use the `frontend-design` skill for this screen set.

**Acceptance:** user can create → photo → save → close → reopen → edit a recipe through real API; offline-ish states show loading/empty/error patterns per screen.

## Stage 5 — Discovery: browse, search, filters

- `DiscoveryEndpoints.cs`: trending (saves + interests weighted, time-windowed), recommendations v0 (same-as-taste heuristic: cuisines + diet from preferences), search by text (ILIKE, name/ingredients/desc), filter chips (time, difficulty, diet, cuisine, meal type), paginated feed.
- Includes ingredient-to-recipe matching endpoint ("what can I cook with what I have" scored subset) — real DB math, not AI, so it works pre-AI-config.
- Mobile: Discover section (search + chips + feed), Home section skeleton (trending rail + newest rail + "pantry" shortcut that pre-seeds AI screen input).

**Acceptance:** feed respects `visibility=public` + published only; search relevance tests fixture-based; mobile discover filters compose (multiple picks at once).

## Stage 6 — Seed content & demo data

- Seed runner (invoked via config flag on startup): ~18 recipes across cuisines, each with real steps + ingredients, images downloaded into local dev storage at seed time from bundled manifest (no live network dependency in CI), demo users with distinct tastes, some public recipes + likes/follows to activate the feed.
- A seeded "demo cook" account documented in README so reviewers can log in and see a populated app.
- Every seeded item flagged in an `origin` column so it's never mistaken for real user content.

**Acceptance:** fresh DB → restart → running app shows populated Home/Discover/detail flows without hand-massaging data.

## Stage 7 — AI cooking companion v1

- `IAiChatService` (OpenAI-compatible client), config-driven provider + model + secret name.
- `AiEndpoints.cs`: `POST /ai/chat` (free-form cooking companion with conversation persistence), `POST /ai/recipes/from-pantry` (uses Stage 5 ingredient matcher + preferences context), `POST /ai/recipes/adapt` (a recipe + instruction → proposed recipe draft). Recipes coming from AI are stored with `isAiGenerated=true` and surfaced that way in every UI position.
- System prompts encode brand voice (warm, practical, non-intimidating) and personalization context (saved recipes, diet, skill level).
- Mobile: AI Cook screen (chat + pantry picker + suggestion cards with "save to My Recipes" that calls the recipe-create API).
- Guardrails: rate-limit per user, token/size caps, key access in Infrastructure only.

**Acceptance:** asking for pantry recipes returns AI suggestions carrying the user's dietary restrictions (prompt test via fixture provider); AI-created chat/recipes persisted; switching provider config to a fake provider passes the same integration tests (proves modularity), graceful config-missing error state.

## Stage 8 — Cooking mode & serving adjustment

- Serving-size scaling implemented as Domain logic (unit-aware qty scaling; fractions displayed human-friendly) — no AI involvement.
- Cooking-history + ratings endpoints (`CookingHistoryEntry` `CookingMode` completion records, `Rating` write).
- Mobile cooking mode: full-screen step player (one step at a time, big text), ingredient checklist, timers from `timerSeconds` (local notifications), scale servings control, "ask AI about this step" shortcut feeding Stage 7 chat with recipe+step context.

**Acceptance:** scaling tests (0.5×, 1.5×, 3×) sanity-checked against typical recipe units; timers fire with app in foreground/background; history + rating round-trip.

## Stage 9 — Personalization & recommendations

- Interaction-driven signals (save, cook, rate, adapt) recorded and fed to a new recommender that blends preference + history + trending, replacing the v0 heuristic in Stage 5's Home feed.
- Search upgrade: PostgreSQL full-text search (or trigram) for names/ingredients if ILIKE proves too crude.
- Privacy: "personalization data" screen showing what's collected + toggle/history clear.

**Acceptance:** A-like validation that a preference-profile change moves Home feed ordering; clear/disable personalization flows tested.

## Stage 10 — Community

- Publish flow (draft → public), public profiles (display name, bio, interests, avatar), follows, likes, comments, recipe-adaptation publishing that credits `sourceRecipeId` author automatically.
- Discover expands to people; profile shows published recipes + followers.
- Notifications: in-app inbox for like/comment/follow/adapted-your-recipe events (push deferred, noted limitation).

**Acceptance:** end-to-end three-user flow: A publishes → B follows A → B saves/likes/comments → B adapts with credit → notifications appear for all parties.

## Stage 11 — Polish & release prep

- Loading/empty/error audit across all screens; accessibility pass (contrast, screen-reader labels, touch targets); performance pass (image sizing, list virtualization, cold-start budget).
- `prod` flavor + release config (Android/iOS signing stubs), README covering setup, demo account, API docs pointer.
- Fix SMTP-dependent account flows if SMTP becomes available; else keep documented as limitation.
- Hand-off doc listing what v2 Angular must consume (contracts listed rather than mobile-only assumptions — already enforced by convention).

**Acceptance:** no red states in dev QA checklist; store-submission prerequisites listed even if signing/certs are the user's task.
