import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

/// The three home rails in one response: what is moving, what is fresh, and
/// what fits the cook's saved taste profile.
final class DiscoveryHome {
  const DiscoveryHome({
    required this.trending,
    required this.newest,
    required this.recommended,
    required this.hasTasteProfile,
  });

  factory DiscoveryHome.fromJson(Map<String, dynamic> json) {
    return DiscoveryHome(
      trending: _recipes(json['trending']),
      newest: _recipes(json['newest']),
      recommended: _recipes(json['recommended']),
      hasTasteProfile: json['hasTasteProfile'] as bool? ?? false,
    );
  }

  final List<RecipeSummary> trending;
  final List<RecipeSummary> newest;
  final List<RecipeSummary> recommended;
  final bool hasTasteProfile;

  bool get isEmpty => trending.isEmpty && newest.isEmpty && recommended.isEmpty;
}

/// A public recipe scored against the ingredients the cook already has.
final class PantryMatch {
  const PantryMatch({
    required this.recipe,
    required this.matchedCount,
    required this.missingCount,
    required this.matchedIngredients,
    required this.missingIngredients,
    required this.matchPercent,
    required this.canCook,
  });

  factory PantryMatch.fromJson(Map<String, dynamic> json) {
    return PantryMatch(
      recipe: RecipeSummary.fromJson(
        json['recipe'] as Map<String, dynamic>,
      ),
      matchedCount: (json['matchedCount'] as num).toInt(),
      missingCount: (json['missingCount'] as num).toInt(),
      matchedIngredients: _names(json['matchedIngredients']),
      missingIngredients: _names(json['missingIngredients']),
      matchPercent: (json['matchPercent'] as num).toInt(),
      canCook: json['canCook'] as bool? ?? false,
    );
  }

  final RecipeSummary recipe;
  final int matchedCount;
  final int missingCount;
  final List<String> matchedIngredients;
  final List<String> missingIngredients;
  final int matchPercent;
  final bool canCook;

  int get consideredCount => matchedCount + missingCount;
}

List<RecipeSummary> _recipes(Object? value) {
  if (value == null) {
    return const [];
  }

  return (value as List<dynamic>).map((item) => RecipeSummary.fromJson(item as Map<String, dynamic>)).toList(growable: false);
}

List<String> _names(Object? value) {
  if (value == null) {
    return const [];
  }

  return (value as List<dynamic>).map((item) => item as String).toList(growable: false);
}
