import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonpal/app.dart';
import 'package:seasonpal/core/l10n/locale_store.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/features/auth/data/auth_repository.dart';
import 'package:seasonpal/features/auth/domain/auth_session.dart';
import 'package:seasonpal/features/discovery/data/discovery_repository.dart';
import 'package:seasonpal/features/discovery/domain/discovery_models.dart';
import 'package:seasonpal/features/onboarding/data/preferences_repository.dart';
import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';
import 'package:seasonpal/i18n/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_discovery_repository.dart';
import 'support/fake_recipe_repository.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('the language choice persists in shared preferences', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final store = PreferencesLocaleStore(preferences);

    expect(store.read(), isNull);

    await store.write(AppLocale.es);

    expect(store.read(), AppLocale.es);
  });

  testWidgets('login validates empty fields before calling the API', (
    tester,
  ) async {
    final auth = _FakeAuthRepository();

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    await _tapKey(tester, 'login-submit');
    await tester.pumpAndSettle();

    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
    expect(auth.loginCalls, 0);
  });

  testWidgets('registering blocks a password that misses the server policy', (
    tester,
  ) async {
    final auth = _FakeAuthRepository();

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    await _tapKey(tester, 'login-create-account');
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('register-name')),
      'Ben Stone',
    );
    await tester.enterText(
      find.byKey(const Key('register-email')),
      'ben@seasonpal.test',
    );
    await tester.enterText(
      find.byKey(const Key('register-password')),
      'saffron123',
    );
    await _tapKey(tester, 'register-submit');
    await tester.pumpAndSettle();

    expect(
      find.text('Add upper and lower case, a number, and a symbol.'),
      findsOneWidget,
    );
    expect(auth.registerCalls, 0);
  });

  testWidgets('signing in lands a new account on the onboarding wizard', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      loginResult: _session(onboardingCompleted: false),
    );

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back.', findRichText: true), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('login-email')),
      'ava@seasonpal.test',
    );
    await tester.enterText(
      find.byKey(const Key('login-password')),
      'Saffron123!',
    );
    await _tapKey(tester, 'login-submit');
    await tester.pumpAndSettle();

    expect(find.text('Cook to the season.'), findsOneWidget);
    expect(auth.lastEmail, 'ava@seasonpal.test');
  });

  testWidgets('a rejected sign-in keeps the form and shows the API message', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      loginError: const ApiException(
        message: 'Email or password is incorrect.',
        statusCode: 401,
      ),
    );

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('login-email')),
      'ava@seasonpal.test',
    );
    await tester.enterText(
      find.byKey(const Key('login-password')),
      'wrong-password',
    );
    await _tapKey(tester, 'login-submit');
    await tester.pumpAndSettle();

    expect(find.text('Email or password is incorrect.'), findsOneWidget);
    expect(find.text('Welcome back.', findRichText: true), findsOneWidget);
  });

  testWidgets('the remember-me choice reaches the auth repository', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      loginResult: _session(onboardingCompleted: false),
    );

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    // On by default; one tap turns it off before signing in.
    await _tapKey(tester, 'login-remember');
    await tester.enterText(
      find.byKey(const Key('login-email')),
      'ava@seasonpal.test',
    );
    await tester.enterText(
      find.byKey(const Key('login-password')),
      'Saffron123!',
    );
    await _tapKey(tester, 'login-submit');

    expect(auth.lastRemember, isFalse);
  });

  testWidgets('a reset request is sent and the caveat is shown', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final auth = _FakeAuthRepository();

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    await _tapKey(tester, 'login-forgot');
    expect(
      find.text('Forgot your password?', findRichText: true),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('forgot-email')),
      'ava@seasonpal.test',
    );
    await _tapKey(tester, 'forgot-submit');

    expect(auth.forgotEmails, ['ava@seasonpal.test']);
    expect(find.text('Request received.', findRichText: true), findsOneWidget);
    expect(
      find.textContaining(
        "Email delivery isn't connected yet",
        findRichText: true,
      ),
      findsOneWidget,
    );

    await _tapKey(tester, 'forgot-back-to-sign-in');
    expect(find.text('Welcome back.', findRichText: true), findsOneWidget);
  });

  testWidgets('a rate-limited reset request keeps the form and explains', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      forgotError: const ApiException(
        message: 'Too many attempts. Wait a moment and try again.',
        statusCode: 429,
      ),
    );

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    await _tapKey(tester, 'login-forgot');
    await tester.enterText(
      find.byKey(const Key('forgot-email')),
      'ava@seasonpal.test',
    );
    await _tapKey(tester, 'forgot-submit');

    expect(
      find.text('Too many attempts. Wait a moment and try again.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('forgot-submit')), findsOneWidget);
    expect(auth.forgotEmails, isEmpty);
  });

  testWidgets('the password meter follows the strength rules', (
    tester,
  ) async {
    final auth = _FakeAuthRepository();

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    await _tapKey(tester, 'login-create-account');

    await tester.enterText(
      find.byKey(const Key('register-password')),
      'saffron123',
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Fair'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('register-password')),
      'Saffron123!',
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Strong'), findsOneWidget);
    expect(find.textContaining('Use 8+ characters'), findsNothing);
  });

  testWidgets('the wizard saves preferences and lands on the home greeting', (
    tester,
  ) async {
    // Phone-sized surface: the wizard, chips, and footer must fit without
    // overflow, which flutter_test surfaces as a failure.
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final auth = _FakeAuthRepository(
      restored: _session(onboardingCompleted: false),
    );
    final preferences = _FakePreferences();

    await tester.pumpWidget(_app(auth: auth, preferences: preferences));
    await tester.pumpAndSettle();

    expect(find.text('Cook to the season.'), findsOneWidget);

    await _tapKey(tester, 'onboarding-primary');
    expect(find.text('Pick your favourite kitchens.'), findsOneWidget);

    // The first question holds the wizard until three cuisines are chosen.
    await _tapKey(tester, 'cuisine-Italian');
    await _tapKey(tester, 'cuisine-Middle Eastern');
    expect(find.text('Choose 1 more'), findsOneWidget);
    await _tapKey(tester, 'onboarding-primary');
    expect(find.text('Pick your favourite kitchens.'), findsOneWidget);

    await _tapKey(tester, 'cuisine-Mediterranean');
    expect(find.text('All set'), findsOneWidget);
    await _tapKey(tester, 'onboarding-primary');

    expect(find.text('Your pantry, your rules.'), findsOneWidget);

    await _tapKey(tester, 'diet-Vegetarian');
    await _tapKey(tester, 'interest-Weeknight dinners');
    await _tapKey(tester, 'onboarding-primary');

    expect(find.text('How do you cook?'), findsOneWidget);

    await _tapKey(tester, 'skill-intermediate');
    await _tapKey(tester, 'time-balanced');
    await _tapKey(tester, 'onboarding-primary');

    expect(find.text('The stove is warm.'), findsOneWidget);
    expect(find.text('Rustic Italian & pasta'), findsOneWidget);
    expect(find.text('Classic Mediterranean'), findsOneWidget);
    expect(find.text('Levantine & Middle Eastern'), findsOneWidget);
    expect(find.text('Vegetarian'), findsOneWidget);
    expect(find.text('30–45 min'), findsOneWidget);
    expect(find.text('Confident home cook'), findsOneWidget);

    await _tapKey(tester, 'onboarding-primary');

    final saved = preferences.lastSaved;
    expect(saved, isNotNull);
    expect(saved!.onboardingCompleted, isTrue);
    expect(saved.favoriteCuisines, [
      'Italian',
      'Middle Eastern',
      'Mediterranean',
    ]);
    expect(saved.dietaryRestrictions, ['Vegetarian']);
    expect(saved.skillLevel, SkillLevel.intermediate);
    expect(saved.usualCookTimeMinutes, 45);
    expect(saved.interests, ['Weeknight dinners']);

    expect(find.byKey(const Key('home-greeting')), findsOneWidget);
    expect(find.textContaining('Ava'), findsWidgets);
    expect(find.textContaining('Your kitchen leans Italian'), findsOneWidget);
  });

  testWidgets('the recap pencil returns to the answer it edits', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _app(
        auth: _FakeAuthRepository(
          restored: _session(onboardingCompleted: false),
        ),
        preferences: _FakePreferences(),
      ),
    );
    await tester.pumpAndSettle();

    await _tapKey(tester, 'onboarding-primary');
    expect(find.text('Pick your favourite kitchens.'), findsOneWidget);

    await _tapKey(tester, 'cuisine-Italian');
    await _tapKey(tester, 'cuisine-Mexican');
    await _tapKey(tester, 'cuisine-Thai');
    await _tapKey(tester, 'onboarding-primary');
    await _tapKey(tester, 'onboarding-primary');
    await _tapKey(tester, 'onboarding-primary');

    expect(find.text('The stove is warm.'), findsOneWidget);

    await _tapKey(tester, 'recap-edit-cuisines');
    expect(find.text('Pick your favourite kitchens.'), findsOneWidget);
    expect(find.text('All set'), findsOneWidget);
  });

  testWidgets('skipping the wizard lands on home without preferences', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final preferences = _FakePreferences();

    await tester.pumpWidget(
      _app(
        auth: _FakeAuthRepository(
          restored: _session(onboardingCompleted: false),
        ),
        preferences: preferences,
      ),
    );
    await tester.pumpAndSettle();

    await _tapKey(tester, 'onboarding-skip');

    expect(preferences.lastSaved, isNotNull);
    expect(preferences.lastSaved!.favoriteCuisines, isEmpty);
    expect(preferences.lastSaved!.onboardingCompleted, isTrue);
    expect(find.byKey(const Key('home-greeting')), findsOneWidget);
  });

  testWidgets('a failed session restore explains itself and can be retried', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      restoreFailures: 1,
      restored: _session(onboardingCompleted: true),
    );
    final preferences = _FakePreferences(
      current: const UserPreferences(
        favoriteCuisines: ['Italian'],
        onboardingCompleted: true,
      ),
    );

    await tester.pumpWidget(_app(auth: auth, preferences: preferences));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Could not reach SeasonPal. Check your connection and try again.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(auth.restoreCalls, 2);
    expect(find.byKey(const Key('home-greeting')), findsOneWidget);
  });

  testWidgets('a second account starts with a clean onboarding wizard', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      restored: _session(onboardingCompleted: false),
      loginResult: _session(
        onboardingCompleted: false,
        displayName: 'Ben Stone',
        email: 'ben@seasonpal.test',
      ),
    );
    final preferences = _FakePreferences();

    await tester.pumpWidget(_app(auth: auth, preferences: preferences));
    await tester.pumpAndSettle();

    // Finish the wizard by skipping: a fresh account can also bypass it.
    await _tapKey(tester, 'onboarding-skip');

    expect(find.byKey(const Key('home-greeting')), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-sign-out')));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back.', findRichText: true), findsOneWidget);

    await _tapKey(tester, 'login-create-account');
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('register-name')), 'Ben Stone');
    await tester.enterText(
      find.byKey(const Key('register-email')),
      'ben@seasonpal.test',
    );
    await tester.enterText(
      find.byKey(const Key('register-password')),
      'Saffron123!',
    );
    await _tapKey(tester, 'register-terms');
    await _tapKey(tester, 'register-submit');
    await tester.pumpAndSettle();

    expect(find.text('Cook to the season.'), findsOneWidget);
    expect(find.text('The stove is warm.'), findsNothing);
  });

  testWidgets('a restored session goes straight home, then can sign out', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      restored: _session(onboardingCompleted: true),
    );
    final preferences = _FakePreferences(
      current: const UserPreferences(
        favoriteCuisines: ['Italian', 'Levantine'],
        dietaryRestrictions: ['Vegetarian'],
        skillLevel: SkillLevel.intermediate,
        usualCookTimeMinutes: 30,
        onboardingCompleted: true,
      ),
    );

    await tester.pumpWidget(_app(auth: auth, preferences: preferences));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-greeting')), findsOneWidget);
    expect(find.textContaining('Ava'), findsWidgets);
    expect(
      find.text('Your kitchen leans Italian and Levantine.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('home-sign-out')));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back.', findRichText: true), findsOneWidget);
    expect(auth.logoutCalls, 1);
  });

  testWidgets('home shows community rails and seeds the pantry from its shortcut', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final auth = _FakeAuthRepository(
      restored: _session(onboardingCompleted: true),
    );
    final preferences = _FakePreferences(
      current: const UserPreferences(
        favoriteCuisines: ['Italian'],
        dietaryRestrictions: ['Vegetarian'],
        skillLevel: SkillLevel.intermediate,
        usualCookTimeMinutes: 30,
        onboardingCompleted: true,
      ),
    );
    final discovery = FakeDiscoveryRepository(
      homeResult: DiscoveryHome(
        trending: [fakeRecipeSummary(id: 'trend-1', title: 'Lemon orzo')],
        newest: [fakeRecipeSummary(id: 'new-1', title: 'Roast chicken')],
        recommended: [fakeRecipeSummary(id: 'rec-1', title: 'White bean stew')],
        hasTasteProfile: true,
      ),
      pantryItems: [
        fakePantryMatch(
          recipe: fakeRecipeSummary(id: 'pantry-1', title: 'Pantry pasta'),
        ),
      ],
    );

    await tester.pumpWidget(
      _app(auth: auth, preferences: preferences, discovery: discovery),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-rail-for-you')), findsOneWidget);
    expect(find.byKey(const Key('home-rail-trending')), findsOneWidget);
    expect(find.text('Lemon orzo'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('home-pantry-input')),
      'lemon, orzo',
    );
    await tester.ensureVisible(find.byKey(const Key('home-pantry-action')));
    await tester.tap(find.byKey(const Key('home-pantry-action')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('pantry-input')), findsOneWidget);
    expect(discovery.lastPantryIngredients, ['lemon', 'orzo']);
    expect(find.text('Pantry pasta'), findsOneWidget);
    expect(find.text('CAN COOK'), findsOneWidget);
  });

  testWidgets('the language menu switches the app to Spanish and back', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      restored: _session(onboardingCompleted: true),
    );
    final preferences = _FakePreferences(
      current: const UserPreferences(
        favoriteCuisines: ['Italian', 'Mediterranean'],
        dietaryRestrictions: ['Vegetarian'],
        skillLevel: SkillLevel.intermediate,
        usualCookTimeMinutes: 30,
        onboardingCompleted: true,
      ),
    );

    await tester.pumpWidget(_app(auth: auth, preferences: preferences));
    await tester.pumpAndSettle();

    expect(find.text('What are we cooking today?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language-es')));
    await tester.pumpAndSettle();

    expect(find.text('¿Qué cocinamos hoy?'), findsOneWidget);
    expect(
      find.text('Tu cocina tira a Italiana y Mediterránea.'),
      findsOneWidget,
    );
    expect(find.text('Dieta Vegetariana.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language-en')));
    await tester.pumpAndSettle();

    expect(find.text('What are we cooking today?'), findsOneWidget);
    expect(
      find.text('Your kitchen leans Italian and Mediterranean.'),
      findsOneWidget,
    );
  });
}

Widget _app({
  required _FakeAuthRepository auth,
  required _FakePreferences preferences,
  DiscoveryRepository? discovery,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      preferencesRepositoryProvider.overrideWithValue(preferences),
      discoveryRepositoryProvider.overrideWithValue(
        discovery ?? FakeDiscoveryRepository(),
      ),
    ],
    child: const SeasonPalApp(),
  );
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

AuthSession _session({
  required bool onboardingCompleted,
  String displayName = 'Ava Stone',
  String email = 'ava@seasonpal.test',
}) {
  return AuthSession(
    accessToken: 'access-token',
    accessTokenExpiresAt: DateTime.utc(2026, 10, 20, 13),
    refreshToken: 'refresh-token',
    refreshTokenExpiresAt: DateTime.utc(2026, 11, 19),
    user: AuthUser(
      id: 'user-1',
      email: email,
      displayName: displayName,
      onboardingCompleted: onboardingCompleted,
    ),
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this.restored,
    this.loginResult,
    this.loginError,
    this.forgotError,
    this.restoreFailures = 0,
  });

  final AuthSession? restored;
  final AuthSession? loginResult;
  final Object? loginError;
  final Object? forgotError;
  final int restoreFailures;

  int loginCalls = 0;
  int logoutCalls = 0;
  int registerCalls = 0;
  int restoreCalls = 0;
  String? lastEmail;
  bool? lastRemember;
  final List<String> forgotEmails = [];

  @override
  Future<AuthSession?> restore() async {
    restoreCalls += 1;
    if (restoreCalls <= restoreFailures) {
      throw const ApiException(
        message: 'Could not reach SeasonPal. Check your connection and try again.',
      );
    }

    return restored;
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    bool remember = true,
  }) async {
    loginCalls += 1;
    lastEmail = email;
    lastRemember = remember;
    if (loginError != null) {
      throw loginError!;
    }

    return loginResult!;
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    registerCalls += 1;
    return loginResult!;
  }

  @override
  Future<AuthSession> refresh(AuthSession session) async => session;

  @override
  Future<void> forgotPassword(String email) async {
    if (forgotError != null) {
      throw forgotError!;
    }

    forgotEmails.add(email);
  }

  @override
  Future<void> logout(AuthSession session) async {
    logoutCalls += 1;
  }
}

final class _FakePreferences implements PreferencesRepository {
  _FakePreferences({UserPreferences? current}) : current = current ?? const UserPreferences();

  UserPreferences current;
  UserPreferences? lastSaved;

  @override
  Future<UserPreferences> fetch() async => current;

  @override
  Future<UserPreferences> save(UserPreferences preferences) async {
    lastSaved = preferences;
    current = preferences;
    return preferences;
  }
}
