import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/error_banner.dart';
import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_providers.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Asks for a collection name and creates it. Returns `null` when the cook
/// backs out; all failures stay inside the dialog so nothing is lost.
Future<CollectionSummary?> showCreateCollectionDialog(
  BuildContext context,
) {
  return showDialog<CollectionSummary>(
    context: context,
    builder: (context) => const _CreateCollectionDialog(),
  );
}

class _CreateCollectionDialog extends ConsumerStatefulWidget {
  const _CreateCollectionDialog();

  @override
  ConsumerState<_CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends ConsumerState<_CreateCollectionDialog> {
  final _name = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final t = Translations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = t.recipes.saveSheet.nameRequired);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final collection = await ref.read(recipeRepositoryProvider).createCollection(name: name);
      ref.invalidate(collectionsProvider);
      if (mounted) {
        Navigator.of(context).pop(collection);
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = localizeApiError(t, error);
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = t.recipes.saveSheet.createError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Dialog(
      backgroundColor: AppColors.creamRaised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.recipes.saveSheet.createTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('collection-name'),
              controller: _name,
              autofocus: true,
              enabled: !_saving,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: t.recipes.saveSheet.nameLabel,
                hintText: t.recipes.saveSheet.nameHint,
                counterText: '',
              ),
              onSubmitted: (_) => _create(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              ErrorBanner(message: _error!),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _saving ? null : () => Navigator.of(context).pop(),
                    child: Text(t.common.cancel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    key: const Key('collection-create-submit'),
                    onPressed: _saving ? null : _create,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                    ),
                    child: _saving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.creamRaised,
                            ),
                          )
                        : Text(t.recipes.saveSheet.create),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Confirmation used by destructive collection actions.
Future<bool> confirmCollectionAction(
  BuildContext context, {
  required String title,
  required String body,
  required String confirm,
}) async {
  final t = Translations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.creamRaised,
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(t.common.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.offline),
          child: Text(confirm),
        ),
      ],
    ),
  );

  return result ?? false;
}
