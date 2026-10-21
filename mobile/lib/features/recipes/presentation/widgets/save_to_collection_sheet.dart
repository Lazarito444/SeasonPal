import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/error_banner.dart';
import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_providers.dart';
import 'package:seasonpal/features/recipes/presentation/widgets/collection_dialogs.dart';
import 'package:seasonpal/i18n/strings.g.dart';

enum SaveSheetResult { saved, unsaved }

/// Bottom sheet for the save decision: favorites first, then any named
/// collection. Every path performs a real API call before closing.
Future<SaveSheetResult?> showSaveToCollectionSheet(
  BuildContext context, {
  required String recipeId,
  required bool isSaved,
}) {
  return showModalBottomSheet<SaveSheetResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.creamRaised,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) => _SaveToCollectionSheet(recipeId: recipeId, isSaved: isSaved),
  );
}

class _SaveToCollectionSheet extends ConsumerStatefulWidget {
  const _SaveToCollectionSheet({
    required this.recipeId,
    required this.isSaved,
  });

  final String recipeId;
  final bool isSaved;

  @override
  ConsumerState<_SaveToCollectionSheet> createState() => _SaveToCollectionSheetState();
}

class _SaveToCollectionSheetState extends ConsumerState<_SaveToCollectionSheet> {
  bool _busy = false;
  String? _error;

  Future<void> _save({String? collectionId}) async {
    if (_busy) {
      return;
    }

    final t = Translations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref.read(recipeRepositoryProvider).save(widget.recipeId, collectionId: collectionId);
      if (mounted) {
        Navigator.of(context).pop(SaveSheetResult.saved);
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = localizeApiError(t, error);
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = t.recipes.saveSheet.saveError;
        });
      }
    }
  }

  Future<void> _unsave() async {
    if (_busy) {
      return;
    }

    final t = Translations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref.read(recipeRepositoryProvider).unsave(widget.recipeId);
      if (mounted) {
        Navigator.of(context).pop(SaveSheetResult.unsaved);
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = localizeApiError(t, error);
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = t.recipes.saveSheet.saveError;
        });
      }
    }
  }

  Future<void> _createAndSave() async {
    final collection = await showCreateCollectionDialog(context);
    if (collection != null && mounted) {
      await _save(collectionId: collection.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final collections = ref.watch(collectionsProvider);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          22,
          12,
          22,
          18 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              t.recipes.saveSheet.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t.recipes.saveSheet.favoritesBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            if (!widget.isSaved)
              FilledButton.icon(
                key: const Key('save-sheet-favorites'),
                onPressed: _busy ? null : () => _save(),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.bookmark_add_rounded, size: 20),
                label: Text(t.recipes.saveSheet.favorites),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                decoration: BoxDecoration(
                  color: AppColors.sageMist.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bookmark_added_rounded,
                      size: 20,
                      color: AppColors.forest,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        t.recipes.saveSheet.savedStatus,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.forest,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    TextButton(
                      key: const Key('save-sheet-unsave'),
                      onPressed: _busy ? null : _unsave,
                      child: Text(t.recipes.saveSheet.unsave),
                    ),
                  ],
                ),
              ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              ErrorBanner(message: _error!),
            ],
            const SizedBox(height: 22),
            Text(
              t.recipes.saveSheet.collections,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.spice,
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: collections.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.forest,
                      ),
                    ),
                  ),
                ),
                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.recipes.saveSheet.collectionsError,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref.invalidate(collectionsProvider),
                        child: Text(t.common.tryAgain),
                      ),
                    ],
                  ),
                ),
                data: (page) {
                  final collections = page.items.where((item) => !item.isDefaultFavorites).toList(growable: false);

                  if (collections.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        t.recipes.saveSheet.noCollections,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: collections.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.line),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return ListTile(
                        key: Key('save-sheet-collection-${collection.id}'),
                        contentPadding: EdgeInsets.zero,
                        enabled: !_busy,
                        leading: const Icon(
                          Icons.collections_bookmark_rounded,
                          size: 20,
                          color: AppColors.forest,
                        ),
                        title: Text(
                          collection.name,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.charcoal,
                          ),
                        ),
                        subtitle: Text(
                          collection.recipeCount == 1
                              ? t.recipes.collections.countOne
                              : t.recipes.collections.count(
                                  count: collection.recipeCount,
                                ),
                          style: const TextStyle(fontSize: 12.5),
                        ),
                        trailing: const Icon(
                          Icons.add_rounded,
                          size: 20,
                          color: AppColors.forest,
                        ),
                        onTap: () => _save(collectionId: collection.id),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              key: const Key('save-sheet-new-collection'),
              onPressed: _busy ? null : _createAndSave,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(t.recipes.saveSheet.newCollection),
            ),
          ],
        ),
      ),
    );
  }
}
