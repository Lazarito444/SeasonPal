import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/library_controller.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_providers.dart';
import 'package:seasonpal/features/recipes/presentation/widgets/collection_dialogs.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// The named bundles behind the saved library. Favorites are the implicit
/// collection and are always shown first.
class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final collections = ref.watch(collectionsProvider);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                      child: Row(
                        children: [
                          IconButton(
                            key: const Key('collections-back'),
                            onPressed: () => context.pop(),
                            tooltip: t.common.back,
                            icon: const Icon(Icons.arrow_back_rounded, size: 21),
                          ),
                          const Spacer(),
                          Text(
                            t.recipes.collections.eyebrow,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.spice),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.recipes.collections.title,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.recipes.collections.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 18),
                          FilledButton.icon(
                            key: const Key('collections-new'),
                            onPressed: () => showCreateCollectionDialog(context),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            icon: const Icon(Icons.add_rounded, size: 20),
                            label: Text(t.recipes.collections.newCollection),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: collections.when(
                        loading: () => const Center(
                          child: SizedBox.square(
                            dimension: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.forest,
                            ),
                          ),
                        ),
                        error: (error, stackTrace) => ListView(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          children: [
                            _CollectionsError(
                              title: t.recipes.collections.loadError,
                              onRetry: () => ref.invalidate(collectionsProvider),
                            ),
                          ],
                        ),
                        data: (page) {
                          final items = [...page.items]
                            ..sort((a, b) {
                              if (a.isDefaultFavorites == b.isDefaultFavorites) {
                                return 0;
                              }
                              return a.isDefaultFavorites ? -1 : 1;
                            });

                          if (items.isEmpty) {
                            return ListView(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                8,
                                20,
                                24,
                              ),
                              children: [
                                _EmptyCollections(
                                  onCreate: () => showCreateCollectionDialog(context),
                                ),
                              ],
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              20,
                              8,
                              20,
                              28,
                            ),
                            itemCount: items.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) => _CollectionRow(
                              collection: items[index],
                              onTap: () async {
                                await context.pushNamed(
                                  AppRoutes.collectionDetailName,
                                  pathParameters: {'id': items[index].id},
                                );
                                if (context.mounted) {
                                  ref.invalidate(collectionsProvider);
                                  ref.invalidate(libraryControllerProvider);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionRow extends ConsumerWidget {
  const _CollectionRow({required this.collection, required this.onTap});

  final CollectionSummary collection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final count = collection.recipeCount == 1 ? t.recipes.collections.countOne : t.recipes.collections.count(count: collection.recipeCount);

    return Material(
      color: AppColors.creamRaised,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('collection-row-${collection.id}'),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: collection.isDefaultFavorites ? AppColors.spice.withValues(alpha: 0.12) : AppColors.sageMist,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  collection.isDefaultFavorites ? Icons.favorite_rounded : Icons.collections_bookmark_rounded,
                  size: 22,
                  color: collection.isDefaultFavorites ? AppColors.spice : AppColors.forest,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.isDefaultFavorites ? t.recipes.collections.favorites : collection.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      count,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.charcoalMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCollections extends StatelessWidget {
  const _EmptyCollections({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.sageMist.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.collections_bookmark_rounded,
            size: 26,
            color: AppColors.forest,
          ),
          const SizedBox(height: 14),
          Text(
            t.recipes.collections.emptyTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20,
              color: AppColors.forest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t.recipes.collections.emptyBody,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.forest.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: onCreate,
            child: Text(t.recipes.collections.newCollection),
          ),
        ],
      ),
    );
  }
}

class _CollectionsError extends StatelessWidget {
  const _CollectionsError({required this.title, required this.onRetry});

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
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
    );
  }
}
