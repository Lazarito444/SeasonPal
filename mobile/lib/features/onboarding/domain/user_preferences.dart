import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

/// Mirrors the backend `CulinarySkillLevel` enum; [wireValue] keeps the JSON
/// contract explicit instead of relying on enum order.
enum SkillLevel {
  @JsonValue(0)
  beginner,
  @JsonValue(1)
  intermediate,
  @JsonValue(2)
  advanced;

  String get label => switch (this) {
    SkillLevel.beginner => 'Beginner',
    SkillLevel.intermediate => 'Intermediate',
    SkillLevel.advanced => 'Advanced',
  };

  String get description => switch (this) {
    SkillLevel.beginner => 'Simple recipes and familiar techniques.',
    SkillLevel.intermediate => 'Comfortable trying new methods.',
    SkillLevel.advanced => 'Ready for a proper challenge.',
  };

  int get wireValue => switch (this) {
    SkillLevel.beginner => 0,
    SkillLevel.intermediate => 1,
    SkillLevel.advanced => 2,
  };
}

@freezed
abstract class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default([]) List<String> favoriteCuisines,
    @Default([]) List<String> dietaryRestrictions,
    @Default(SkillLevel.beginner) SkillLevel skillLevel,
    int? usualCookTimeMinutes,
    @Default([]) List<String> interests,
    @Default(false) bool onboardingCompleted,
    DateTime? completedAt,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
