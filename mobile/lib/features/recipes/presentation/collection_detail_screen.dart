import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/media/media_urls.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/core/widgets/remote_photo.dart';
import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/collection_controller.dart';
import 'package:seasonpal/features/recipes/presentation/library_controller.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_labels.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_providers.dart';
import 'package:seasonpal/features/recipes/presentation/widgets/collection_dialogs.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// One collection in display order, with removal that respects the favorites
/// rule (removing from favorites unsaves the recipe everywhere).
class CollectionDetailScreen extends ConsumerWidget {
  const CollectionDetailScreen({required this.collectionId, super.key});

  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final async = ref.watch(collectionViewProvider(collectionId));

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: async.when(
                  loading: () => const Center(
                    child: SizedBox.square(
                      dimension: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.forest,
                      ),
                    ),
                  ),
                  error: (error, stackTrace) => _CollectionLoadError(
                    title: t.recipes.collections.loadError,
                    onBack: () => context.pop(),
                    onRetry: () => ref.invalidate(collectionViewProvider(collectionId)),
                  ),
                  data: (view) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                        child: Row(
                          children: [
                            IconButton(
                              key: const Key('collection-detail-back'),
                              onPressed: () => context.pop(),
                              tooltip: t.common.back,
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                size: 21,
                              ),
                            ),
                            const Spacer(),
                            if (!view.isDefaultFavorites)
                              PopupMenuButton<String>(
                                key: const Key('collection-detail-menu'),
                                tooltip: t.recipes.collections.delete,
                                icon: const Icon(
                                  Icons.more_horiz_rounded,
                                  size: 22,
                                ),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _deleteCollection(context, ref, view);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text(t.recipes.collections.delete),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              view.isDefaultFavorites ? t.recipes.collections.favorites : view.name,
                              style: Theme.of(
                                context,
                              ).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              view.description?.trim().isNotEmpty ?? false
                                  ? view.description!
                                  : view.recipeCount == 1
                                  ? t.recipes.collections.countOne
                                  : t.recipes.collections.count(
                                      count: view.recipeCount,
                                    ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: view.items.isEmpty
                            ? ListView(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  8,
                                  20,
                                  24,
                                ),
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(22),
                                    decoration: BoxDecoration(
                                      color: AppColors.sageMist.withValues(
                                        alpha: 0.55,
                                      ),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          t.recipes.collections.emptyCollection,
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontSize: 20,
                                            color: AppColors.forest,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          t.recipes.collections.emptyCollectionBody,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.forest.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification.metrics.axis == Axis.vertical && notification.metrics.extentAfter < 360) {
                                    ref
                                        .read(
                                          collectionViewProvider(
                                            collectionId,
                                          ).notifier,
                                        )
                                        .loadMore();
                                  }

                                  return false;
                                },
                                child: RefreshIndicator(
                                  color: AppColors.forest,
                                  onRefresh: () => ref
                                      .read(
                                        collectionViewProvider(
                                          collectionId,
                                        ).notifier,
                                      )
                                      .refresh(),
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      8,
                                      20,
                                      28,
                                    ),
                                    itemCount: view.items.length + (view.loadingMore ? 1 : 0),
                                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      if (index >= view.items.length) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          child: Center(
                                            child: SizedBox.square(
                                              dimension: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.forest,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final recipe = view.items[index];
                                      return _RecipeRow(
                                        recipe: recipe,
                                        onTap: () => _openRecipe(
                                          context,
                                          ref,
                                          recipe.id,
                                        ),
                                        onRemove: () => _removeRecipe(
                                          context,
                                          ref,
                                          view,
                                          recipe,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ),
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

  Future<void> _openRecipe(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    await context.pushNamed(
      AppRoutes.recipeDetailName,
      pathParameters: {'id': id},
    );
    if (context.mounted) {
      ref.invalidate(collectionViewProvider(collectionId));
      ref.invalidate(libraryControllerProvider);
    }
  }

  Future<void> _removeRecipe(
    BuildContext context,
    WidgetRef ref,
    CollectionView view,
    RecipeSummary recipe,
  ) async {
    final t = Translations.of(context);

    if (view.isDefaultFavorites) {
      final confirmed = await confirmCollectionAction(
        context,
        title: t.recipes.collections.removeTitle,
        body: t.recipes.collections.removeBody,
        confirm: t.recipes.collections.remove,
      );
      if (!confirmed || !context.mounted) {
        return;
      }
    }

    try {
      await ref.read(recipeRepositoryProvider).removeFromCollection(view.id, recipe.id);
      ref.read(collectionViewProvider(collectionId).notifier).removeLocally(recipe.id);
      ref.invalidate(libraryControllerProvider);
      ref.invalidate(collectionsProvider);
    } on ApiException catch (error) {
      if (context.mounted) {
        _showMessage(context, localizeApiError(t, error));
      }
    } on Object {
      if (context.mounted) {
        _showMessage(context, t.recipes.collections.removeError);
      }
    }
  }

  Future<void> _deleteCollection(
    BuildContext context,
    WidgetRef ref,
    CollectionView view,
  ) async {
    final t = Translations.of(context);
    final confirmed = await confirmCollectionAction(
      context,
      title: t.recipes.collections.deleteTitle,
      body: t.recipes.collections.deleteBody,
      confirm: t.common.delete,
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await ref.read(recipeRepositoryProvider).deleteCollection(view.id);
      ref.invalidate(collectionsProvider);
      ref.invalidate(libraryControllerProvider);
      if (context.mounted) {
        context.pop();
      }
    } on ApiException catch (error) {
      if (context.mounted) {
        _showMessage(context, localizeApiError(t, error));
      }
    } on Object {
      if (context.mounted) {
        _showMessage(context, t.recipes.collections.deleteError);
      }
    }
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _RecipeRow extends ConsumerWidget {
  const _RecipeRow({
    required this.recipe,
    required this.onTap,
    required this.onRemove,
  });

  final RecipeSummary recipe;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final resolveUrl = ref.watch(mediaUrlResolverProvider);
    final total = totalMinutesOf(
      total: recipe.totalTimeMinutes,
      prep: recipe.prepTimeMinutes,
      cook: recipe.cookTimeMinutes,
    );

    return Material(
      color: AppColors.creamRaised,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: RemotePhoto(
                    url: recipe.coverImageUrl == null ? null : resolveUrl(recipe.coverImageUrl!),
                    iconSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (total != null) minutesLabel(t, total),
                        servingsLabel(t, recipe.servings),
                      ].join(' · '),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: Key('collection-remove-${recipe.id}'),
                onPressed: onRemove,
                tooltip: t.recipes.collections.remove,
                icon: const Icon(
                  Icons.remove_circle_outline_rounded,
                  size: 20,
                  color: AppColors.charcoalMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionLoadError extends StatelessWidget {
  const _CollectionLoadError({
    required this.title,
    required this.onBack,
    required this.onRetry,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBack,
            tooltip: t.common.back,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onRetry,
            child: Text(t.common.tryAgain),
          ),
        ],
      ),
    );
  }
}
