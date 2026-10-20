/// Fixed answer sets for onboarding. Kept in the domain rather than widgets so
/// profile editing can reuse the same vocabulary later.
abstract final class OnboardingOptions {
  static const cuisines = <String>[
    'Italian',
    'Mediterranean',
    'Middle Eastern',
    'Mexican',
    'Indian',
    'Japanese',
    'Korean',
    'Thai',
    'Chinese',
    'French',
    'Spanish',
    'Greek',
    'Turkish',
    'Vietnamese',
    'American',
    'North African',
    'Latin American',
    'Nordic',
    'Caribbean',
    'African',
  ];

  static const dietaryRestrictions = <String>[
    'Vegetarian',
    'Vegan',
    'Gluten-free',
    'Dairy-free',
    'Nut-free',
    'Halal',
    'Kosher',
    'Pescatarian',
    'Low-carb',
    'Low-sodium',
  ];

  static const interests = <String>[
    'Weeknight dinners',
    'Meal prep',
    'Baking',
    'Grilling',
    'Slow cooking',
    'Fermentation',
    'Plant-forward',
    'Comfort food',
    'Entertaining',
    'Budget cooking',
    'Cooking with kids',
    'Spices & heat',
  ];

  static const cookTimes = <int>[15, 30, 45, 60, 90];

  static String cookTimeLabel(int minutes) =>
      minutes == 60 ? '1 hour' : '$minutes min';
}
