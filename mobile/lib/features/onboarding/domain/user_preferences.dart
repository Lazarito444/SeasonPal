/// Mirrors the backend `CulinarySkillLevel` enum; [wireValue] keeps the JSON
/// contract explicit instead of relying on enum order.
enum SkillLevel {
  beginner(0),
  intermediate(1),
  advanced(2);

  const SkillLevel(this.wireValue);

  final int wireValue;

  static SkillLevel fromWire(int? value) => values.firstWhere(
    (item) => item.wireValue == value,
    orElse: () => SkillLevel.beginner,
  );
}

/// The cooking preferences collected during onboarding and edited later.
final class UserPreferences {
  const UserPreferences({
    this.favoriteCuisines = const [],
    this.dietaryRestrictions = const [],
    this.skillLevel = SkillLevel.beginner,
    this.usualCookTimeMinutes,
    this.interests = const [],
    this.onboardingCompleted = false,
    this.completedAt,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteCuisines: _stringList(json['favoriteCuisines']),
      dietaryRestrictions: _stringList(json['dietaryRestrictions']),
      skillLevel: SkillLevel.fromWire((json['skillLevel'] as num?)?.toInt()),
      usualCookTimeMinutes: (json['usualCookTimeMinutes'] as num?)?.toInt(),
      interests: _stringList(json['interests']),
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      completedAt: _dateTimeOrNull(json['completedAt']),
    );
  }

  final List<String> favoriteCuisines;
  final List<String> dietaryRestrictions;
  final SkillLevel skillLevel;
  final int? usualCookTimeMinutes;
  final List<String> interests;
  final bool onboardingCompleted;
  final DateTime? completedAt;
}

List<String> _stringList(Object? value) {
  if (value == null) {
    return const [];
  }

  return (value as List<dynamic>).map((item) => item as String).toList(growable: false);
}

DateTime? _dateTimeOrNull(Object? value) {
  return value == null ? null : DateTime.parse(value as String);
}
