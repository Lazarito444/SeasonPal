import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_backdrop.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../onboarding/data/preferences_repository.dart';
import '../../onboarding/domain/user_preferences.dart';
import '../../onboarding/presentation/preference_labels.dart';

/// Stage 2 landing place: a real greeting from the saved session and taste
/// profile, with the recipe library clearly marked as forthcoming.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final locale = ref.watch(localeControllerProvider);
    final session = ref.watch(authControllerProvider).value;
    final firstName = _firstName(t, session?.user.displayName ?? '');
    final preferences = ref.watch(myPreferencesProvider);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const BrandMark(size: 38),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              'SeasonPal',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 20,
                                    letterSpacing: -0.4,
                                    color: AppColors.forest,
                                  ),
                            ),
                          ),
                          const Spacer(),
                          PopupMenuButton<AppLocale>(
                            key: const Key('home-language'),
                            tooltip: t.home.language.tooltip,
                            icon: const Icon(Icons.language_rounded, size: 20),
                            onSelected: (selected) => ref
                                .read(localeControllerProvider.notifier)
                                .setLocale(selected),
                            itemBuilder: (context) => [
                              CheckedPopupMenuItem(
                                key: const Key('language-en'),
                                value: AppLocale.en,
                                checked: locale == AppLocale.en,
                                child: Text(t.home.language.english),
                              ),
                              CheckedPopupMenuItem(
                                key: const Key('language-es'),
                                value: AppLocale.es,
                                checked: locale == AppLocale.es,
                                child: Text(t.home.language.spanish),
                              ),
                            ],
                          ),
                          IconButton(
                            key: const Key('home-sign-out'),
                            onPressed: () async => ref
                                .read(authControllerProvider.notifier)
                                .logout(),
                            tooltip: t.home.signOut,
                            icon: const Icon(Icons.logout_rounded, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        t.home.greetings.line(
                          greeting: _greeting(t),
                          name: firstName,
                        ),
                        key: const Key('home-greeting'),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t.home.whatCooking,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      _TasteCard(preferences: preferences),
                      const SizedBox(height: 20),
                      const _ComingNextCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TasteCard extends ConsumerWidget {
  const _TasteCard({required this.preferences});

  final AsyncValue<UserPreferences> preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.creamRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                t.home.taste.eyebrow,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
              ),
              const Spacer(),
              Icon(
                Icons.restaurant_menu_rounded,
                size: 18,
                color: AppColors.forest.withValues(alpha: 0.55),
              ),
            ],
          ),
          const SizedBox(height: 16),
          switch (preferences) {
            AsyncValue(:final value?) => _TasteDetails(preferences: value),
            AsyncValue(hasError: true) => _TasteError(
              onRetry: () => ref.invalidate(myPreferencesProvider),
            ),
            _ => Row(
              children: [
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.home.taste.loading,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          },
        ],
      ),
    );
  }
}

class _TasteDetails extends StatelessWidget {
  const _TasteDetails({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final time = preferences.usualCookTimeMinutes == null
        ? t.home.taste.noTime
        : cookTimeLabel(t, preferences.usualCookTimeMinutes!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _tasteLine(t, preferences),
          key: const Key('home-taste'),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _dietLine(t, preferences),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final cuisine in preferences.favoriteCuisines.take(4))
              _TastePill(label: cuisineLabel(t, cuisine)),
            _TastePill(label: preferences.skillLevel.label(t)),
            _TastePill(label: time),
          ],
        ),
      ],
    );
  }
}

class _TastePill extends StatelessWidget {
  const _TastePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.sageMist.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          color: AppColors.forest,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TasteError extends StatelessWidget {
  const _TasteError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            t.home.taste.loadError,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        TextButton(onPressed: onRetry, child: Text(t.common.tryAgain)),
      ],
    );
  }
}

class _ComingNextCard extends StatelessWidget {
  const _ComingNextCard();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.sageMist.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                t.home.comingNext.eyebrow,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.forest),
              ),
              const Spacer(),
              const Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: AppColors.forest,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t.home.comingNext.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.forest),
          ),
          const SizedBox(height: 6),
          Text(
            t.home.comingNext.body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.forest.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

String _greeting(Translations t) {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return t.home.greetings.morning;
  }

  if (hour < 18) {
    return t.home.greetings.afternoon;
  }

  return t.home.greetings.evening;
}

String _firstName(Translations t, String displayName) {
  final trimmed = displayName.trim();
  if (trimmed.isEmpty) {
    return t.home.greetings.friend;
  }

  return trimmed.split(RegExp(r'\s+')).first;
}

String _tasteLine(Translations t, UserPreferences preferences) {
  final cuisines = preferences.favoriteCuisines;
  return switch (cuisines.length) {
    0 => t.home.taste.empty,
    1 => t.home.taste.one(cuisine: cuisineLabel(t, cuisines.first)),
    2 => t.home.taste.two(
      first: cuisineLabel(t, cuisines[0]),
      second: cuisineLabel(t, cuisines[1]),
    ),
    _ => t.home.taste.many(
      first: cuisineLabel(t, cuisines[0]),
      second: cuisineLabel(t, cuisines[1]),
    ),
  };
}

String _dietLine(Translations t, UserPreferences preferences) {
  final restrictions = preferences.dietaryRestrictions;
  if (restrictions.isEmpty) {
    return t.home.taste.noRestrictions;
  }

  if (restrictions.length == 1) {
    return t.home.taste.dietOne(
      restriction: dietLabel(t, restrictions.first).toLowerCase(),
    );
  }

  final last = dietLabel(t, restrictions.last).toLowerCase();
  final leading = restrictions
      .take(restrictions.length - 1)
      .map((item) => dietLabel(t, item).toLowerCase())
      .join(', ');
  return t.home.taste.dietMany(leading: leading, last: last);
}
