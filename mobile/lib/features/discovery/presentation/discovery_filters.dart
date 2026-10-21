import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seasonpal/features/recipes/domain/recipe_models.dart';

/// Time ceilings offered in the filter sheet. The backend stores the ceiling in
/// total minutes, so every option reads as "under N minutes".
const discoveryTimeOptions = <int>[15, 30, 45, 60, 90];

/// The discover feed's active search and chips. Every field is optional and all
/// of them combine in one request.
final class DiscoveryFilters {
  const DiscoveryFilters({
    this.query = '',
    this.cuisine,
    this.diet,
    this.mealType,
    this.difficulty,
    this.maxTotalTimeMinutes,
  });

  final String query;
  final String? cuisine;
  final String? diet;
  final MealType? mealType;
  final RecipeDifficulty? difficulty;
  final int? maxTotalTimeMinutes;

  bool get isActive => query.isNotEmpty || cuisine != null || diet != null || mealType != null || difficulty != null || maxTotalTimeMinutes != null;

  DiscoveryFilters copyWith({
    String? query,
    Object? cuisine = _unset,
    Object? diet = _unset,
    Object? mealType = _unset,
    Object? difficulty = _unset,
    Object? maxTotalTimeMinutes = _unset,
  }) {
    return DiscoveryFilters(
      query: query ?? this.query,
      cuisine: identical(cuisine, _unset) ? this.cuisine : cuisine as String?,
      diet: identical(diet, _unset) ? this.diet : diet as String?,
      mealType: identical(mealType, _unset) ? this.mealType : mealType as MealType?,
      difficulty: identical(difficulty, _unset) ? this.difficulty : difficulty as RecipeDifficulty?,
      maxTotalTimeMinutes: identical(maxTotalTimeMinutes, _unset) ? this.maxTotalTimeMinutes : maxTotalTimeMinutes as int?,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DiscoveryFilters &&
      other.query == query &&
      other.cuisine == cuisine &&
      other.diet == diet &&
      other.mealType == mealType &&
      other.difficulty == difficulty &&
      other.maxTotalTimeMinutes == maxTotalTimeMinutes;

  @override
  int get hashCode => Object.hash(
    query,
    cuisine,
    diet,
    mealType,
    difficulty,
    maxTotalTimeMinutes,
  );
}

const _unset = Object();

final discoveryFiltersProvider = NotifierProvider<DiscoveryFiltersController, DiscoveryFilters>(
  DiscoveryFiltersController.new,
);

/// Holds the chips so the feed controller can watch one value and rebuild only
/// when a filter actually changes.
final class DiscoveryFiltersController extends Notifier<DiscoveryFilters> {
  @override
  DiscoveryFilters build() => const DiscoveryFilters();

  void setQuery(String value) {
    final next = value.trim();
    if (next != state.query) {
      state = state.copyWith(query: next);
    }
  }

  void setCuisine(String? value) => _apply(state.copyWith(cuisine: value));

  void setDiet(String? value) => _apply(state.copyWith(diet: value));

  void setMealType(MealType? value) => _apply(state.copyWith(mealType: value));

  void setDifficulty(RecipeDifficulty? value) => _apply(state.copyWith(difficulty: value));

  void setMaxTotalTimeMinutes(int? value) => _apply(state.copyWith(maxTotalTimeMinutes: value));

  void clear() => _apply(const DiscoveryFilters());

  void _apply(DiscoveryFilters next) {
    if (next != state) {
      state = next;
    }
  }
}
