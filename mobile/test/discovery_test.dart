import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/features/discovery/data/discovery_repository.dart';
import 'package:seasonpal/features/discovery/presentation/discovery_screen.dart';
import 'package:seasonpal/features/discovery/presentation/pantry_screen.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/i18n/strings.g.dart';

import 'support/fake_discovery_repository.dart';
import 'support/fake_recipe_repository.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('the discover feed renders public recipes and the count', (
    tester,
  ) async {
    _usePhone(tester);
    final discovery = FakeDiscoveryRepository(
      feedItems: [
        fakeRecipeSummary(id: 'one', title: 'Lemon orzo'),
        fakeRecipeSummary(id: 'two', title: 'Roast chicken'),
      ],
    );

    await tester.pumpWidget(_app(discovery: discovery));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('discovery-card-one')), findsOneWidget);
    expect(find.text('Lemon orzo'), findsOneWidget);
    expect(find.text('Roast chicken'), findsOneWidget);
    expect(find.text('2 recipes'), findsOneWidget);
  });

  testWidgets('filters combine into one feed request', (tester) async {
    _usePhone(tester);
    final discovery = FakeDiscoveryRepository(
      feedItems: [fakeRecipeSummary(id: 'one', title: 'Lemon orzo')],
    );

    await tester.pumpWidget(_app(discovery: discovery));
    await tester.pumpAndSettle();

    await _pick(tester, 'filter-cuisine', 'Italian');
    await _pick(tester, 'filter-meal', 'Dinner');
    await _pick(tester, 'filter-time', 'Under 30 min');
    await _pick(tester, 'filter-difficulty', 'Easy');
    await _pick(tester, 'filter-diet', 'Vegetarian');

    expect(discovery.lastFeed?.cuisine, 'Italian');
    expect(discovery.lastFeed?.mealType, MealType.dinner);
    expect(discovery.lastFeed?.maxTotalTimeMinutes, 30);
    expect(discovery.lastFeed?.difficulty, RecipeDifficulty.easy);
    expect(discovery.lastFeed?.diet, 'Vegetarian');
    expect(discovery.lastFeed?.page, 1);
  });

  testWidgets('search waits for the debounce before requesting', (
    tester,
  ) async {
    _usePhone(tester);
    final discovery = FakeDiscoveryRepository(
      feedItems: [fakeRecipeSummary(id: 'one', title: 'Lemon orzo')],
    );

    await tester.pumpWidget(_app(discovery: discovery));
    await tester.pumpAndSettle();
    expect(discovery.feedCalls, 1);

    await tester.enterText(
      find.byKey(const Key('discovery-search')),
      'lemon',
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(discovery.feedCalls, 1);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(discovery.feedCalls, 2);
    expect(discovery.lastFeed?.query, 'lemon');
  });

  testWidgets('an empty filtered feed offers a way to clear every filter', (
    tester,
  ) async {
    _usePhone(tester);
    final discovery = FakeDiscoveryRepository();

    await tester.pumpWidget(_app(discovery: discovery));
    await tester.pumpAndSettle();

    expect(
      find.text('The community table is still being set.'),
      findsOneWidget,
    );

    await _pick(tester, 'filter-cuisine', 'Italian');
    expect(find.text('Nothing matches that table.'), findsOneWidget);

    final clear = find.byKey(const Key('discovery-empty-clear'));
    await tester.ensureVisible(clear);
    await tester.tap(clear);
    await tester.pumpAndSettle();

    expect(discovery.lastFeed?.cuisine, isNull);
    expect(
      find.text('The community table is still being set.'),
      findsOneWidget,
    );
  });

  testWidgets('the pantry screen turns shelf terms into ranked matches', (
    tester,
  ) async {
    _usePhone(tester);
    final discovery = FakeDiscoveryRepository(
      pantryItems: [fakePantryMatch()],
    );

    await tester.pumpWidget(
      _app(discovery: discovery, child: const PantryScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start with what you have.'), findsOneWidget);
    expect(discovery.pantryCalls, 0);

    await tester.enterText(
      find.byKey(const Key('pantry-input')),
      'lemon, orzo',
    );
    await tester.tap(find.byKey(const Key('pantry-add')));
    await tester.pumpAndSettle();

    expect(discovery.lastPantryIngredients, ['lemon', 'orzo']);
    expect(find.byKey(const Key('pantry-chip-lemon')), findsOneWidget);
    expect(find.byKey(const Key('pantry-chip-orzo')), findsOneWidget);
    expect(find.text('Pantry pasta'), findsOneWidget);
    expect(find.text('100% match'), findsOneWidget);
    expect(find.text('You have everything.'), findsOneWidget);
    expect(find.text('CAN COOK'), findsOneWidget);
  });
}

/// Lays the test out on a phone-sized canvas so phone-only overflows fail.
void _usePhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _pick(
  WidgetTester tester,
  String filterKey,
  String option,
) async {
  final filter = find.byKey(Key(filterKey));
  await tester.ensureVisible(filter);
  await tester.pumpAndSettle();
  await tester.tap(filter);
  await tester.pumpAndSettle();

  final choice = find.widgetWithText(ListTile, option);
  await tester.ensureVisible(choice);
  await tester.tap(choice);
  await tester.pumpAndSettle();
}

Widget _app({required DiscoveryRepository discovery, Widget? child}) {
  return ProviderScope(
    overrides: [discoveryRepositoryProvider.overrideWithValue(discovery)],
    child: TranslationProvider(
      child: MaterialApp(
        theme: buildAppTheme(),
        locale: AppLocale.en.flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: child ?? const DiscoveryScreen(),
      ),
    ),
  );
}
