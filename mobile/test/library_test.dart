import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seasonpal/core/media/media_urls.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/presentation/library_screen.dart';
import 'package:seasonpal/i18n/strings.g.dart';

import 'support/fake_recipe_repository.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  test('media URLs resolve relative storage paths against the API host', () {
    expect(
      resolveMediaUrl('/media/photo.jpg', apiBaseUrl: 'http://localhost:5209'),
      'http://localhost:5209/media/photo.jpg',
    );
    expect(
      resolveMediaUrl(
        'https://cdn.example.com/photo.jpg',
        apiBaseUrl: 'http://localhost:5209',
      ),
      'https://cdn.example.com/photo.jpg',
    );
    expect(
      resolveMediaUrl('//cdn.example.com/photo.jpg', apiBaseUrl: 'http://x'),
      '//cdn.example.com/photo.jpg',
    );
  });

  testWidgets('the library invites a first recipe when both tabs are empty', (
    tester,
  ) async {
    await _pumpLibrary(tester, FakeRecipeRepository());

    expect(find.text('Your first recipe starts here.'), findsOneWidget);
    expect(find.byKey(const Key('library-empty-new')), findsOneWidget);
    expect(find.text('Nothing saved yet.'), findsNothing);
  });

  testWidgets('own recipes render as cards and open the detail route', (
    tester,
  ) async {
    final repository = FakeRecipeRepository(
      own: [fakeRecipeSummary(id: 'recipe-1', title: 'Roast chicken')],
    );

    await _pumpLibrary(tester, repository);

    expect(find.text('Roast chicken'), findsOneWidget);
    expect(find.text('DRAFT'), findsOneWidget);
    expect(find.text('Serves 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('recipe-card-recipe-1')));
    await tester.pumpAndSettle();

    expect(find.text('detail recipe-1'), findsOneWidget);
  });

  testWidgets('a failed own list shows a retry state', (tester) async {
    final repository = FakeRecipeRepository(
      ownError: const ApiException(
        message: 'offline',
        kind: ApiFailureKind.connection,
      ),
    );

    await _pumpLibrary(tester, repository);

    expect(find.text("We couldn't load your recipes."), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}

Future<void> _pumpLibrary(
  WidgetTester tester,
  RecipeRepository repository,
) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: AppRoutes.library,
    routes: [
      GoRoute(
        path: AppRoutes.library,
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: AppRoutes.recipeNew,
        name: AppRoutes.recipeNewName,
        builder: (context, state) => const Scaffold(body: Text('new recipe')),
      ),
      GoRoute(
        path: AppRoutes.recipeDetail,
        name: AppRoutes.recipeDetailName,
        builder: (context, state) => Scaffold(body: Text('detail ${state.pathParameters['id']}')),
      ),
      GoRoute(
        path: AppRoutes.collections,
        name: AppRoutes.collectionsName,
        builder: (context, state) => const Scaffold(body: Text('collections')),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [recipeRepositoryProvider.overrideWithValue(repository)],
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
