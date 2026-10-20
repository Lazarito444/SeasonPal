import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonpal/app.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/features/auth/data/auth_repository.dart';
import 'package:seasonpal/features/auth/domain/auth_session.dart';
import 'package:seasonpal/features/onboarding/data/preferences_repository.dart';
import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';

void main() {
  testWidgets('login validates empty fields before calling the API', (
    tester,
  ) async {
    final auth = _FakeAuthRepository();

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
    expect(auth.loginCalls, 0);
  });

  testWidgets('signing in lands a new account on the onboarding wizard', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      loginResult: _session(onboardingCompleted: false),
    );

    await tester.pumpWidget(_app(auth: auth, preferences: _FakePreferences()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('login-email')),
      'ava@seasonpal.test',
    );
    await tester.enterText(
      find.byKey(const Key('login-password')),
      'Saffron123!',
    );
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text("Let's set the table."), findsOneWidget);
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
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Email or password is incorrect.'), findsOneWidget);
    expect(find.text('Welcome back.'), findsOneWidget);
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

    expect(find.text("Let's set the table."), findsOneWidget);

    await _tapKey(tester, 'onboarding-primary');
    expect(find.text('What do you crave?'), findsOneWidget);

    await _tapKey(tester, 'cuisine-Italian');
    await _tapKey(tester, 'cuisine-Middle Eastern');
    await _tapKey(tester, 'onboarding-primary');

    expect(find.text('Anything off the menu?'), findsOneWidget);

    await _tapKey(tester, 'diet-Vegetarian');
    await _tapKey(tester, 'interest-Weeknight dinners');
    await _tapKey(tester, 'onboarding-primary');

    expect(find.text('How do you like to cook?'), findsOneWidget);

    await _tapKey(tester, 'skill-intermediate');
    await _tapKey(tester, 'time-30');
    await _tapKey(tester, 'onboarding-primary');

    expect(find.text('Your kitchen is ready.'), findsOneWidget);
    expect(find.text('Italian, Middle Eastern'), findsOneWidget);
    expect(find.text('Vegetarian'), findsOneWidget);
    expect(find.text('30 min'), findsOneWidget);

    await _tapKey(tester, 'onboarding-primary');

    final saved = preferences.lastSaved;
    expect(saved, isNotNull);
    expect(saved!.onboardingCompleted, isTrue);
    expect(saved.favoriteCuisines, ['Italian', 'Middle Eastern']);
    expect(saved.dietaryRestrictions, ['Vegetarian']);
    expect(saved.skillLevel, SkillLevel.intermediate);
    expect(saved.usualCookTimeMinutes, 30);
    expect(saved.interests, ['Weeknight dinners']);

    expect(find.byKey(const Key('home-greeting')), findsOneWidget);
    expect(find.textContaining('Ava'), findsWidgets);
    expect(
      find.text('Your kitchen leans Italian and Middle Eastern.'),
      findsOneWidget,
    );
  });

  testWidgets('a failed session restore explains itself and can be retried', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      restoreFailures: 1,
      restored: _session(onboardingCompleted: true),
    );
    final preferences = _FakePreferences(
      current: UserPreferences(
        favoriteCuisines: const ['Italian'],
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

    // Finish the wizard with defaults: Begin + three Continues + Finish.
    for (var step = 0; step < 5; step++) {
      await _tapKey(tester, 'onboarding-primary');
    }

    expect(find.byKey(const Key('home-greeting')), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-sign-out')));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back.'), findsOneWidget);

    await tester.tap(find.text('Create an account'));
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
    await _tapKey(tester, 'register-submit');
    await tester.pumpAndSettle();

    expect(find.text("Let's set the table."), findsOneWidget);
    expect(find.text('Your kitchen is ready.'), findsNothing);
  });

  testWidgets('a restored session goes straight home, then can sign out', (
    tester,
  ) async {
    final auth = _FakeAuthRepository(
      restored: _session(onboardingCompleted: true),
    );
    final preferences = _FakePreferences(
      current: UserPreferences(
        favoriteCuisines: const ['Italian', 'Levantine'],
        dietaryRestrictions: const ['Vegetarian'],
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

    expect(find.text('Welcome back.'), findsOneWidget);
    expect(auth.logoutCalls, 1);
  });
}

Widget _app({
  required _FakeAuthRepository auth,
  required _FakePreferences preferences,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      preferencesRepositoryProvider.overrideWithValue(preferences),
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
    this.restoreFailures = 0,
  });

  final AuthSession? restored;
  final AuthSession? loginResult;
  final Object? loginError;
  final int restoreFailures;

  int loginCalls = 0;
  int logoutCalls = 0;
  int restoreCalls = 0;
  String? lastEmail;

  @override
  Future<AuthSession?> restore() async {
    restoreCalls += 1;
    if (restoreCalls <= restoreFailures) {
      throw const ApiException(
        message:
            'Could not reach SeasonPal. Check your connection and try again.',
      );
    }

    return restored;
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    loginCalls += 1;
    lastEmail = email;
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
  }) async => loginResult!;

  @override
  Future<AuthSession> refresh(AuthSession session) async => session;

  @override
  Future<void> logout(AuthSession session) async {
    logoutCalls += 1;
  }
}

final class _FakePreferences implements PreferencesRepository {
  _FakePreferences({UserPreferences? current})
    : current = current ?? UserPreferences();

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
