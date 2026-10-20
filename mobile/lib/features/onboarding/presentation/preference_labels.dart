import '../../../i18n/strings.g.dart';
import '../domain/user_preferences.dart';

/// Localized display names for the canonical English values stored by the API.
/// Unknown values pass through so a newer backend vocabulary still renders.
String cuisineLabel(Translations t, String value) => switch (value) {
  'Italian' => t.onboarding.options.cuisines.italian,
  'Mediterranean' => t.onboarding.options.cuisines.mediterranean,
  'Middle Eastern' => t.onboarding.options.cuisines.middleEastern,
  'Mexican' => t.onboarding.options.cuisines.mexican,
  'Indian' => t.onboarding.options.cuisines.indian,
  'Japanese' => t.onboarding.options.cuisines.japanese,
  'Korean' => t.onboarding.options.cuisines.korean,
  'Thai' => t.onboarding.options.cuisines.thai,
  'Chinese' => t.onboarding.options.cuisines.chinese,
  'French' => t.onboarding.options.cuisines.french,
  'Spanish' => t.onboarding.options.cuisines.spanish,
  'Greek' => t.onboarding.options.cuisines.greek,
  'Turkish' => t.onboarding.options.cuisines.turkish,
  'Vietnamese' => t.onboarding.options.cuisines.vietnamese,
  'American' => t.onboarding.options.cuisines.american,
  'North African' => t.onboarding.options.cuisines.northAfrican,
  'Latin American' => t.onboarding.options.cuisines.latinAmerican,
  'Nordic' => t.onboarding.options.cuisines.nordic,
  'Caribbean' => t.onboarding.options.cuisines.caribbean,
  'African' => t.onboarding.options.cuisines.african,
  _ => value,
};

String dietLabel(Translations t, String value) => switch (value) {
  'Vegetarian' => t.onboarding.options.diets.vegetarian,
  'Vegan' => t.onboarding.options.diets.vegan,
  'Gluten-free' => t.onboarding.options.diets.glutenFree,
  'Dairy-free' => t.onboarding.options.diets.dairyFree,
  'Nut-free' => t.onboarding.options.diets.nutFree,
  'Halal' => t.onboarding.options.diets.halal,
  'Kosher' => t.onboarding.options.diets.kosher,
  'Pescatarian' => t.onboarding.options.diets.pescatarian,
  'Low-carb' => t.onboarding.options.diets.lowCarb,
  'Low-sodium' => t.onboarding.options.diets.lowSodium,
  _ => value,
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

String cookTimeLabel(Translations t, int minutes) => minutes == 60
    ? t.onboarding.time.hour
    : '$minutes ${t.onboarding.time.minSuffix}';
