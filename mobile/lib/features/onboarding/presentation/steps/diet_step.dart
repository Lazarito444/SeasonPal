import 'package:flutter/material.dart';

import 'package:seasonpal/core/widgets/app_choice_chip.dart';
import 'package:seasonpal/core/widgets/app_section_header.dart';
import 'package:seasonpal/core/widgets/app_select_card.dart';
import 'package:seasonpal/core/widgets/app_step_header.dart';
import 'package:seasonpal/features/onboarding/domain/onboarding_options.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_controller.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_state.dart';
import 'package:seasonpal/features/onboarding/presentation/preference_labels.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Step 3: what the kitchen must avoid, then the themes it should lean into.
class DietStep extends StatelessWidget {
  const DietStep({required this.state, required this.controller, super.key});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppStepHeader(
          eyebrow: t.onboarding.eyebrowDiet(
            current: state.questionNumber,
            total: OnboardingState.questionCount,
          ),
          progress: state.progress,
          title: t.onboarding.diet.title,
          body: t.onboarding.diet.body,
        ),
        const SizedBox(height: 26),
        AppSectionHeader(
          icon: Icons.gpp_maybe_rounded,
          title: t.onboarding.diet.restrictionsTitle,
          hint: t.onboarding.diet.restrictionsBody,
        ),
        const SizedBox(height: 14),
        for (final option in OnboardingOptions.dietaryRestrictions) ...[
          AppSelectCard(
            key: Key('diet-${option.value}'),
            icon: option.icon,
            title: dietLabel(t, option.value),
            description: dietDescription(t, option.value),
            selected: state.dietaryRestrictions.contains(option.value),
            onTap: () => controller.toggleDietaryRestriction(option.value),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 18),
        const Divider(),
        const SizedBox(height: 20),
        AppSectionHeader(
          icon: Icons.local_florist_rounded,
          title: t.onboarding.diet.interestsTitle,
          hint: t.onboarding.diet.interestsBody,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            for (final interest in OnboardingOptions.interests)
              AppChoiceChip(
                key: Key('interest-$interest'),
                label: interestLabel(t, interest),
                selected: state.interests.contains(interest),
                onTap: () => controller.toggleInterest(interest),
              ),
          ],
        ),
      ],
    );
  }
}
