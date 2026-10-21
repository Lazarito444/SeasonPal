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
import 'package:seasonpal/features/auth/presentation/auth_controller.dart';
import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/collection_controller.dart';
import 'package:seasonpal/features/recipes/presentation/library_controller.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_labels.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_providers.dart';
import 'package:seasonpal/features/recipes/presentation/widgets/collection_dialogs.dart';
import 'package:seasonpal/features/recipes/presentation/widgets/save_to_collection_sheet.dart';
import 'package:seasonpal/i18n/strings.g.dart';

enum _DetailAction { edit, publish, unpublish, delete }

/// The recipe as a cook reads it: photograph, the facts before starting, then
/// ingredients and method. Owners also get edit, publication and delete.
class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({required this.recipeId, super.key});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final async = ref.watch(recipeDetailProvider(recipeId));

    return async.when(
      loading: () => const _DetailFrame(
        child: Center(
          child: SizedBox.square(
            dimension: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.forest,
            ),
          ),
        ),
      ),
      error: (error, stackTrace) {
        final notFound = error is ApiException && error.statusCode == 404;
        return _DetailFrame(
          child: _DetailError(
            title: notFound ? t.recipes.detail.notFoundTitle : t.recipes.detail.loadError,
            body: notFound ? t.recipes.detail.notFoundBody : null,
            onBack: () => context.pop(),
            onRetry: notFound ? null : () => ref.invalidate(recipeDetailProvider(recipeId)),
          ),
        );
      },
      data: (recipe) {
        final userId = ref.watch(authControllerProvider).value?.user.id;
        final isOwner = userId == recipe.author.id;

        return Scaffold(
          bottomNavigationBar: _SaveBar(
            recipe: recipe,
            onPressed: () => _openSaveSheet(context, ref, recipe),
          ),
          body: Stack(
            children: [
              const AppBackdrop(),
              CustomScrollView(
                slivers: [
                  _DetailHero(
                    recipe: recipe,
                    isOwner: isOwner,
                    onBack: () => context.pop(),
                    onAction: (action) => _runAction(context, ref, recipe, action),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 36),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _TitleBlock(recipe: recipe),
                        const SizedBox(height: 18),
                        _MetaRow(recipe: recipe),
                        if (recipe.description?.trim().isNotEmpty ?? false) ...[
                          const SizedBox(height: 18),
                          Text(
                            recipe.description!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                        if (recipe.isAiGenerated) ...[
                          const SizedBox(height: 18),
                          const _AiNote(),
                        ],
                        const SizedBox(height: 28),
                        _Section(
                          title: t.recipes.detail.ingredients,
                          child: recipe.ingredients.isEmpty
                              ? _QuietBody(
                                  text: t.recipes.detail.noIngredients,
                                )
                              : _Ingredients(
                                  ingredients: recipe.ingredients,
                                ),
                        ),
                        const SizedBox(height: 28),
                        _Section(
                          title: t.recipes.detail.method,
                          child: recipe.steps.isEmpty ? _QuietBody(text: t.recipes.detail.noSteps) : _Steps(steps: recipe.steps),
                        ),
                        if (recipe.media.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          _Section(
                            title: t.recipes.detail.media,
                            child: _MediaStrip(media: recipe.media),
                          ),
                        ],
                        if (recipe.tags.isNotEmpty || recipe.dietaryTags.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          _Section(
                            title: t.recipes.detail.tags,
                            child: _TagWrap(recipe: recipe),
                          ),
                        ],
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openSaveSheet(
    BuildContext context,
    WidgetRef ref,
    RecipeDetail recipe,
  ) async {
    final t = Translations.of(context);
    final result = await showSaveToCollectionSheet(
      context,
      recipeId: recipe.id,
      isSaved: recipe.isSaved,
    );
    if (result == null) {
      return;
    }

    ref.invalidate(recipeDetailProvider(recipe.id));
    ref.invalidate(libraryControllerProvider);
    ref.invalidate(collectionsProvider);
    ref.invalidate(collectionViewProvider);

    if (context.mounted) {
      _showMessage(
        context,
        result == SaveSheetResult.saved ? t.recipes.detail.savedMessage : t.recipes.detail.unsavedMessage,
      );
    }
  }

  Future<void> _runAction(
    BuildContext context,
    WidgetRef ref,
    RecipeDetail recipe,
    _DetailAction action,
  ) async {
    final t = Translations.of(context);
    final repository = ref.read(recipeRepositoryProvider);

    switch (action) {
      case _DetailAction.edit:
        await context.pushNamed(
          AppRoutes.recipeEditName,
          pathParameters: {'id': recipe.id},
        );
        if (context.mounted) {
          ref.invalidate(recipeDetailProvider(recipe.id));
          ref.invalidate(libraryControllerProvider);
          ref.invalidate(collectionsProvider);
        }
        return;
      case _DetailAction.delete:
        final confirmed = await confirmCollectionAction(
          context,
          title: t.recipes.detail.deleteTitle,
          body: t.recipes.detail.deleteBody,
          confirm: t.common.delete,
        );
        if (!confirmed || !context.mounted) {
          return;
        }

        try {
          await repository.delete(recipe.id);
          ref.invalidate(libraryControllerProvider);
          ref.invalidate(collectionsProvider);
          ref.invalidate(collectionViewProvider);
          if (context.mounted) {
            context.pop();
          }
        } on ApiException catch (error) {
          if (context.mounted) {
            _showMessage(context, localizeApiError(t, error));
          }
        } on Object {
          if (context.mounted) {
            _showMessage(context, t.recipes.detail.actionError);
          }
        }
        return;
      case _DetailAction.publish:
      case _DetailAction.unpublish:
        try {
          if (action == _DetailAction.publish) {
            await repository.publish(recipe.id);
          } else {
            await repository.unpublish(recipe.id);
          }
          ref.invalidate(recipeDetailProvider(recipe.id));
          ref.invalidate(libraryControllerProvider);
          if (context.mounted) {
            _showMessage(
              context,
              action == _DetailAction.publish ? t.recipes.detail.published : t.recipes.detail.unpublished,
            );
          }
        } on ApiException catch (error) {
          if (context.mounted) {
            _showMessage(context, localizeApiError(t, error));
          }
        } on Object {
          if (context.mounted) {
            _showMessage(context, t.recipes.detail.actionError);
          }
        }
    }
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DetailFrame extends StatelessWidget {
  const _DetailFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({
    required this.title,
    required this.onBack,
    this.body,
    this.onRetry,
  });

  final String title;
  final String? body;
  final VoidCallback onBack;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              if (body != null) ...[
                const SizedBox(height: 10),
                Text(body!, style: Theme.of(context).textTheme.bodyLarge),
              ],
              const SizedBox(height: 22),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: Text(t.common.back),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: onRetry,
                      child: Text(t.common.tryAgain),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailHero extends ConsumerWidget {
  const _DetailHero({
    required this.recipe,
    required this.isOwner,
    required this.onBack,
    required this.onAction,
  });

  final RecipeDetail recipe;
  final bool isOwner;
  final VoidCallback onBack;
  final ValueChanged<_DetailAction> onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final resolveUrl = ref.watch(mediaUrlResolverProvider);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.creamRaised,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0.5,
      automaticallyImplyLeading: false,
      leadingWidth: 68,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: _CircleButton(
          key: const Key('recipe-detail-back'),
          icon: Icons.arrow_back_rounded,
          tooltip: t.common.back,
          onPressed: onBack,
        ),
      ),
      actions: [
        if (isOwner)
          _CircleMenu(
            recipe: recipe,
            onAction: onAction,
          ),
        const SizedBox(width: 14),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: RemotePhoto(
          url: recipe.coverImageUrl == null ? null : resolveUrl(recipe.coverImageUrl!),
          semanticLabel: recipe.title,
          iconSize: 44,
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.creamRaised.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: onPressed,
          tooltip: tooltip,
          icon: Icon(icon, size: 20, color: AppColors.forest),
        ),
      ),
    );
  }
}

class _CircleMenu extends StatelessWidget {
  const _CircleMenu({required this.recipe, required this.onAction});

  final RecipeDetail recipe;
  final ValueChanged<_DetailAction> onAction;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final published = recipe.visibility == RecipeVisibility.public && recipe.status == RecipeStatus.published;

    return Center(
      child: Material(
        color: AppColors.creamRaised.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        child: PopupMenuButton<_DetailAction>(
          key: const Key('recipe-detail-menu'),
          tooltip: t.recipes.detail.more,
          icon: const Icon(
            Icons.more_horiz_rounded,
            size: 21,
            color: AppColors.forest,
          ),
          onSelected: onAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _DetailAction.edit,
              child: Text(t.recipes.detail.edit),
            ),
            PopupMenuItem(
              value: published ? _DetailAction.unpublish : _DetailAction.publish,
              child: Text(
                published ? t.recipes.detail.unpublish : t.recipes.detail.publish,
              ),
            ),
            PopupMenuItem(
              value: _DetailAction.delete,
              child: Text(t.recipes.detail.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.recipe});

  final RecipeDetail recipe;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final published = recipe.visibility == RecipeVisibility.public && recipe.status == RecipeStatus.published;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (recipe.status == RecipeStatus.draft)
              _Label(
                text: t.recipes.library.draft,
                background: AppColors.sageMist,
                foreground: AppColors.forest,
              ),
            if (recipe.status == RecipeStatus.draft && recipe.isAiGenerated) const SizedBox(width: 6),
            if (recipe.isAiGenerated)
              _Label(
                text: t.recipes.library.ai,
                background: AppColors.spice,
                foreground: AppColors.creamRaised,
              ),
            const Spacer(),
            if (published)
              _Label(
                text: t.recipes.detail.publishedBadge,
                background: AppColors.sageMist,
                foreground: AppColors.forest,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(recipe.title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          t.recipes.detail.by(name: recipe.author.displayName),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.text,
    required this.background,
    required this.foreground,
  });

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: foreground,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.recipe});

  final RecipeDetail recipe;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final total = totalMinutesOf(
      total: recipe.totalTimeMinutes,
      prep: recipe.prepTimeMinutes,
      cook: recipe.cookTimeMinutes,
    );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (total != null) _MetaChip(icon: Icons.schedule_rounded, label: minutesLabel(t, total)),
        _MetaChip(
          icon: Icons.people_outline_rounded,
          label: servingsLabel(t, recipe.servings),
        ),
        _MetaChip(
          icon: Icons.signal_cellular_alt_rounded,
          label: difficultyLabel(t, recipe.difficulty),
        ),
        if (recipe.cuisine?.trim().isNotEmpty ?? false)
          _MetaChip(
            icon: Icons.public_rounded,
            label: recipe.cuisine!,
          ),
        if (recipe.mealType != MealType.unspecified)
          _MetaChip(
            icon: Icons.restaurant_outlined,
            label: mealTypeLabel(t, recipe.mealType),
          ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.creamRaised,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.forest),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiNote extends StatelessWidget {
  const _AiNote();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.spice.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.spice.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 18,
            color: AppColors.spice,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              t.recipes.detail.aiNote,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13.5,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 18,
              height: 2,
              color: AppColors.spice,
            ),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.charcoalMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _Ingredients extends StatelessWidget {
  const _Ingredients({required this.ingredients});

  final List<RecipeIngredient> ingredients;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.creamRaised,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          for (var index = 0; index < ingredients.length; index++) ...[
            if (index > 0) const Divider(height: 1, color: AppColors.line),
            _IngredientRow(ingredient: ingredients[index]),
          ],
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient});

  final RecipeIngredient ingredient;

  @override
  Widget build(BuildContext context) {
    final quantity = _formatQuantity(ingredient.quantity);
    final unit = ingredient.unit?.trim();
    final amount = [
      ?quantity,
      if (unit != null && unit.isNotEmpty) unit,
    ].join(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(
              amount,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13.5,
                color: AppColors.forest,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: AppColors.charcoal,
                  ),
                ),
                if (ingredient.note?.trim().isNotEmpty ?? false) ...[
                  const SizedBox(height: 2),
                  Text(
                    ingredient.note!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps({required this.steps});

  final List<RecipeStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          Padding(
            padding: EdgeInsets.only(bottom: index == steps.length - 1 ? 0 : 18),
            child: _StepRow(step: steps[index], number: index + 1),
          ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.number});

  final RecipeStep step;
  final int number;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.forest,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.creamRaised,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.instruction,
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.5,
                  color: AppColors.charcoal,
                ),
              ),
              if (step.timerSeconds != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: AppColors.spice,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      durationLabel(t, step.timerSeconds!),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.spice,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (step.tip?.trim().isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.sageMist.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 15,
                        color: AppColors.forest,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step.tip!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.5,
                            color: AppColors.forest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MediaStrip extends ConsumerWidget {
  const _MediaStrip({required this.media});

  final List<RecipeMedia> media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final resolveUrl = ref.watch(mediaUrlResolverProvider);

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: media.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = media[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 112,
              height: 112,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  RemotePhoto(
                    url: item.kind == MediaKind.image ? resolveUrl(item.url) : null,
                    iconSize: 24,
                  ),
                  if (item.kind == MediaKind.video)
                    ColoredBox(
                      color: AppColors.forestDeep.withValues(alpha: 0.45),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_outline_rounded,
                            size: 30,
                            color: AppColors.creamRaised,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t.recipes.detail.video,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.creamRaised,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TagWrap extends StatelessWidget {
  const _TagWrap({required this.recipe});

  final RecipeDetail recipe;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in recipe.tags) _Tag(label: tag, emphasized: false),
        for (final tag in recipe.dietaryTags) _Tag(label: tag, emphasized: true),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.emphasized});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: emphasized ? AppColors.sageMist : AppColors.creamRaised,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: emphasized ? AppColors.sage : AppColors.line,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: emphasized ? AppColors.forest : AppColors.charcoalMuted,
        ),
      ),
    );
  }
}

class _QuietBody extends StatelessWidget {
  const _QuietBody({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodyMedium);
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.recipe, required this.onPressed});

  final RecipeDetail recipe;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.creamRaised,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            key: const Key('recipe-save'),
            onPressed: onPressed,
            icon: Icon(
              recipe.isSaved ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
              size: 20,
            ),
            label: Text(
              recipe.isSaved ? t.recipes.detail.saved : t.recipes.detail.save,
            ),
          ),
        ),
      ),
    );
  }
}

String? _formatQuantity(double? quantity) {
  if (quantity == null) {
    return null;
  }

  if (quantity == quantity.roundToDouble()) {
    return quantity.toInt().toString();
  }

  return quantity.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}
