import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/features/auth/presentation/auth_controller.dart';
import 'package:seasonpal/features/onboarding/data/preferences_repository.dart';
import 'package:seasonpal/features/onboarding/domain/user_preferences.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_state.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Auto-disposed with the wizard so a different account never inherits the
/// previous user's half-finished answers.
final onboardingControllerProvider = NotifierProvider.autoDispose<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

final class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void next() {
    if (state.isLastStep) {
      return;
    }

    state = state.copyWith(step: state.step + 1, clearError: true);
  }

  void back() {
    if (state.isFirstStep) {
      return;
    }

    state = state.copyWith(step: state.step - 1, clearError: true);
  }

  void toggleCuisine(String value) {
    state = state.copyWith(
      cuisines: _toggle(state.cuisines, value),
      clearError: true,
    );
  }

  void toggleDietaryRestriction(String value) {
    state = state.copyWith(
      dietaryRestrictions: _toggle(state.dietaryRestrictions, value),
      clearError: true,
    );
  }

  void toggleInterest(String value) {
    state = state.copyWith(
      interests: _toggle(state.interests, value),
      clearError: true,
    );
  }

  void setSkillLevel(SkillLevel value) {
    state = state.copyWith(skillLevel: value, clearError: true);
  }

  void toggleCookTime(int minutes) {
    state = state.cookTimeMinutes == minutes ? state.copyWith(clearCookTime: true, clearError: true) : state.copyWith(cookTimeMinutes: minutes, clearError: true);
  }

  /// Persists the answers and flips the session flag; the router then lands on
  /// home with the preference-derived greeting.
  Future<void> finish() async {
    if (state.isSaving) {
      return;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    final preferences = UserPreferences(
      favoriteCuisines: state.cuisines.toList(growable: false),
      dietaryRestrictions: state.dietaryRestrictions.toList(growable: false),
      skillLevel: state.skillLevel,
      usualCookTimeMinutes: state.cookTimeMinutes,
      interests: state.interests.toList(growable: false),
      onboardingCompleted: true,
    );

    try {
      await ref.read(preferencesRepositoryProvider).save(preferences);
      ref.read(authControllerProvider.notifier).markOnboardingCompleted();
      state = state.copyWith(isSaving: false);
    } on ApiException catch (error) {
      state = state.copyWith(
        isSaving: false,
        error: localizeApiError(t, error),
      );
    } on Object {
      state = state.copyWith(isSaving: false, error: t.onboarding.saveError);
    }
  }

  static Set<String> _toggle(Set<String> values, String value) {
    final next = {...values};
    if (!next.add(value)) {
      next.remove(value);
    }

    return next;
  }
}
