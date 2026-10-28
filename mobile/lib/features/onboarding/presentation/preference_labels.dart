import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Localized display names for the canonical English values stored by the API.
/// Unknown values pass through so a newer backend vocabulary still renders.
String cuisineLabel(Translations t, String value) => switch (value) {
  'Italian' => t.onboarding.options.cuisines.italian.label,
  'Mediterranean' => t.onboarding.options.cuisines.mediterranean.label,
  'Middle Eastern' => t.onboarding.options.cuisines.middleEastern.label,
  'Mexican' => t.onboarding.options.cuisines.mexican.label,
  'Indian' => t.onboarding.options.cuisines.indian.label,
  'Japanese' => t.onboarding.options.cuisines.japanese.label,
  'Korean' => t.onboarding.options.cuisines.korean.label,
  'Thai' => t.onboarding.options.cuisines.thai.label,
  'Chinese' => t.onboarding.options.cuisines.chinese.label,
  'French' => t.onboarding.options.cuisines.french.label,
  'Spanish' => t.onboarding.options.cuisines.spanish.label,
  'Greek' => t.onboarding.options.cuisines.greek.label,
  'Turkish' => t.onboarding.options.cuisines.turkish.label,
  'Vietnamese' => t.onboarding.options.cuisines.vietnamese.label,
  'American' => t.onboarding.options.cuisines.american.label,
  'North African' => t.onboarding.options.cuisines.northAfrican.label,
  'Latin American' => t.onboarding.options.cuisines.latinAmerican.label,
  'Nordic' => t.onboarding.options.cuisines.nordic.label,
  'Caribbean' => t.onboarding.options.cuisines.caribbean.label,
  'African' => t.onboarding.options.cuisines.african.label,
  _ => value,
};

/// The one-line flavour note printed under a cuisine name on its card.
String cuisineDescription(Translations t, String value) => switch (value) {
  'Italian' => t.onboarding.options.cuisines.italian.description,
  'Mediterranean' => t.onboarding.options.cuisines.mediterranean.description,
  'Middle Eastern' => t.onboarding.options.cuisines.middleEastern.description,
  'Mexican' => t.onboarding.options.cuisines.mexican.description,
  'Indian' => t.onboarding.options.cuisines.indian.description,
  'Japanese' => t.onboarding.options.cuisines.japanese.description,
  'Korean' => t.onboarding.options.cuisines.korean.description,
  'Thai' => t.onboarding.options.cuisines.thai.description,
  'Chinese' => t.onboarding.options.cuisines.chinese.description,
  'French' => t.onboarding.options.cuisines.french.description,
  'Spanish' => t.onboarding.options.cuisines.spanish.description,
  'Greek' => t.onboarding.options.cuisines.greek.description,
  'Turkish' => t.onboarding.options.cuisines.turkish.description,
  'Vietnamese' => t.onboarding.options.cuisines.vietnamese.description,
  'American' => t.onboarding.options.cuisines.american.description,
  'North African' => t.onboarding.options.cuisines.northAfrican.description,
  'Latin American' => t.onboarding.options.cuisines.latinAmerican.description,
  'Nordic' => t.onboarding.options.cuisines.nordic.description,
  'Caribbean' => t.onboarding.options.cuisines.caribbean.description,
  'African' => t.onboarding.options.cuisines.african.description,
  _ => '',
};

/// The short name used in prose and filter chips, where the full card label
/// would read like a menu description.
String cuisineShortLabel(Translations t, String value) => switch (value) {
  'Italian' => t.onboarding.options.cuisines.italian.short,
  'Mediterranean' => t.onboarding.options.cuisines.mediterranean.short,
  'Middle Eastern' => t.onboarding.options.cuisines.middleEastern.short,
  'Mexican' => t.onboarding.options.cuisines.mexican.short,
  'Indian' => t.onboarding.options.cuisines.indian.short,
  'Japanese' => t.onboarding.options.cuisines.japanese.short,
  'Korean' => t.onboarding.options.cuisines.korean.short,
  'Thai' => t.onboarding.options.cuisines.thai.short,
  'Chinese' => t.onboarding.options.cuisines.chinese.short,
  'French' => t.onboarding.options.cuisines.french.short,
  'Spanish' => t.onboarding.options.cuisines.spanish.short,
  'Greek' => t.onboarding.options.cuisines.greek.short,
  'Turkish' => t.onboarding.options.cuisines.turkish.short,
  'Vietnamese' => t.onboarding.options.cuisines.vietnamese.short,
  'American' => t.onboarding.options.cuisines.american.short,
  'North African' => t.onboarding.options.cuisines.northAfrican.short,
  'Latin American' => t.onboarding.options.cuisines.latinAmerican.short,
  'Nordic' => t.onboarding.options.cuisines.nordic.short,
  'Caribbean' => t.onboarding.options.cuisines.caribbean.short,
  'African' => t.onboarding.options.cuisines.african.short,
  _ => value,
};

String dietLabel(Translations t, String value) => switch (value) {
  'Vegetarian' => t.onboarding.options.diets.vegetarian.label,
  'Vegan' => t.onboarding.options.diets.vegan.label,
  'Gluten-free' => t.onboarding.options.diets.glutenFree.label,
  'Dairy-free' => t.onboarding.options.diets.dairyFree.label,
  'Nut-free' => t.onboarding.options.diets.nutFree.label,
  'Halal' => t.onboarding.options.diets.halal.label,
  'Kosher' => t.onboarding.options.diets.kosher.label,
  'Pescatarian' => t.onboarding.options.diets.pescatarian.label,
  'Low-carb' => t.onboarding.options.diets.lowCarb.label,
  'Low-sodium' => t.onboarding.options.diets.lowSodium.label,
  _ => value,
};

String dietDescription(Translations t, String value) => switch (value) {
  'Vegetarian' => t.onboarding.options.diets.vegetarian.description,
  'Vegan' => t.onboarding.options.diets.vegan.description,
  'Gluten-free' => t.onboarding.options.diets.glutenFree.description,
  'Dairy-free' => t.onboarding.options.diets.dairyFree.description,
  'Nut-free' => t.onboarding.options.diets.nutFree.description,
  'Halal' => t.onboarding.options.diets.halal.description,
  'Kosher' => t.onboarding.options.diets.kosher.description,
  'Pescatarian' => t.onboarding.options.diets.pescatarian.description,
  'Low-carb' => t.onboarding.options.diets.lowCarb.description,
  'Low-sodium' => t.onboarding.options.diets.lowSodium.description,
  _ => '',
};

String interestLabel(Translations t, String value) => switch (value) {
  'Weeknight dinners' => t.onboarding.options.interests.weeknightDinners,
  'Meal prep' => t.onboarding.options.interests.mealPrep,
  'Baking' => t.onboarding.options.interests.baking,
  'Grilling' => t.onboarding.options.interests.grilling,
  'Slow cooking' => t.onboarding.options.interests.slowCooking,
  'Fermentation' => t.onboarding.options.interests.fermentation,
  'Plant-forward' => t.onboarding.options.interests.plantForward,
  'Comfort food' => t.onboarding.options.interests.comfortFood,
  'Entertaining' => t.onboarding.options.interests.entertaining,
  'Budget cooking' => t.onboarding.options.interests.budgetCooking,
  'Cooking with kids' => t.onboarding.options.interests.cookingWithKids,
  'Spices & heat' => t.onboarding.options.interests.spicesAndHeat,
  _ => value,
};

extension SkillLevelLabels on SkillLevel {
  String label(Translations t) => switch (this) {
    SkillLevel.beginner => t.onboarding.skill.beginner.label,
    SkillLevel.intermediate => t.onboarding.skill.intermediate.label,
    SkillLevel.advanced => t.onboarding.skill.advanced.label,
  };

  String description(Translations t) => switch (this) {
    SkillLevel.beginner => t.onboarding.skill.beginner.description,
    SkillLevel.intermediate => t.onboarding.skill.intermediate.description,
    SkillLevel.advanced => t.onboarding.skill.advanced.description,
  };
}

/// Name and explanatory line for one entry of the cook-time scale.
String cookTimeBucketLabel(Translations t, String id) => switch (id) {
  'quick' => t.onboarding.time.buckets.quick.label,
  'balanced' => t.onboarding.time.buckets.balanced.label,
  'long' => t.onboarding.time.buckets.long.label,
  _ => t.onboarding.time.buckets.variable.label,
};

String cookTimeBucketDescription(Translations t, String id) => switch (id) {
  'quick' => t.onboarding.time.buckets.quick.description,
  'balanced' => t.onboarding.time.buckets.balanced.description,
  'long' => t.onboarding.time.buckets.long.description,
  _ => t.onboarding.time.buckets.variable.description,
};

/// Compact time format for read-only surfaces such as the home greeting.
String cookTimeLabel(Translations t, int minutes) => minutes == 60 ? t.onboarding.time.hour : '$minutes ${t.onboarding.time.minSuffix}';
