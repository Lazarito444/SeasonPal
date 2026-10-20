import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_backdrop.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../onboarding/data/preferences_repository.dart';
import '../../onboarding/domain/onboarding_options.dart';
import '../../onboarding/domain/user_preferences.dart';

/// Stage 2 landing place: a real greeting from the saved session and taste
/// profile, with the recipe library clearly marked as forthcoming.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).value;
    final firstName = _firstName(session?.user.displayName ?? '');
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
                          IconButton(
                            key: const Key('home-sign-out'),
                            onPressed: () async => ref
                                .read(authControllerProvider.notifier)
                                .logout(),
                            tooltip: 'Sign out',
                            icon: const Icon(Icons.logout_rounded, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        '${_greeting()}, $firstName.',
                        key: const Key('home-greeting'),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'What are we cooking today?',
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
                'YOUR TASTE',
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
                    'Reading your taste profile…',
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
    final time = preferences.usualCookTimeMinutes == null
        ? 'No set time'
        : OnboardingOptions.cookTimeLabel(preferences.usualCookTimeMinutes!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _tasteLine(preferences),
          key: const Key('home-taste'),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _dietLine(preferences),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final cuisine in preferences.favoriteCuisines.take(4))
              _TastePill(label: cuisine),
            _TastePill(label: preferences.skillLevel.label),
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
    return Row(
      children: [
        Expanded(
          child: Text(
            "We couldn't load your taste profile.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}

class _ComingNextCard extends StatelessWidget {
  const _ComingNextCard();

  @override
  Widget build(BuildContext context) {
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
                'COMING NEXT',
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
            'Your recipe library.',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.forest),
          ),
          const SizedBox(height: 6),
          Text(
            'Saved recipes, collections, and a cooking view are on the way.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.forest.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good morning';
  }

  if (hour < 18) {
    return 'Good afternoon';
  }

  return 'Good evening';
}

String _firstName(String displayName) {
  final trimmed = displayName.trim();
  if (trimmed.isEmpty) {
    return 'friend';
  }

  return trimmed.split(RegExp(r'\s+')).first;
}

String _tasteLine(UserPreferences preferences) {
  final cuisines = preferences.favoriteCuisines;
  return switch (cuisines.length) {
    0 => 'Your kitchen is open to anything.',
    1 => 'Your kitchen leans ${cuisines.first}.',
    2 => 'Your kitchen leans ${cuisines[0]} and ${cuisines[1]}.',
    _ => 'Your kitchen leans ${cuisines[0]}, ${cuisines[1]}, and more.',
  };
}

String _dietLine(UserPreferences preferences) {
  final restrictions = preferences.dietaryRestrictions;
  if (restrictions.isEmpty) {
    return 'No dietary restrictions saved.';
  }

  if (restrictions.length == 1) {
    return 'Cooking around ${restrictions.first.toLowerCase()}.';
  }

  final last = restrictions.last.toLowerCase();
  final leading = restrictions
      .take(restrictions.length - 1)
      .map((item) => item.toLowerCase())
      .join(', ');
  return 'Cooking around $leading and $last.';
}
