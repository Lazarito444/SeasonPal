import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/features/auth/data/auth_repository.dart';
import 'package:seasonpal/features/auth/domain/auth_session.dart';
import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_detail_screen.dart';
import 'package:seasonpal/i18n/strings.g.dart';

import 'support/fake_recipe_repository.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('a recipe reads as ingredients and method with owner actions', (
    tester,
  ) async {
    final repository = FakeRecipeRepository(
      details: {
        'recipe-1': fakeRecipeDetail(
          id: 'recipe-1',
          title: 'Tomato soup',
          description: 'Slow-simmered and sweet.',
          cuisine: 'Italian',
          status: RecipeStatus.published,
          visibility: RecipeVisibility.public,
          tags: const ['Weeknight'],
          dietaryTags: const ['Vegetarian'],
          ingredients: const [
            RecipeIngredient(
              id: 'ingredient-1',
              order: 1,
              quantity: 2,
              unit: 'kg',
              name: 'Tomatoes',
              note: 'Very ripe',
            ),
          ],
          steps: const [
            RecipeStep(
              id: 'step-1',
              order: 1,
              instruction: 'Simmer gently.',
              tip: 'Do not let it boil hard.',
              timerSeconds: 600,
            ),
          ],
        ),
      },
    );

    await _pumpDetail(tester, repository);

    expect(find.text('Tomato soup'), findsOneWidget);
    expect(find.text('By Ava'), findsOneWidget);
    expect(find.text('2 kg'), findsOneWidget);
    expect(find.text('Tomatoes'), findsOneWidget);
    expect(find.text('PUBLIC'), findsOneWidget);

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Simmer gently.'),
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    expect(find.text('Simmer gently.'), findsOneWidget);
    expect(find.text('Do not let it boil hard.'), findsOneWidget);
    expect(find.text('10 min'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Vegetarian'),
      300,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    expect(find.text('Vegetarian'), findsOneWidget);

    await tester.tap(find.byKey(const Key('recipe-detail-menu')));
    await tester.pumpAndSettle();

    expect(find.text('Edit recipe'), findsOneWidget);
    expect(find.text('Make private'), findsOneWidget);
    expect(find.text('Delete recipe'), findsOneWidget);
  });

  testWidgets('saving a recipe from the detail sheet calls the API', (
    tester,
  ) async {
    final repository = FakeRecipeRepository(
      details: {
        'recipe-1': fakeRecipeDetail(id: 'recipe-1', title: 'Tomato soup'),
      },
    );

    await _pumpDetail(
      tester,
      repository,
      session: _sessionFor('someone-else'),
    );

    await tester.tap(find.byKey(const Key('recipe-save')));
    await tester.pumpAndSettle();

    expect(find.text('Save to a collection'), findsOneWidget);

    await tester.tap(find.byKey(const Key('save-sheet-favorites')));
    await tester.pumpAndSettle();

    expect(repository.lastSavedId, 'recipe-1');
    expect(repository.lastSavedCollectionId, isNull);
    expect(find.text('Saved to your library.'), findsOneWidget);
  });
}

Future<void> _pumpDetail(
  WidgetTester tester,
  RecipeRepository repository, {
  AuthSession? session,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/recipes/recipe-1',
    routes: [
      GoRoute(
        path: AppRoutes.recipeDetail,
        name: AppRoutes.recipeDetailName,
        builder: (context, state) => RecipeDetailScreen(recipeId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.recipeEdit,
        name: AppRoutes.recipeEditName,
        builder: (context, state) => const Scaffold(body: Text('edit')),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        recipeRepositoryProvider.overrideWithValue(repository),
        authRepositoryProvider.overrideWithValue(
          _FakeAuthRepository(session ?? _sessionFor('user-1')),
        ),
      ],
      child: TranslationProvider(
        child: MaterialApp.router(
          theme: buildAppTheme(),
          routerConfig: router,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

AuthSession _sessionFor(String userId) {
  return AuthSession(
    accessToken: 'access',
    accessTokenExpiresAt: DateTime(2026, 10, 20, 12),
    refreshToken: 'refresh',
    refreshTokenExpiresAt: DateTime(2026, 11, 20),
    user: AuthUser(
      id: userId,
      email: 'ava@example.com',
      displayName: 'Ava',
      onboardingCompleted: true,
    ),
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this.session);

  final AuthSession session;

  @override
  Future<AuthSession?> restore() async => session;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    bool remember = true,
  }) async => session;

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
  }) async => session;

  @override
  Future<AuthSession> refresh(AuthSession session) async => session;

  @override
  Future<void> forgotPassword(String email) async {}

  @override
  Future<void> logout(AuthSession session) async {}
}
