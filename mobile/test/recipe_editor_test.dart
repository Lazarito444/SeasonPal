import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_editor_screen.dart';
import 'package:seasonpal/i18n/strings.g.dart';

import 'support/fake_recipe_repository.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('a new recipe saves the form and opens its detail page', (
    tester,
  ) async {
    final repository = FakeRecipeRepository();
    await _pumpEditor(tester, repository);

    await tester.enterText(
      find.byKey(const Key('editor-title')),
      'Tomato soup',
    );

    final scrollable = find
        .descendant(
          of: find.byType(CustomScrollView),
          matching: find.byType(Scrollable),
        )
        .first;

    await tester.scrollUntilVisible(
      find.byKey(const Key('editor-ingredient-name-0')),
      320,
      scrollable: scrollable,
    );
    await tester.enterText(
      find.byKey(const Key('editor-ingredient-quantity-0')),
      '2',
    );
    await tester.enterText(
      find.byKey(const Key('editor-ingredient-unit-0')),
      'kg',
    );
    await tester.enterText(
      find.byKey(const Key('editor-ingredient-name-0')),
      'Tomatoes',
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('editor-step-instruction-0')),
      320,
      scrollable: scrollable,
    );
    await tester.enterText(
      find.byKey(const Key('editor-step-instruction-0')),
      'Simmer until sweet.',
    );
    await tester.enterText(
      find.byKey(const Key('editor-step-timer-0')),
      '10',
    );

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('editor-save')));
    await tester.pumpAndSettle();

    final input = repository.lastCreate;
    expect(input, isNotNull);
    expect(input!.title, 'Tomato soup');
    expect(input.ingredients.single.quantity, 2);
    expect(input.ingredients.single.unit, 'kg');
    expect(input.ingredients.single.name, 'Tomatoes');
    expect(input.steps.single.instruction, 'Simmer until sweet.');
    expect(input.steps.single.timerSeconds, 600);
    expect(find.text('detail created-recipe'), findsOneWidget);
  });

  testWidgets('an unnamed recipe is blocked before calling the API', (
    tester,
  ) async {
    final repository = FakeRecipeRepository();
    await _pumpEditor(tester, repository);

    await tester.tap(find.byKey(const Key('editor-save')));
    await tester.pump();

    expect(find.text('Give the recipe a name.'), findsOneWidget);
    expect(repository.lastCreate, isNull);
  });
}

Future<void> _pumpEditor(
  WidgetTester tester,
  RecipeRepository repository,
) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: AppRoutes.recipeNew,
    routes: [
      GoRoute(
        path: AppRoutes.recipeNew,
        name: AppRoutes.recipeNewName,
        builder: (context, state) => const RecipeEditorScreen(),
      ),
      GoRoute(
        path: AppRoutes.recipeDetail,
        name: AppRoutes.recipeDetailName,
        builder: (context, state) => Scaffold(body: Text('detail ${state.pathParameters['id']}')),
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
