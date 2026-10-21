import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/core/media/media_urls.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/remote_photo.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_labels.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// The library's unit of food: photograph first, then name and the two facts a
/// cook checks before opening it — time and servings.
class RecipeCard extends ConsumerWidget {
  const RecipeCard({required this.recipe, required this.onTap, super.key});

  final RecipeSummary recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final resolveUrl = ref.watch(mediaUrlResolverProvider);
    final coverUrl = recipe.coverImageUrl == null ? null : resolveUrl(recipe.coverImageUrl!);
    final total = totalMinutesOf(
      total: recipe.totalTimeMinutes,
      prep: recipe.prepTimeMinutes,
      cook: recipe.cookTimeMinutes,
    );

    return Semantics(
      button: true,
      label: recipe.title,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      RemotePhoto(
                        url: coverUrl,
                        semanticLabel: recipe.title,
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Row(
                          children: [
                            if (recipe.status == RecipeStatus.draft)
                              _Badge(
                                label: t.recipes.library.draft,
                                background: AppColors.creamRaised,
                                foreground: AppColors.forest,
                              ),
                            if (recipe.status == RecipeStatus.draft && recipe.isAiGenerated) const SizedBox(width: 6),
                            if (recipe.isAiGenerated)
                              _Badge(
                                label: t.recipes.library.ai,
                                background: AppColors.spice,
                                foreground: AppColors.creamRaised,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 17,
                          height: 1.25,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (total != null) ...[
                            Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: AppColors.charcoalMuted.withValues(
                                alpha: 0.8,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              minutesLabel(t, total),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: AppColors.line,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: Text(
                              servingsLabel(t, recipe.servings),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
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

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
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
