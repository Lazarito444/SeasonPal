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
import 'package:seasonpal/features/discovery/domain/discovery_models.dart';
import 'package:seasonpal/features/discovery/presentation/pantry_controller.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_labels.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// "What can I cook with what I have": add shelf ingredients, then read public
/// recipes ranked by how much of each one the pantry already covers.
class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final ingredients = ref.watch(pantryIngredientsProvider);
    final results = ref.watch(pantryResultsProvider);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: RefreshIndicator(
                  color: AppColors.forest,
                  onRefresh: ingredients.isEmpty ? () async {} : () => ref.read(pantryResultsProvider.notifier).refresh(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                        sliver: SliverToBoxAdapter(
                          child: _Header(
                            controller: _controller,
                            focusNode: _focusNode,
                            ingredients: ingredients,
                            onAdd: _add,
                            onRemove: (term) => ref.read(pantryIngredientsProvider.notifier).remove(term),
                            onClear: () => ref.read(pantryIngredientsProvider.notifier).clear(),
                          ),
                        ),
                      ),
                      if (ingredients.isEmpty)
                        SliverToBoxAdapter(
                          child: _PantryPrompt(
                            title: t.discovery.pantry.emptyPromptTitle,
                            body: t.discovery.pantry.emptyPromptBody,
                          ),
                        )
                      else
                        ...results.when(
                          loading: () => [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 40, 0, 32),
                                child: _PantryLoading(
                                  label: t.discovery.pantry.loading,
                                ),
                              ),
                            ),
                          ],
                          error: (error, stackTrace) => [
                            SliverToBoxAdapter(
                              child: _PantryError(
                                title: t.discovery.pantry.loadError,
                                detail: _errorDetail(t, error),
                                onRetry: () => ref.invalidate(pantryResultsProvider),
                              ),
                            ),
                          ],
                          data: (page) => _resultSlivers(context, t, page),
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

  List<Widget> _resultSlivers(
    BuildContext context,
    Translations t,
    PantryResultsPage? page,
  ) {
    if (page == null || page.items.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: _PantryPrompt(
            title: t.discovery.pantry.emptyTitle,
            body: t.discovery.pantry.emptyBody,
            icon: Icons.search_off_rounded,
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        sliver: SliverToBoxAdapter(
          child: Text(
            page.totalCount == 1 ? t.discovery.pantry.resultsOne : t.discovery.pantry.results(count: page.totalCount),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.charcoalMuted,
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        sliver: SliverList.separated(
          itemCount: page.items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final match = page.items[index];
            return _PantryMatchCard(
              key: Key('pantry-match-${match.recipe.id}'),
              match: match,
              onTap: () => context.pushNamed(
                AppRoutes.recipeDetailName,
                pathParameters: {'id': match.recipe.id},
              ),
            );
          },
        ),
      ),
      SliverToBoxAdapter(
        child: _PantryFooter(
          page: page,
          onLoadMore: () => ref.read(pantryResultsProvider.notifier).loadMore(),
          loadMoreError: t.discovery.pantry.loadMoreError,
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 28)),
    ];
  }

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }

    ref.read(pantryIngredientsProvider.notifier).add(value);
    _controller.clear();
    _focusNode.requestFocus();
  }

  String _errorDetail(Translations t, Object error) {
    if (error is ApiException) {
      return localizeApiError(t, error);
    }

    return t.discovery.pantry.loadError;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.controller,
    required this.focusNode,
    required this.ingredients,
    required this.onAdd,
    required this.onRemove,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> ingredients;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              key: const Key('pantry-back'),
              onPressed: () => context.canPop() ? context.pop() : context.goNamed(AppRoutes.homeName),
              tooltip: t.common.back,
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
            const SizedBox(width: 2),
            Text(
              t.discovery.pantry.eyebrow,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          t.discovery.pantry.title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          t.discovery.pantry.subtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                key: const Key('pantry-input'),
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onAdd(),
                decoration: InputDecoration(
                  hintText: t.discovery.pantry.inputHint,
                  prefixIcon: const Icon(Icons.kitchen_rounded, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 54,
              child: FilledButton(
                key: const Key('pantry-add'),
                onPressed: onAdd,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 54),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
                child: Text(t.discovery.pantry.add),
              ),
            ),
          ],
        ),
        if (ingredients.isNotEmpty) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final term in ingredients)
                _PantryChip(
                  key: Key('pantry-chip-$term'),
                  label: term,
                  removeLabel: t.discovery.pantry.remove(name: term),
                  onRemove: () => onRemove(term),
                ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: const Key('pantry-clear'),
              onPressed: onClear,
              child: Text(t.discovery.pantry.clear),
            ),
          ),
        ],
        const SizedBox(height: 4),
      ],
    );
  }
}

class _PantryChip extends StatelessWidget {
  const _PantryChip({
    required this.label,
    required this.removeLabel,
    required this.onRemove,
    super.key,
  });

  final String label;
  final String removeLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 7, 5, 7),
      decoration: BoxDecoration(
        color: AppColors.sageMist,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: AppColors.forest,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 3),
          Semantics(
            button: true,
            label: removeLabel,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(999),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 15,
                  color: AppColors.forest,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PantryMatchCard extends ConsumerWidget {
  const _PantryMatchCard({
    required this.match,
    required this.onTap,
    super.key,
  });

  final PantryMatch match;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final resolveUrl = ref.watch(mediaUrlResolverProvider);
    final cover = match.recipe.coverImageUrl == null ? null : resolveUrl(match.recipe.coverImageUrl!);
    final total = totalMinutesOf(
      total: match.recipe.totalTimeMinutes,
      prep: match.recipe.prepTimeMinutes,
      cook: match.recipe.cookTimeMinutes,
    );

    return Semantics(
      button: true,
      label: match.recipe.title,
      child: Material(
        color: AppColors.creamRaised,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.line),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 92,
                    height: 104,
                    child: RemotePhoto(
                      url: cover,
                      semanticLabel: match.recipe.title,
                      iconSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              match.recipe.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 17,
                                height: 1.22,
                              ),
                            ),
                          ),
                          if (match.canCook) ...[
                            const SizedBox(width: 8),
                            _CanCookBadge(label: t.discovery.pantry.canCook),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              t.discovery.pantry.match(
                                percent: match.matchPercent,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.spice,
                              ),
                            ),
                          ),
                          if (total != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              minutesLabel(t, total),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 7),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: (match.matchPercent / 100).clamp(0, 1),
                          minHeight: 6,
                          backgroundColor: AppColors.sageMist,
                          color: AppColors.forest,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (match.missingIngredients.isEmpty)
                        Text(
                          t.discovery.pantry.allIngredients,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.5,
                            color: AppColors.forest,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else ...[
                        if (match.matchedIngredients.isNotEmpty)
                          Text(
                            t.discovery.pantry.have(
                              names: _namesLabel(match.matchedIngredients),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          t.discovery.pantry.missing(
                            names: _namesLabel(match.missingIngredients),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.5,
                            color: AppColors.spice,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CanCookBadge extends StatelessWidget {
  const _CanCookBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.sageMist,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: AppColors.forest,
        ),
      ),
    );
  }
}

class _PantryFooter extends StatelessWidget {
  const _PantryFooter({
    required this.page,
    required this.onLoadMore,
    required this.loadMoreError,
  });

  final PantryResultsPage page;
  final VoidCallback onLoadMore;
  final String loadMoreError;

  @override
  Widget build(BuildContext context) {
    if (!page.hasNextPage && page.loadMoreError == null) {
      return const SizedBox(height: 8);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Center(
        child: page.loadingMore
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.forest,
                ),
              )
            : page.loadMoreError != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loadMoreError,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.5,
                    ),
                  ),
                  TextButton(
                    onPressed: onLoadMore,
                    child: Text(Translations.of(context).common.tryAgain),
                  ),
                ],
              )
            : FilledButton.tonal(
                key: const Key('pantry-load-more'),
                onPressed: onLoadMore,
                child: Text(Translations.of(context).discovery.pantry.loadMore),
              ),
      ),
    );
  }
}

class _PantryPrompt extends StatelessWidget {
  const _PantryPrompt({
    required this.title,
    required this.body,
    this.icon = Icons.kitchen_rounded,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
              Icon(icon, size: 26, color: AppColors.forest),
              const SizedBox(height: 14),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  color: AppColors.forest,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.forest.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PantryLoading extends StatelessWidget {
  const _PantryLoading({required this.label});

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

class _PantryError extends StatelessWidget {
  const _PantryError({
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
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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

String _namesLabel(List<String> names) {
  if (names.length <= 3) {
    return names.join(', ');
  }

  return '${names.take(3).join(', ')} +${names.length - 3}';
}
