import 'package:seasonpal/features/recipes/domain/recipe_models.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Localized display names for wire enums and the small meta labels reused by
/// cards, the detail page, and the editor.
String mealTypeLabel(Translations t, MealType value) => switch (value) {
  MealType.breakfast => t.recipes.mealTypes.breakfast,
  MealType.lunch => t.recipes.mealTypes.lunch,
  MealType.dinner => t.recipes.mealTypes.dinner,
  MealType.snack => t.recipes.mealTypes.snack,
  MealType.dessert => t.recipes.mealTypes.dessert,
  MealType.drink => t.recipes.mealTypes.drink,
  MealType.unspecified => t.recipes.mealTypes.unspecified,
};

String difficultyLabel(Translations t, RecipeDifficulty value) => switch (value) {
  RecipeDifficulty.easy => t.recipes.difficulty.easy,
  RecipeDifficulty.medium => t.recipes.difficulty.medium,
  RecipeDifficulty.hard => t.recipes.difficulty.hard,
};

String minutesLabel(Translations t, int minutes) => t.recipes.library.minutes(count: minutes);

/// Timers under a minute stay in seconds rather than rounding up to "1 min".
String durationLabel(Translations t, int seconds) => seconds < 60 ? t.recipes.library.seconds(count: seconds) : minutesLabel(t, (seconds / 60).ceil());

String servingsLabel(Translations t, int servings) => servings == 1 ? t.recipes.library.servingsOne : t.recipes.library.servings(count: servings);

/// Total time when the API provides it; otherwise prep plus cook.
int? totalMinutesOf({
  required int? total,
  required int? prep,
  required int? cook,
}) {
  if (total != null) {
    return total;
  }

  if (prep == null && cook == null) {
    return null;
  }

  return (prep ?? 0) + (cook ?? 0);
}
