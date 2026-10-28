import 'package:flutter/material.dart';

/// One selectable cuisine: the canonical API value plus the glyph that carries
/// its identity on the onboarding cards.
@immutable
final class CuisineOption {
  const CuisineOption({required this.value, required this.icon});

  /// Stored value. Canonical English, matched by the discovery filters.
  final String value;
  final IconData icon;
}

/// A dietary restriction card: canonical API value, glyph, and the reassurance
/// line under its name.
@immutable
final class DietOption {
  const DietOption({required this.value, required this.icon});

  final String value;
  final IconData icon;
}

/// One answer in the "time you usually cook" scale. [minutes] is what the API
/// stores; `null` means "it varies", which is the honest shape of an unset
/// usual time.
@immutable
final class CookTimeBucket {
  const CookTimeBucket({
    required this.id,
    required this.minutes,
    required this.icon,
  });

  final String id;
  final int? minutes;
  final IconData icon;
}

/// Fixed answer sets for onboarding. Kept in the domain rather than widgets so
/// profile editing can reuse the same vocabulary later.
abstract final class OnboardingOptions {
  /// The design asks for three cuisines so a first feed is never one-note.
  static const minimumCuisines = 3;

  static const cuisines = <CuisineOption>[
    CuisineOption(value: 'Italian', icon: Icons.local_pizza),
    CuisineOption(value: 'Mediterranean', icon: Icons.set_meal),
    CuisineOption(value: 'Middle Eastern', icon: Icons.tapas),
    CuisineOption(value: 'Mexican', icon: Icons.local_fire_department),
    CuisineOption(value: 'Indian', icon: Icons.soup_kitchen),
    CuisineOption(value: 'Japanese', icon: Icons.ramen_dining),
    CuisineOption(value: 'Korean', icon: Icons.rice_bowl),
    CuisineOption(value: 'Thai', icon: Icons.spa),
    CuisineOption(value: 'Chinese', icon: Icons.local_dining),
    CuisineOption(value: 'French', icon: Icons.bakery_dining),
    CuisineOption(value: 'Spanish', icon: Icons.wine_bar),
    CuisineOption(value: 'Greek', icon: Icons.waves),
    CuisineOption(value: 'Turkish', icon: Icons.kebab_dining),
    CuisineOption(value: 'Vietnamese', icon: Icons.grass),
    CuisineOption(value: 'American', icon: Icons.brunch_dining),
    CuisineOption(value: 'North African', icon: Icons.fireplace),
    CuisineOption(value: 'Latin American', icon: Icons.outdoor_grill),
    CuisineOption(value: 'Nordic', icon: Icons.forest),
    CuisineOption(value: 'Caribbean', icon: Icons.beach_access),
    CuisineOption(value: 'African', icon: Icons.agriculture),
  ];

  static const dietaryRestrictions = <DietOption>[
    DietOption(value: 'Vegetarian', icon: Icons.eco),
    DietOption(value: 'Vegan', icon: Icons.compost),
    DietOption(value: 'Gluten-free', icon: Icons.grain),
    DietOption(value: 'Dairy-free', icon: Icons.water_drop),
    DietOption(value: 'Nut-free', icon: Icons.emoji_nature),
    DietOption(value: 'Halal', icon: Icons.verified),
    DietOption(value: 'Kosher', icon: Icons.star_rounded),
    DietOption(value: 'Pescatarian', icon: Icons.set_meal),
    DietOption(value: 'Low-carb', icon: Icons.egg_alt),
    DietOption(value: 'Low-sodium', icon: Icons.favorite_rounded),
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

  static const cookTimes = <CookTimeBucket>[
    CookTimeBucket(id: 'quick', minutes: 20, icon: Icons.flash_on_rounded),
    CookTimeBucket(id: 'balanced', minutes: 45, icon: Icons.timelapse_rounded),
    CookTimeBucket(id: 'long', minutes: 60, icon: Icons.hourglass_bottom),
    CookTimeBucket(id: 'variable', minutes: null, icon: Icons.all_inclusive),
  ];
}
