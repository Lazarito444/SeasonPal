import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/media/media_urls.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/core/widgets/error_banner.dart';
import 'package:seasonpal/core/widgets/remote_photo.dart';
import 'package:seasonpal/features/recipes/data/recipe_repository.dart';
import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/features/recipes/presentation/library_controller.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_labels.dart';
import 'package:seasonpal/features/recipes/presentation/recipe_providers.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Create or replace a recipe through the same structured form: seven writing
/// steps, real uploads, and a single save that either creates or updates.
class RecipeEditorScreen extends ConsumerWidget {
  const RecipeEditorScreen({this.recipeId, super.key});

  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = recipeId;
    if (id == null) {
      return const _RecipeEditorBody();
    }

    final async = ref.watch(recipeDetailProvider(id));
    return async.when(
      loading: () => const _EditorFrame(
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
      error: (error, stackTrace) => _EditorFrame(
        child: _EditorLoadError(
          title: Translations.of(context).recipes.editor.loadError,
          onBack: () => context.pop(),
          onRetry: () => ref.invalidate(recipeDetailProvider(id)),
        ),
      ),
      data: (recipe) => _RecipeEditorBody(existing: recipe),
    );
  }
}

class _EditorFrame extends StatelessWidget {
  const _EditorFrame({required this.child});

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

class _EditorLoadError extends StatelessWidget {
  const _EditorLoadError({
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 22),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: Text(t.common.back),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: onRetry,
                  child: Text(t.common.tryAgain),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeEditorBody extends ConsumerStatefulWidget {
  const _RecipeEditorBody({this.existing});

  final RecipeDetail? existing;

  @override
  ConsumerState<_RecipeEditorBody> createState() => _RecipeEditorBodyState();
}

class _RecipeEditorBodyState extends ConsumerState<_RecipeEditorBody> {
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _cuisine;
  late final TextEditingController _prep;
  late final TextEditingController _cook;
  final _tagInput = TextEditingController();
  final _dietInput = TextEditingController();

  late List<_IngredientFields> _ingredients;
  late List<_StepFields> _steps;
  late List<String> _tags;
  late List<String> _dietaryTags;
  late MealType _mealType;
  late RecipeDifficulty _difficulty;
  late int _servings;
  String? _coverImageUrl;
  late List<RecipeMediaInput> _media;
  bool _publish = false;
  bool _saving = false;
  bool _uploadingCover = false;
  bool _uploadingMedia = false;
  String? _error;
  String? _uploadError;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final recipe = widget.existing;
    _title = TextEditingController(text: recipe?.title ?? '');
    _description = TextEditingController(text: recipe?.description ?? '');
    _cuisine = TextEditingController(text: recipe?.cuisine ?? '');
    _prep = TextEditingController(text: _number(recipe?.prepTimeMinutes));
    _cook = TextEditingController(text: _number(recipe?.cookTimeMinutes));
    _ingredients = recipe == null || recipe.ingredients.isEmpty ? [_IngredientFields()] : recipe.ingredients.map(_IngredientFields.from).toList();
    _steps = recipe == null || recipe.steps.isEmpty ? [_StepFields()] : recipe.steps.map(_StepFields.from).toList();
    _tags = [...?recipe?.tags];
    _dietaryTags = [...?recipe?.dietaryTags];
    _mealType = recipe?.mealType ?? MealType.unspecified;
    _difficulty = recipe?.difficulty ?? RecipeDifficulty.easy;
    _servings = recipe?.servings ?? 2;
    _coverImageUrl = recipe?.coverImageUrl;
    _media = [
      for (final item in recipe?.media ?? const <RecipeMedia>[]) RecipeMediaInput(url: item.url, kind: item.kind, altText: item.altText),
    ];
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _cuisine.dispose();
    _prep.dispose();
    _cook.dispose();
    _tagInput.dispose();
    _dietInput.dispose();
    for (final ingredient in _ingredients) {
      ingredient.dispose();
    }
    for (final step in _steps) {
      step.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final canPublish = !_isEditing || (widget.existing?.status == RecipeStatus.draft && widget.existing?.visibility == RecipeVisibility.private);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  key: const Key('editor-back'),
                                  onPressed: () => context.pop(),
                                  tooltip: t.common.back,
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 21,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _isEditing ? t.recipes.editor.editEyebrow : t.recipes.editor.newEyebrow,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.spice),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isEditing ? t.recipes.editor.editTitle : t.recipes.editor.newTitle,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _isEditing ? t.recipes.editor.editBody : t.recipes.editor.newBody,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _EditorSection(
                        index: 1,
                        eyebrow: t.recipes.editor.basics.eyebrow,
                        title: t.recipes.editor.basics.title,
                        child: Column(
                          children: [
                            TextField(
                              key: const Key('editor-title'),
                              controller: _title,
                              textCapitalization: TextCapitalization.sentences,
                              maxLength: 200,
                              decoration: InputDecoration(
                                labelText: t.recipes.editor.basics.name,
                                hintText: t.recipes.editor.basics.nameHint,
                                counterText: '',
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              key: const Key('editor-description'),
                              controller: _description,
                              minLines: 2,
                              maxLines: 4,
                              maxLength: 2000,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: t.recipes.editor.basics.description,
                                hintText: t.recipes.editor.basics.descriptionHint,
                                counterText: '',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _EditorSection(
                        index: 2,
                        eyebrow: t.recipes.editor.plate.eyebrow,
                        title: t.recipes.editor.plate.title,
                        child: Column(
                          children: [
                            TextField(
                              key: const Key('editor-cuisine'),
                              controller: _cuisine,
                              maxLength: 100,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: t.recipes.editor.plate.cuisine,
                                hintText: t.recipes.editor.plate.cuisineHint,
                                counterText: '',
                              ),
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<MealType>(
                              key: const Key('editor-meal'),
                              initialValue: _mealType,
                              decoration: InputDecoration(
                                labelText: t.recipes.editor.plate.meal,
                              ),
                              items: [
                                for (final type in MealType.values)
                                  DropdownMenuItem(
                                    value: type,
                                    child: Text(mealTypeLabel(t, type)),
                                  ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _mealType = value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _EditorSection(
                        index: 3,
                        eyebrow: t.recipes.editor.time.eyebrow,
                        title: t.recipes.editor.time.title,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    key: const Key('editor-prep'),
                                    controller: _prep,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      labelText: t.recipes.editor.time.prep,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    key: const Key('editor-cook'),
                                    controller: _cook,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      labelText: t.recipes.editor.time.cook,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    t.recipes.editor.time.servings,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                                _Stepper(
                                  value: _servings,
                                  onMinus: _servings > 1 ? () => setState(() => _servings--) : null,
                                  onPlus: _servings < 50 ? () => setState(() => _servings++) : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                t.recipes.editor.time.difficulty,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: SegmentedButton<RecipeDifficulty>(
                                key: const Key('editor-difficulty'),
                                showSelectedIcon: false,
                                segments: [
                                  for (final value in RecipeDifficulty.values)
                                    ButtonSegment(
                                      value: value,
                                      label: Text(difficultyLabel(t, value)),
                                    ),
                                ],
                                selected: {_difficulty},
                                onSelectionChanged: (selection) => setState(
                                  () => _difficulty = selection.first,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _EditorSection(
                        index: 4,
                        eyebrow: t.recipes.editor.photos.eyebrow,
                        title: t.recipes.editor.photos.title,
                        child: _PhotosSection(
                          coverImageUrl: _coverImageUrl,
                          uploadingCover: _uploadingCover,
                          uploadingMedia: _uploadingMedia,
                          media: _media,
                          error: _uploadError,
                          onPickCover: _pickCover,
                          onRemoveCover: () => setState(() => _coverImageUrl = null),
                          onAddPhoto: _pickPhoto,
                          onAddVideo: _pickVideo,
                          onRemoveMedia: (item) => setState(() => _media.remove(item)),
                          onUseAsCover: (item) => setState(() => _coverImageUrl = item.url),
                          onDismissError: () => setState(() => _uploadError = null),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _EditorSection(
                        index: 5,
                        eyebrow: t.recipes.editor.ingredients.eyebrow,
                        title: t.recipes.editor.ingredients.title,
                        child: Column(
                          children: [
                            for (var index = 0; index < _ingredients.length; index++) ...[
                              _IngredientEditorRow(
                                index: index,
                                fields: _ingredients[index],
                                canMoveUp: index > 0,
                                canMoveDown: index < _ingredients.length - 1,
                                onMoveUp: () => _moveIngredient(index, index - 1),
                                onMoveDown: () => _moveIngredient(index, index + 1),
                                onRemove: () => setState(() => _ingredients.removeAt(index).dispose()),
                              ),
                              if (index < _ingredients.length - 1) const SizedBox(height: 14),
                            ],
                            const SizedBox(height: 14),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton.icon(
                                key: const Key('editor-add-ingredient'),
                                onPressed: () => setState(
                                  () => _ingredients.add(_IngredientFields()),
                                ),
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: Text(
                                  t.recipes.editor.ingredients.add,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _EditorSection(
                        index: 6,
                        eyebrow: t.recipes.editor.steps.eyebrow,
                        title: t.recipes.editor.steps.title,
                        child: Column(
                          children: [
                            for (var index = 0; index < _steps.length; index++) ...[
                              _StepEditorRow(
                                number: index + 1,
                                fields: _steps[index],
                                canMoveUp: index > 0,
                                canMoveDown: index < _steps.length - 1,
                                onMoveUp: () => _moveStep(index, index - 1),
                                onMoveDown: () => _moveStep(index, index + 1),
                                onRemove: () => setState(() => _steps.removeAt(index).dispose()),
                              ),
                              if (index < _steps.length - 1) const SizedBox(height: 14),
                            ],
                            const SizedBox(height: 14),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton.icon(
                                key: const Key('editor-add-step'),
                                onPressed: () => setState(
                                  () => _steps.add(_StepFields()),
                                ),
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: Text(t.recipes.editor.steps.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _EditorSection(
                        index: 7,
                        eyebrow: t.recipes.editor.tags.eyebrow,
                        title: t.recipes.editor.tags.title,
                        body: t.recipes.editor.tags.body,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TagField(
                              fieldKey: const Key('editor-tag-input'),
                              controller: _tagInput,
                              label: t.recipes.editor.tags.tags,
                              hint: t.recipes.editor.tags.tagsHint,
                              values: _tags,
                              max: 20,
                              onAdd: (value) => _addTag(value, dietary: false),
                              onRemove: (value) => setState(() => _tags.remove(value)),
                            ),
                            const SizedBox(height: 16),
                            _TagField(
                              fieldKey: const Key('editor-diet-input'),
                              controller: _dietInput,
                              label: t.recipes.editor.tags.dietaryTags,
                              hint: t.recipes.editor.tags.dietaryHint,
                              values: _dietaryTags,
                              max: 10,
                              onAdd: (value) => _addTag(value, dietary: true),
                              onRemove: (value) => setState(() => _dietaryTags.remove(value)),
                            ),
                            if (canPublish) ...[
                              const SizedBox(height: 8),
                              Material(
                                type: MaterialType.transparency,
                                child: SwitchListTile(
                                  key: const Key('editor-publish'),
                                  contentPadding: EdgeInsets.zero,
                                  value: _publish,
                                  activeTrackColor: AppColors.sage,
                                  activeThumbColor: AppColors.forest,
                                  title: Text(
                                    t.recipes.editor.publish.label,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.charcoal,
                                    ),
                                  ),
                                  subtitle: Text(
                                    t.recipes.editor.publish.body,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                                  ),
                                  onChanged: (value) => setState(() => _publish = value),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: AppColors.creamRaised,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error != null) ...[
                    ErrorBanner(message: _error!),
                    const SizedBox(height: 10),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const Key('editor-save'),
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.creamRaised,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(t.recipes.editor.saving),
                              ],
                            )
                          : Text(
                              _publish ? t.recipes.editor.saveAndPublish : t.recipes.editor.save,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _moveIngredient(int from, int to) {
    setState(() {
      final item = _ingredients.removeAt(from);
      _ingredients.insert(to, item);
    });
  }

  void _moveStep(int from, int to) {
    setState(() {
      final item = _steps.removeAt(from);
      _steps.insert(to, item);
    });
  }

  void _addTag(String raw, {required bool dietary}) {
    final value = raw.trim();
    if (value.isEmpty) {
      return;
    }

    final list = dietary ? _dietaryTags : _tags;
    final max = dietary ? 10 : 20;
    if (list.length >= max || list.any((item) => item.toLowerCase() == value.toLowerCase())) {
      return;
    }

    setState(() {
      list.add(value);
      if (dietary) {
        _dietInput.clear();
      } else {
        _tagInput.clear();
      }
    });
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    final t = Translations.of(context);
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = t.recipes.editor.basics.nameRequired);
      return;
    }

    final ingredients = <RecipeIngredientInput>[];
    for (final row in _ingredients) {
      final name = row.name.text.trim();
      final quantity = row.quantity.text.trim();
      final unit = row.unit.text.trim();
      final note = row.note.text.trim();
      final blank = name.isEmpty && quantity.isEmpty && unit.isEmpty && note.isEmpty;
      if (blank) {
        continue;
      }

      if (name.isEmpty) {
        setState(() => _error = t.recipes.editor.ingredients.nameRequired);
        return;
      }

      final parsed = _positiveDouble(quantity);
      if (quantity.isNotEmpty && parsed == null) {
        setState(() => _error = t.recipes.editor.ingredients.quantityInvalid);
        return;
      }

      ingredients.add(
        RecipeIngredientInput(
          quantity: parsed,
          unit: unit.isEmpty ? null : unit,
          name: name,
          note: note.isEmpty ? null : note,
        ),
      );
    }

    final steps = <RecipeStepInput>[];
    for (final row in _steps) {
      final instruction = row.instruction.text.trim();
      final tip = row.tip.text.trim();
      final timer = row.timer.text.trim();
      final blank = instruction.isEmpty && tip.isEmpty && timer.isEmpty;
      if (blank) {
        continue;
      }

      if (instruction.isEmpty) {
        setState(() => _error = t.recipes.editor.steps.instructionRequired);
        return;
      }

      final timerMinutes = timer.isEmpty ? null : int.tryParse(timer);
      if (timer.isNotEmpty && (timerMinutes == null || timerMinutes < 1 || timerMinutes > 1440)) {
        setState(() => _error = t.recipes.editor.steps.timerInvalid);
        return;
      }

      steps.add(
        RecipeStepInput(
          instruction: instruction,
          tip: tip.isEmpty ? null : tip,
          timerSeconds: timerMinutes == null ? null : timerMinutes * 60,
        ),
      );
    }

    if (_publish && (ingredients.isEmpty || steps.isEmpty)) {
      setState(() => _error = t.recipes.editor.publish.incomplete);
      return;
    }

    final prep = _optionalMinutes(_prep.text);
    final cook = _optionalMinutes(_cook.text);
    if (_prep.text.trim().isNotEmpty && prep == null || _cook.text.trim().isNotEmpty && cook == null) {
      setState(() => _error = t.recipes.editor.time.invalid);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final input = RecipeWriteInput(
      title: title,
      description: _blankToNull(_description.text),
      cuisine: _blankToNull(_cuisine.text),
      coverImageUrl: _coverImageUrl,
      tags: _tags,
      dietaryTags: _dietaryTags,
      mealType: _mealType,
      servings: _servings,
      prepTimeMinutes: prep,
      cookTimeMinutes: cook,
      difficulty: _difficulty,
      ingredients: ingredients,
      steps: steps,
      media: _media,
    );

    final repository = ref.read(recipeRepositoryProvider);

    try {
      final saved = _isEditing ? await repository.update(widget.existing!.id, input) : await repository.create(input);

      var publishFailed = false;
      if (_publish) {
        try {
          await repository.publish(saved.id);
        } on Object {
          publishFailed = true;
        }
      }

      ref.invalidate(recipeDetailProvider(saved.id));
      ref.invalidate(libraryControllerProvider);
      ref.invalidate(collectionsProvider);

      if (!mounted) {
        return;
      }

      if (publishFailed) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(t.recipes.editor.publish.failed)),
          );
      }

      if (_isEditing) {
        context.pop();
      } else {
        context.pushReplacementNamed(
          AppRoutes.recipeDetailName,
          pathParameters: {'id': saved.id},
        );
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = error.fieldErrors.isEmpty ? localizeApiError(t, error) : error.fieldErrors.values.first.first;
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = t.recipes.editor.saveError;
        });
      }
    }
  }

  Future<void> _pickCover() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2400,
      imageQuality: 88,
    );
    if (file == null) {
      return;
    }

    final candidate = await _candidate(file, MediaKind.image);
    if (candidate == null) {
      return;
    }

    setState(() {
      _uploadingCover = true;
      _uploadError = null;
    });

    try {
      final upload = await ref.read(recipeRepositoryProvider).upload(candidate);
      if (mounted) {
        setState(() {
          _coverImageUrl = upload.url;
          _uploadingCover = false;
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          _uploadingCover = false;
          _uploadError = Translations.of(context).recipes.editor.photos.uploadError;
        });
      }
    }
  }

  Future<void> _pickPhoto() async {
    if (!_hasMediaCapacity()) {
      return;
    }

    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2400,
      imageQuality: 88,
    );
    if (file == null) {
      return;
    }

    await _uploadMedia(file, MediaKind.image);
  }

  Future<void> _pickVideo() async {
    if (!_hasMediaCapacity()) {
      return;
    }

    final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (file == null) {
      return;
    }

    await _uploadMedia(file, MediaKind.video);
  }

  /// The aggregate caps media at 20 items; stop before the picker so the cook
  /// never uploads a file the API will reject.
  bool _hasMediaCapacity() {
    if (_media.length < 20) {
      return true;
    }

    setState(
      () => _uploadError = Translations.of(context).recipes.editor.photos.tooMany,
    );
    return false;
  }

  Future<void> _uploadMedia(XFile file, MediaKind kind) async {
    final candidate = await _candidate(file, kind);
    if (candidate == null) {
      return;
    }

    setState(() {
      _uploadingMedia = true;
      _uploadError = null;
    });

    try {
      final upload = await ref.read(recipeRepositoryProvider).upload(candidate);
      if (mounted) {
        setState(() {
          _media = [
            ..._media,
            RecipeMediaInput(url: upload.url, kind: upload.kind),
          ];
          _uploadingMedia = false;
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          _uploadingMedia = false;
          _uploadError = Translations.of(context).recipes.editor.photos.uploadError;
        });
      }
    }
  }

  Future<UploadCandidate?> _candidate(XFile file, MediaKind kind) async {
    final t = Translations.of(context);
    final name = file.name.toLowerCase();
    final contentType = _contentTypeFor(name);
    if (contentType == null) {
      setState(() => _uploadError = t.recipes.editor.photos.unsupported);
      return null;
    }

    final length = await file.length();
    final max = kind == MediaKind.image ? 10 * 1024 * 1024 : 24 * 1024 * 1024;
    if (length > max) {
      setState(() => _uploadError = t.recipes.editor.photos.tooLarge);
      return null;
    }

    return UploadCandidate(
      path: file.path,
      fileName: file.name,
      contentType: contentType,
      kind: kind,
    );
  }
}

class _EditorSection extends StatelessWidget {
  const _EditorSection({
    required this.index,
    required this.eyebrow,
    required this.title,
    required this.child,
    this.body,
  });

  final int index;
  final String eyebrow;
  final String title;
  final String? body;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          decoration: BoxDecoration(
            color: AppColors.creamRaised,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    index.toString().padLeft(2, '0'),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.spice,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      eyebrow,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.charcoalMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                ),
              ),
              if (body != null) ...[
                const SizedBox(height: 6),
                Text(
                  body!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotosSection extends ConsumerWidget {
  const _PhotosSection({
    required this.coverImageUrl,
    required this.uploadingCover,
    required this.uploadingMedia,
    required this.media,
    required this.error,
    required this.onPickCover,
    required this.onRemoveCover,
    required this.onAddPhoto,
    required this.onAddVideo,
    required this.onRemoveMedia,
    required this.onUseAsCover,
    required this.onDismissError,
  });

  final String? coverImageUrl;
  final bool uploadingCover;
  final bool uploadingMedia;
  final List<RecipeMediaInput> media;
  final String? error;
  final VoidCallback onPickCover;
  final VoidCallback onRemoveCover;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;
  final ValueChanged<RecipeMediaInput> onRemoveMedia;
  final ValueChanged<RecipeMediaInput> onUseAsCover;
  final VoidCallback onDismissError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final resolveUrl = ref.watch(mediaUrlResolverProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                RemotePhoto(
                  url: coverImageUrl == null ? null : resolveUrl(coverImageUrl!),
                  iconSize: 34,
                ),
                if (uploadingCover)
                  ColoredBox(
                    color: AppColors.forestDeep.withValues(alpha: 0.35),
                    child: const Center(
                      child: SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.creamRaised,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('editor-cover-pick'),
                onPressed: uploadingCover ? null : onPickCover,
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: Text(
                  coverImageUrl == null ? t.recipes.editor.photos.chooseCover : t.recipes.editor.photos.changeCover,
                ),
              ),
            ),
            if (coverImageUrl != null) ...[
              const SizedBox(width: 8),
              IconButton(
                key: const Key('editor-cover-remove'),
                onPressed: uploadingCover ? null : onRemoveCover,
                tooltip: t.recipes.editor.photos.removeCover,
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Text(
          t.recipes.editor.photos.more,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        if (media.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in media)
                _MediaTile(
                  item: item,
                  url: item.kind == MediaKind.image ? resolveUrl(item.url) : null,
                  onRemove: () => onRemoveMedia(item),
                  onUseAsCover: item.kind == MediaKind.image ? () => onUseAsCover(item) : null,
                ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('editor-add-photo'),
                onPressed: uploadingMedia ? null : onAddPhoto,
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                label: Text(t.recipes.editor.photos.addPhoto),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('editor-add-video'),
                onPressed: uploadingMedia ? null : onAddVideo,
                icon: const Icon(Icons.videocam_outlined, size: 18),
                label: Text(t.recipes.editor.photos.addVideo),
              ),
            ),
          ],
        ),
        if (uploadingMedia) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.forest,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                t.recipes.editor.photos.uploading,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ErrorBanner(message: error!)),
              IconButton(
                onPressed: onDismissError,
                tooltip: t.common.dismiss,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.item,
    required this.url,
    required this.onRemove,
    this.onUseAsCover,
  });

  final RecipeMediaInput item;
  final String? url;
  final VoidCallback onRemove;
  final VoidCallback? onUseAsCover;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 84,
        height: 84,
        child: Stack(
          fit: StackFit.expand,
          children: [
            RemotePhoto(url: url, iconSize: 20),
            if (item.kind == MediaKind.video)
              ColoredBox(
                color: AppColors.forestDeep.withValues(alpha: 0.4),
                child: const Icon(
                  Icons.play_circle_outline_rounded,
                  size: 26,
                  color: AppColors.creamRaised,
                ),
              ),
            Positioned(
              top: 2,
              right: 2,
              child: _TileAction(
                icon: Icons.close_rounded,
                onPressed: onRemove,
              ),
            ),
            if (onUseAsCover != null)
              Positioned(
                bottom: 2,
                right: 2,
                child: _TileAction(
                  icon: Icons.star_outline_rounded,
                  onPressed: onUseAsCover!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TileAction extends StatelessWidget {
  const _TileAction({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.forestDeep.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 14, color: AppColors.creamRaised),
        ),
      ),
    );
  }
}

class _IngredientEditorRow extends StatelessWidget {
  const _IngredientEditorRow({
    required this.index,
    required this.fields,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
  });

  final int index;
  final _IngredientFields fields;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  key: Key('editor-ingredient-quantity-$index'),
                  controller: fields.quantity,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    labelText: t.recipes.editor.ingredients.quantity,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  key: Key('editor-ingredient-unit-$index'),
                  controller: fields.unit,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: t.recipes.editor.ingredients.unit,
                    counterText: '',
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            key: Key('editor-ingredient-name-$index'),
            controller: fields.name,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: t.recipes.editor.ingredients.name,
              counterText: '',
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: Key('editor-ingredient-note-$index'),
                  controller: fields.note,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: t.recipes.editor.ingredients.note,
                    counterText: '',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: canMoveUp ? onMoveUp : null,
                tooltip: t.recipes.editor.ingredients.moveUp,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.arrow_upward_rounded, size: 18),
              ),
              IconButton(
                onPressed: canMoveDown ? onMoveDown : null,
                tooltip: t.recipes.editor.ingredients.moveDown,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.arrow_downward_rounded, size: 18),
              ),
              IconButton(
                key: Key('editor-ingredient-remove-$index'),
                onPressed: onRemove,
                tooltip: t.recipes.editor.ingredients.remove,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepEditorRow extends StatelessWidget {
  const _StepEditorRow({
    required this.number,
    required this.fields,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
  });

  final int number;
  final _StepFields fields;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.forest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.creamRaised,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: canMoveUp ? onMoveUp : null,
                tooltip: t.recipes.editor.ingredients.moveUp,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.arrow_upward_rounded, size: 18),
              ),
              IconButton(
                onPressed: canMoveDown ? onMoveDown : null,
                tooltip: t.recipes.editor.ingredients.moveDown,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.arrow_downward_rounded, size: 18),
              ),
              IconButton(
                key: Key('editor-step-remove-$number'),
                onPressed: onRemove,
                tooltip: t.recipes.editor.steps.remove,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
          TextField(
            key: Key('editor-step-instruction-${number - 1}'),
            controller: fields.instruction,
            minLines: 2,
            maxLines: 5,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: t.recipes.editor.steps.instruction,
              counterText: '',
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: fields.tip,
            maxLength: 500,
            decoration: InputDecoration(
              labelText: t.recipes.editor.steps.tip,
              counterText: '',
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            key: Key('editor-step-timer-${number - 1}'),
            controller: fields.timer,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: t.recipes.editor.steps.timer,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagField extends StatelessWidget {
  const _TagField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.hint,
    required this.values,
    required this.max,
    required this.onAdd,
    required this.onRemove,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final List<String> values;
  final int max;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: fieldKey,
          controller: controller,
          enabled: values.length < max,
          maxLength: 50,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            counterText: '',
            suffixIcon: IconButton(
              onPressed: values.length < max ? () => onAdd(controller.text) : null,
              tooltip: t.recipes.editor.tags.add,
              icon: const Icon(Icons.add_rounded, size: 20),
            ),
          ),
          onSubmitted: onAdd,
        ),
        if (values.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final value in values)
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 4, 5),
                  decoration: BoxDecoration(
                    color: AppColors.sageMist,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.forest,
                        ),
                      ),
                      const SizedBox(width: 2),
                      InkWell(
                        onTap: () => onRemove(value),
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: AppColors.forest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: const Key('editor-servings-minus'),
            onPressed: onMinus,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove_rounded, size: 18),
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.charcoal,
              ),
            ),
          ),
          IconButton(
            key: const Key('editor-servings-plus'),
            onPressed: onPlus,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

class _IngredientFields {
  _IngredientFields({
    String quantity = '',
    String unit = '',
    String name = '',
    String note = '',
  }) : quantity = TextEditingController(text: quantity),
       unit = TextEditingController(text: unit),
       name = TextEditingController(text: name),
       note = TextEditingController(text: note);

  factory _IngredientFields.from(RecipeIngredient ingredient) => _IngredientFields(
    quantity: _quantityText(ingredient.quantity),
    unit: ingredient.unit ?? '',
    name: ingredient.name,
    note: ingredient.note ?? '',
  );

  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController name;
  final TextEditingController note;

  void dispose() {
    quantity.dispose();
    unit.dispose();
    name.dispose();
    note.dispose();
  }
}

class _StepFields {
  _StepFields({
    String instruction = '',
    String tip = '',
    String timer = '',
  }) : instruction = TextEditingController(text: instruction),
       tip = TextEditingController(text: tip),
       timer = TextEditingController(text: timer);

  factory _StepFields.from(RecipeStep step) => _StepFields(
    instruction: step.instruction,
    tip: step.tip ?? '',
    timer: step.timerSeconds == null ? '' : '${(step.timerSeconds! / 60).ceil()}',
  );

  final TextEditingController instruction;
  final TextEditingController tip;
  final TextEditingController timer;

  void dispose() {
    instruction.dispose();
    tip.dispose();
    timer.dispose();
  }
}

String _quantityText(double? value) {
  if (value == null) {
    return '';
  }

  return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

String _number(int? value) => value?.toString() ?? '';

String? _blankToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

double? _positiveDouble(String value) {
  if (value.trim().isEmpty) {
    return null;
  }

  final normalized = value.replaceAll(',', '.');
  final parsed = double.tryParse(normalized);
  return parsed == null || parsed < 0 ? null : parsed;
}

int? _optionalMinutes(String value) {
  if (value.trim().isEmpty) {
    return null;
  }

  final parsed = int.tryParse(value.trim());
  return parsed == null || parsed < 0 || parsed > 1440 ? null : parsed;
}

String? _contentTypeFor(String fileName) {
  final extension = fileName.split('.').last;
  return switch (extension) {
    'jpg' || 'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'webp' => 'image/webp',
    'gif' => 'image/gif',
    'mp4' => 'video/mp4',
    'mov' => 'video/quicktime',
    _ => null,
  };
}
