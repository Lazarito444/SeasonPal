import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/features/discovery/presentation/discovery_feed_controller.dart';
import 'package:seasonpal/features/discovery/presentation/discovery_filters.dart';
import 'package:seasonpal/features/discovery/presentation/discovery_home_provider.dart';
import 'package:seasonpal/features/onboarding/domain/onboarding_options.dart';
import 'package:seasonpal/features/onboarding/presentation/preference_labels.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_labels.dart';
import 'package:seasonpal/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// The community table: one search, five combinable filter stamps, and a
/// paginated feed of public published recipes. The pantry is one tap away
/// because "what can I cook now" is the question discovery should answer first.
class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final filters = ref.watch(discoveryFiltersProvider);
    final feed = ref.watch(discoveryFeedProvider);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.axis == Axis.vertical && notification.metrics.extentAfter < 500) {
                      ref.read(discoveryFeedProvider.notifier).loadMore();
                    }

                    return false;
                  },
                  child: RefreshIndicator(
                    color: AppColors.forest,
                    onRefresh: () => ref.read(discoveryFeedProvider.notifier).refresh(),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          sliver: SliverToBoxAdapter(
                            child: _Header(
                              filters: filters,
                              searchController: _searchController,
                              onSearchChanged: _onSearchChanged,
                              onSearchSubmitted: _submitSearch,
                              onClearSearch: _clearSearch,
                              onPickCuisine: () => _pickCuisine(filters),
                              onPickMeal: () => _pickMeal(filters),
                              onPickTime: () => _pickTime(filters),
                              onPickDifficulty: () => _pickDifficulty(filters),
                              onPickDiet: () => _pickDiet(filters),
                              onClearAll: _clearAll,
                            ),
                          ),
                        ),
                        ...feed.when(
                          loading: () => [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(24, 50, 24, 32),
                                child: _FeedLoading(label: t.discovery.feed.loading),
                              ),
                            ),
                          ],
                          error: (error, stackTrace) => [
                            SliverToBoxAdapter(
                              child: _FeedError(
                                title: t.discovery.feed.loadError,
                                detail: _errorDetail(t, error),
                                onRetry: () => ref.invalidate(discoveryFeedProvider),
                              ),
                            ),
                          ],
                          data: (page) => _feedSlivers(context, t, page, filters),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _feedSlivers(
    BuildContext context,
    Translations t,
    DiscoveryFeedPage page,
    DiscoveryFilters filters,
  ) {
    if (page.items.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: _FeedEmpty(
            hasFilters: filters.isActive,
            onClearFilters: _clearAll,
            onWriteRecipe: _openEditor,
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
        sliver: SliverToBoxAdapter(
          child: Row(
            children: [
              Text(
                page.totalCount == 1 ? t.discovery.feed.resultsOne : t.discovery.feed.results(count: page.totalCount),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.charcoalMuted,
                ),
              ),
              const Spacer(),
              Text(
                filters.query.isEmpty ? t.discovery.feed.newestFirst : t.discovery.feed.bestMatch,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            mainAxisExtent: 286,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final recipe = page.items[index];
            return RecipeCard(
              key: Key('discovery-card-${recipe.id}'),
              recipe: recipe,
              onTap: () => _openRecipe(recipe.id),
            );
          }, childCount: page.items.length),
        ),
      ),
      SliverToBoxAdapter(
        child: _FeedFooter(
          loading: page.loadingMore,
          error: page.loadMoreError == null ? null : t.discovery.feed.loadMoreError,
          onRetry: () => ref.read(discoveryFeedProvider.notifier).loadMore(),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 28)),
    ];
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(discoveryFiltersProvider.notifier).setQuery(value);
    });
  }

  /// Pressing the keyboard search key applies the text immediately instead of
  /// waiting for the debounce to expire.
  void _submitSearch(String value) {
    _debounce?.cancel();
    ref.read(discoveryFiltersProvider.notifier).setQuery(value);
  }

  void _clearSearch() {
    _searchController.clear();
    _debounce?.cancel();
    ref.read(discoveryFiltersProvider.notifier).setQuery('');
    setState(() {});
  }

  void _clearAll() {
    _searchController.clear();
    _debounce?.cancel();
    ref.read(discoveryFiltersProvider.notifier).clear();
    setState(() {});
  }

  Future<void> _openRecipe(String id) async {
    await context.pushNamed(
      AppRoutes.recipeDetailName,
      pathParameters: {'id': id},
    );
    if (mounted) {
      ref.invalidate(discoveryFeedProvider);
      ref.invalidate(discoveryHomeProvider);
    }
  }

  Future<void> _openEditor() async {
    await context.pushNamed(AppRoutes.recipeNewName);
    if (mounted) {
      ref.invalidate(discoveryFeedProvider);
      ref.invalidate(discoveryHomeProvider);
    }
  }

  Future<void> _pickCuisine(DiscoveryFilters filters) async {
    final t = Translations.of(context);
    await _pickOption<String>(
      title: t.discovery.filters.cuisine,
      selected: filters.cuisine,
      options: [
        for (final cuisine in OnboardingOptions.cuisines) (value: cuisine.value, label: cuisineShortLabel(t, cuisine.value)),
      ],
      onSelected: (value) => ref.read(discoveryFiltersProvider.notifier).setCuisine(value),
    );
  }

  Future<void> _pickMeal(DiscoveryFilters filters) async {
    final t = Translations.of(context);
    const meals = [
      MealType.breakfast,
      MealType.lunch,
      MealType.dinner,
      MealType.snack,
      MealType.dessert,
      MealType.drink,
    ];

    await _pickOption<MealType>(
      title: t.discovery.filters.meal,
      selected: filters.mealType,
      options: [
        for (final meal in meals) (value: meal, label: mealTypeLabel(t, meal)),
      ],
      onSelected: (value) => ref.read(discoveryFiltersProvider.notifier).setMealType(value),
    );
  }

  Future<void> _pickTime(DiscoveryFilters filters) async {
    final t = Translations.of(context);
    await _pickOption<int>(
      title: t.discovery.filters.time,
      selected: filters.maxTotalTimeMinutes,
      options: [
        for (final minutes in discoveryTimeOptions) (value: minutes, label: t.discovery.time.under(count: minutes)),
      ],
      onSelected: (value) => ref.read(discoveryFiltersProvider.notifier).setMaxTotalTimeMinutes(value),
    );
  }

  Future<void> _pickDifficulty(DiscoveryFilters filters) async {
    final t = Translations.of(context);
    await _pickOption<RecipeDifficulty>(
      title: t.discovery.filters.difficulty,
      selected: filters.difficulty,
      options: [
        for (final difficulty in RecipeDifficulty.values) (value: difficulty, label: difficultyLabel(t, difficulty)),
      ],
      onSelected: (value) => ref.read(discoveryFiltersProvider.notifier).setDifficulty(value),
    );
  }

  Future<void> _pickDiet(DiscoveryFilters filters) async {
    final t = Translations.of(context);
    await _pickOption<String>(
      title: t.discovery.filters.diet,
      selected: filters.diet,
      options: [
        for (final diet in OnboardingOptions.dietaryRestrictions) (value: diet.value, label: dietLabel(t, diet.value)),
      ],
      onSelected: (value) => ref.read(discoveryFiltersProvider.notifier).setDiet(value),
    );
  }

  Future<void> _pickOption<T>({
    required String title,
    required List<({T value, String label})> options,
    required T? selected,
    required ValueChanged<T?> onSelected,
  }) async {
    final t = Translations.of(context);
    final choice = await showModalBottomSheet<_SheetChoice<T>>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.creamRaised,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => _OptionSheet<T>(
        title: title,
        anyLabel: t.discovery.filters.any,
        options: options,
        selected: selected,
      ),
    );

    if (choice != null) {
      onSelected(choice.value);
    }
  }

  String _errorDetail(Translations t, Object error) {
    if (error is ApiException) {
      return localizeApiError(t, error);
    }

    return t.discovery.feed.loadError;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.filters,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    required this.onPickCuisine,
    required this.onPickMeal,
    required this.onPickTime,
    required this.onPickDifficulty,
    required this.onPickDiet,
    required this.onClearAll,
  });

  final DiscoveryFilters filters;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onClearSearch;
  final VoidCallback onPickCuisine;
  final VoidCallback onPickMeal;
  final VoidCallback onPickTime;
  final VoidCallback onPickDifficulty;
  final VoidCallback onPickDiet;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.discovery.eyebrow,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
        ),
        const SizedBox(height: 8),
        Text(
          t.discovery.title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(t.discovery.subtitle, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 22),
        TextField(
          key: const Key('discovery-search'),
          controller: searchController,
          textInputAction: TextInputAction.search,
          onChanged: onSearchChanged,
          onSubmitted: onSearchSubmitted,
          decoration: InputDecoration(
            hintText: t.discovery.searchHint,
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            suffixIcon: searchController.text.isEmpty
                ? null
                : IconButton(
                    key: const Key('discovery-search-clear'),
                    tooltip: t.common.dismiss,
                    onPressed: onClearSearch,
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 46,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _FilterStamp(
                key: const Key('filter-cuisine'),
                icon: Icons.public_rounded,
                label: filters.cuisine == null ? t.discovery.filters.cuisine : cuisineShortLabel(t, filters.cuisine!),
                active: filters.cuisine != null,
                onTap: onPickCuisine,
              ),
              const SizedBox(width: 8),
              _FilterStamp(
                key: const Key('filter-meal'),
                icon: Icons.restaurant_rounded,
                label: filters.mealType == null ? t.discovery.filters.meal : mealTypeLabel(t, filters.mealType!),
                active: filters.mealType != null,
                onTap: onPickMeal,
              ),
              const SizedBox(width: 8),
              _FilterStamp(
                key: const Key('filter-time'),
                icon: Icons.schedule_rounded,
                label: filters.maxTotalTimeMinutes == null
                    ? t.discovery.filters.time
                    : t.discovery.time.under(
                        count: filters.maxTotalTimeMinutes!,
                      ),
                active: filters.maxTotalTimeMinutes != null,
                onTap: onPickTime,
              ),
              const SizedBox(width: 8),
              _FilterStamp(
                key: const Key('filter-difficulty'),
                icon: Icons.signal_cellular_alt_rounded,
                label: filters.difficulty == null ? t.discovery.filters.difficulty : difficultyLabel(t, filters.difficulty!),
                active: filters.difficulty != null,
                onTap: onPickDifficulty,
              ),
              const SizedBox(width: 8),
              _FilterStamp(
                key: const Key('filter-diet'),
                icon: Icons.eco_rounded,
                label: filters.diet == null ? t.discovery.filters.diet : dietLabel(t, filters.diet!),
                active: filters.diet != null,
                onTap: onPickDiet,
              ),
              if (filters.isActive) ...[
                const SizedBox(width: 4),
                TextButton(
                  key: const Key('discovery-clear-filters'),
                  onPressed: onClearAll,
                  child: Text(t.discovery.filters.clearAll),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        _PantryCallout(
          onTap: () => context.pushNamed(AppRoutes.pantryName),
        ),
      ],
    );
  }
}

class _FilterStamp extends StatelessWidget {
  const _FilterStamp({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = active ? AppColors.creamRaised : AppColors.forest;

    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: Material(
        color: active ? AppColors.forest : AppColors.creamRaised,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: active ? AppColors.forest : AppColors.line,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: foreground),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: foreground,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: active ? AppColors.creamRaised.withValues(alpha: 0.8) : AppColors.charcoalMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PantryCallout extends StatelessWidget {
  const _PantryCallout({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Material(
      color: AppColors.sageMist.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        key: const Key('discovery-pantry'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.forest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.kitchen_rounded,
                  size: 20,
                  color: AppColors.creamRaised,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.discovery.pantry.eyebrow,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.forest,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.discovery.pantry.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        color: AppColors.forest,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      t.discovery.pantry.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: AppColors.forest.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: AppColors.forest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetChoice<T> {
  const _SheetChoice(this.value);

  final T? value;
}

class _OptionSheet<T> extends StatelessWidget {
  const _OptionSheet({
    required this.title,
    required this.anyLabel,
    required this.options,
    required this.selected,
  });

  final String title;
  final String anyLabel;
  final List<({T value, String label})> options;
  final T? selected;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 2, 24, 10),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                _OptionRow(
                  label: anyLabel,
                  selected: selected == null,
                  onTap: () => Navigator.pop(context, _SheetChoice<T>(null)),
                ),
                for (final option in options)
                  _OptionRow(
                    label: option.label,
                    selected: selected == option.value,
                    onTap: () => Navigator.pop(
                      context,
                      _SheetChoice<T>(option.value),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 1),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15.5,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.forest : AppColors.charcoal,
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check_rounded,
              size: 20,
              color: AppColors.forest,
            )
          : null,
    );
  }
}

class _FeedLoading extends StatelessWidget {
  const _FeedLoading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.square(
            dimension: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.forest,
            ),
          ),
          const SizedBox(height: 14),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _FeedError extends StatelessWidget {
  const _FeedError({
    required this.title,
    required this.detail,
    required this.onRetry,
  });

  final String title;
  final String detail;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.creamRaised,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 24,
                color: AppColors.spice,
              ),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(detail, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 14),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(t.common.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedEmpty extends StatelessWidget {
  const _FeedEmpty({
    required this.hasFilters,
    required this.onClearFilters,
    required this.onWriteRecipe,
  });

  final bool hasFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onWriteRecipe;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
          decoration: BoxDecoration(
            color: AppColors.sageMist.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasFilters ? Icons.filter_alt_off_rounded : Icons.restaurant_rounded,
                size: 26,
                color: AppColors.forest,
              ),
              const SizedBox(height: 14),
              Text(
                hasFilters ? t.discovery.feed.emptyTitle : t.discovery.feed.emptyCommunityTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  color: AppColors.forest,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hasFilters ? t.discovery.feed.emptyBody : t.discovery.feed.emptyCommunityBody,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.forest.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 18),
              if (hasFilters)
                FilledButton.tonalIcon(
                  key: const Key('discovery-empty-clear'),
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: Text(t.discovery.filters.clearAll),
                )
              else
                FilledButton.tonalIcon(
                  key: const Key('discovery-empty-write'),
                  onPressed: onWriteRecipe,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(t.recipes.library.newRecipe),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedFooter extends StatelessWidget {
  const _FeedFooter({
    required this.loading,
    required this.error,
    required this.onRetry,
  });

  final bool loading;
  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (!loading && error == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
      child: Center(
        child: loading
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.forest,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: onRetry,
                    child: Text(Translations.of(context).common.tryAgain),
                  ),
                ],
              ),
      ),
    );
  }
}
