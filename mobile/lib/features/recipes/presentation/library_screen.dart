import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/core/widgets/brand_mark.dart';
import 'package:seasonpal/features/recipes/presentation/library_controller.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_providers.dart';
import 'package:seasonpal/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// The personal library: recipes the cook wrote and recipes they saved, each
/// paginated independently and refreshed without losing the other tab.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            const AppBackdrop(),
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const BrandMark(size: 34),
                            const SizedBox(width: 10),
                            Text(
                              t.recipes.library.eyebrow,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.spice),
                            ),
                            const Spacer(),
                            IconButton(
                              key: const Key('library-collections'),
                              onPressed: () async {
                                await context.pushNamed(
                                  AppRoutes.collectionsName,
                                );
                                if (context.mounted) {
                                  ref.invalidate(collectionsProvider);
                                  ref.invalidate(libraryControllerProvider);
                                }
                              },
                              tooltip: t.recipes.library.collections,
                              icon: const Icon(
                                Icons.collections_bookmark_outlined,
                                size: 21,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.recipes.library.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.recipes.library.subtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          key: const Key('library-new'),
                          onPressed: () => _openEditor(context, ref),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: Text(t.recipes.library.newRecipe),
                        ),
                        const SizedBox(height: 10),
                        TabBar(
                          labelColor: AppColors.forest,
                          unselectedLabelColor: AppColors.charcoalMuted,
                          indicatorColor: AppColors.forest,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: AppColors.line,
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: [
                            Tab(
                              key: const Key('library-tab-own'),
                              text: t.recipes.library.mine,
                            ),
                            Tab(
                              key: const Key('library-tab-saved'),
                              text: t.recipes.library.saved,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        _LibraryTabView(tab: LibraryTab.own),
                        _LibraryTabView(tab: LibraryTab.saved),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, WidgetRef ref) async {
    await context.pushNamed(AppRoutes.recipeNewName);
    if (context.mounted) {
      ref.invalidate(libraryControllerProvider);
      ref.invalidate(collectionsProvider);
    }
  }
}

class _LibraryTabView extends ConsumerWidget {
  const _LibraryTabView({required this.tab});
  final LibraryTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final async = ref.watch(libraryControllerProvider(tab));

    return async.when(
      loading: () => _LibraryLoading(label: t.recipes.library.loading),
      error: (error, stackTrace) => _LibraryError(
        title: t.recipes.library.loadError,
        onRetry: () => ref.invalidate(libraryControllerProvider(tab)),
      ),
      data: (page) {
        if (page.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => ref.read(libraryControllerProvider(tab).notifier).refresh(),
            color: AppColors.forest,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              children: [
                _EmptyLibrary(tab: tab),
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical && notification.metrics.extentAfter < 420) {
              ref.read(libraryControllerProvider(tab).notifier).loadMore();
            }

            return false;
          },
          child: RefreshIndicator(
            onRefresh: () => ref.read(libraryControllerProvider(tab).notifier).refresh(),
            color: AppColors.forest,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisExtent: 286,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: page.items.length + (page.loadingMore || page.loadMoreError != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= page.items.length) {
                  return _GridFooter(
                    error: page.loadMoreError != null ? t.recipes.library.loadMoreError : null,
                    onRetry: () => ref.read(libraryControllerProvider(tab).notifier).loadMore(),
                  );
                }

                final recipe = page.items[index];
                return RecipeCard(
                  key: Key('recipe-card-${recipe.id}'),
                  recipe: recipe,
                  onTap: () => _openDetail(context, ref, recipe.id),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _openDetail(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    await context.pushNamed(
      AppRoutes.recipeDetailName,
      pathParameters: {'id': id},
    );
    if (context.mounted) {
      ref.invalidate(libraryControllerProvider);
      ref.invalidate(collectionsProvider);
    }
  }
}

class _GridFooter extends StatelessWidget {
  const _GridFooter({required this.error, required this.onRetry});

  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.creamRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Center(
        child: error == null
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.forest,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}

class _LibraryLoading extends StatelessWidget {
  const _LibraryLoading({required this.label});

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

class _LibraryError extends StatelessWidget {
  const _LibraryError({required this.title, required this.onRetry});

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      children: [
        Container(
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
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(t.common.tryAgain),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyLibrary extends ConsumerWidget {
  const _EmptyLibrary({required this.tab});

  final LibraryTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final own = tab == LibraryTab.own;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        color: AppColors.sageMist.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            own ? Icons.menu_book_rounded : Icons.bookmark_border_rounded,
            size: 26,
            color: AppColors.forest,
          ),
          const SizedBox(height: 14),
          Text(
            own ? t.recipes.library.emptyOwnTitle : t.recipes.library.emptySavedTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20,
              color: AppColors.forest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            own ? t.recipes.library.emptyOwnBody : t.recipes.library.emptySavedBody,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.forest.withValues(alpha: 0.8),
            ),
          ),
          if (own) ...[
            const SizedBox(height: 18),
            FilledButton.tonalIcon(
              key: const Key('library-empty-new'),
              onPressed: () async {
                await context.pushNamed(AppRoutes.recipeNewName);
                if (context.mounted) {
                  ref.invalidate(libraryControllerProvider);
                }
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(t.recipes.library.newRecipe),
            ),
          ],
        ],
      ),
    );
  }
}
