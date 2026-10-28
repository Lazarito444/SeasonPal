import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/l10n/locale_controller.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/core/widgets/brand_mark.dart';
import 'package:seasonpal/features/auth/presentation/auth_controller.dart';
import 'package:seasonpal/features/discovery/domain/discovery_models.dart';
import 'package:seasonpal/features/discovery/presentation/discovery_home_provider.dart';
import 'package:seasonpal/features/discovery/presentation/pantry_controller.dart';
import 'package:seasonpal/features/onboarding/data/preferences_repository.dart';
import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';
import 'package:seasonpal/features/onboarding/presentation/preference_labels.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// The cook's morning table: a greeting from the saved session, a pantry
/// shortcut for "what can I cook now", community rails, and the taste profile
/// that shapes them.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _pantryController = TextEditingController();

  @override
  void dispose() {
    _pantryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final locale = ref.watch(localeControllerProvider);
    final session = ref.watch(authControllerProvider).value;
    final firstName = _firstName(t, session?.user.displayName ?? '');
    final preferences = ref.watch(myPreferencesProvider);
    final home = ref.watch(discoveryHomeProvider);

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
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            onSelected: (selected) => ref.read(localeControllerProvider.notifier).setLocale(selected),
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
                            onPressed: () async => ref.read(authControllerProvider.notifier).logout(),
                            tooltip: t.home.signOut,
                            icon: const Icon(Icons.logout_rounded, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        t.home.greetings.line(
                          greeting: _greeting(t),
                          name: firstName,
                        ),
                        key: const Key('home-greeting'),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        t.home.whatCooking,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 26),
                      _PantryShelf(
                        controller: _pantryController,
                        onSubmit: _openPantry,
                      ),
                      const SizedBox(height: 30),
                      _HomeRails(
                        home: home,
                        onRetry: () => ref.invalidate(discoveryHomeProvider),
                      ),
                      const SizedBox(height: 30),
                      _TasteCard(preferences: preferences),
                      const SizedBox(height: 20),
                      const _LibraryCard(),
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

  /// Seeds the shared pantry shelf before opening the matcher so the shortcut
  /// lands on results instead of an empty form.
  void _openPantry() {
    final value = _pantryController.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.of(context).home.pantry.empty)),
      );
      return;
    }

    ref.read(pantryIngredientsProvider.notifier).replace([value]);
    _pantryController.clear();
    context.pushNamed(AppRoutes.pantryName);
  }
}

class _PantryShelf extends StatelessWidget {
  const _PantryShelf({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.forest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.kitchen_rounded,
                  size: 18,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                t.home.pantry.eyebrow,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.sage,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            t.home.pantry.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.creamRaised,
              fontSize: 24,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t.home.pantry.body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.cream.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('home-pantry-input'),
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            style: const TextStyle(color: AppColors.charcoal),
            decoration: InputDecoration(
              hintText: t.home.pantry.hint,
              prefixIcon: const Icon(Icons.search_rounded, size: 18),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              key: const Key('home-pantry-action'),
              onPressed: onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.sage,
                foregroundColor: AppColors.forestDeep,
                minimumSize: const Size(0, 48),
              ),
              child: Text(t.home.pantry.action),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeRails extends StatelessWidget {
  const _HomeRails({required this.home, required this.onRetry});

  final AsyncValue<DiscoveryHome> home;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return home.when(
      loading: () => _RailsLoading(label: t.home.rails.loading),
      error: (error, stackTrace) => _RailsError(
        title: t.home.rails.loadError,
        onRetry: onRetry,
      ),
      data: (data) {
        final rails = <Widget>[
          if (data.hasTasteProfile && data.recommended.isNotEmpty)
            _Rail(
              key: const Key('home-rail-for-you'),
              eyebrow: t.home.rails.forYouEyebrow,
              title: t.home.rails.forYouTitle,
              recipes: data.recommended,
            ),
          if (data.trending.isNotEmpty)
            _Rail(
              key: const Key('home-rail-trending'),
              eyebrow: t.home.rails.trendingEyebrow,
              title: t.home.rails.trendingTitle,
              recipes: data.trending,
            ),
          if (data.newest.isNotEmpty)
            _Rail(
              key: const Key('home-rail-newest'),
              eyebrow: t.home.rails.newestEyebrow,
              title: t.home.rails.newestTitle,
              recipes: data.newest,
            ),
        ];

        if (rails.isEmpty) {
          return const _RailsEmpty();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < rails.length; index++) ...[
              rails[index],
              if (index < rails.length - 1) const SizedBox(height: 28),
            ],
          ],
        );
      },
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({
    required this.eyebrow,
    required this.title,
    required this.recipes,
    super.key,
  });

  final String eyebrow;
  final String title;
  final List<RecipeSummary> recipes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 286,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: recipes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return SizedBox(
                width: 196,
                child: RecipeCard(
                  recipe: recipe,
                  onTap: () => context.pushNamed(
                    AppRoutes.recipeDetailName,
                    pathParameters: {'id': recipe.id},
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RailsLoading extends StatelessWidget {
  const _RailsLoading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.creamRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.forest,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _RailsError extends StatelessWidget {
  const _RailsError({required this.title, required this.onRetry});

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.creamRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 20,
            color: AppColors.spice,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(t.common.tryAgain)),
        ],
      ),
    );
  }
}

class _RailsEmpty extends StatelessWidget {
  const _RailsEmpty();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        color: AppColors.sageMist.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.restaurant_rounded,
            size: 26,
            color: AppColors.forest,
          ),
          const SizedBox(height: 14),
          Text(
            t.home.rails.emptyTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20,
              color: AppColors.forest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t.home.rails.emptyBody,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.forest.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            key: const Key('home-open-discover'),
            onPressed: () => context.goNamed(AppRoutes.discoverName),
            icon: const Icon(Icons.explore_rounded, size: 18),
            label: Text(t.home.rails.action),
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
    final time = preferences.usualCookTimeMinutes == null ? t.home.taste.noTime : cookTimeLabel(t, preferences.usualCookTimeMinutes!);

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
            for (final cuisine in preferences.favoriteCuisines.take(4)) _TastePill(label: cuisineShortLabel(t, cuisine)),
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

class _LibraryCard extends StatelessWidget {
  const _LibraryCard();

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
                t.home.library.eyebrow,
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
            t.home.library.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.forest),
          ),
          const SizedBox(height: 6),
          Text(
            t.home.library.body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.forest.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.tonalIcon(
            key: const Key('home-open-library'),
            onPressed: () => context.goNamed(AppRoutes.libraryName),
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: Text(t.home.library.action),
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
    1 => t.home.taste.one(cuisine: cuisineShortLabel(t, cuisines.first)),
    2 => t.home.taste.two(
      first: cuisineShortLabel(t, cuisines[0]),
      second: cuisineShortLabel(t, cuisines[1]),
    ),
    _ => t.home.taste.many(
      first: cuisineShortLabel(t, cuisines[0]),
      second: cuisineShortLabel(t, cuisines[1]),
    ),
  };
}

String _dietLine(Translations t, UserPreferences preferences) {
  final restrictions = preferences.dietaryRestrictions;
  if (restrictions.isEmpty) {
    return t.home.taste.noRestrictions;
  }

  if (restrictions.length == 1) {
    return t.home.taste.dietOne(restriction: dietLabel(t, restrictions.first));
  }

  final last = dietLabel(t, restrictions.last);
  final leading = restrictions.take(restrictions.length - 1).map((item) => dietLabel(t, item)).join(', ');
  return t.home.taste.dietMany(leading: leading, last: last);
}
