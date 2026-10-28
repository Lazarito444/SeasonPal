import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_section_header.dart';
import 'package:seasonpal/core/widgets/app_select_card.dart';
import 'package:seasonpal/core/widgets/app_step_header.dart';
import 'package:seasonpal/features/onboarding/domain/onboarding_options.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_controller.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_state.dart';
import 'package:seasonpal/features/onboarding/presentation/preference_labels.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Step 2: the cuisines that seed the seasonal feed. Holds the wizard until the
/// minimum is met, and says how many are still missing.
class CuisinesStep extends StatelessWidget {
  const CuisinesStep({
    required this.state,
    required this.controller,
    super.key,
  });

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppStepHeader(
          eyebrow: t.onboarding.eyebrowCuisines(
            current: state.questionNumber,
            total: OnboardingState.questionCount,
          ),
          progress: state.progress,
          title: t.onboarding.cuisines.title,
          body: t.onboarding.cuisines.body,
        ),
        const SizedBox(height: 26),
        AppSectionHeader(
          icon: Icons.restaurant_rounded,
          title: t.onboarding.cuisines.sectionTitle,
          hint: t.onboarding.cuisines.sectionBody,
        ),
        const SizedBox(height: 14),
        for (final option in OnboardingOptions.cuisines) ...[
          AppSelectCard(
            key: Key('cuisine-${option.value}'),
            icon: option.icon,
            title: cuisineLabel(t, option.value),
            description: cuisineDescription(t, option.value),
            selected: state.cuisines.contains(option.value),
            onTap: () => controller.toggleCuisine(option.value),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 6),
        _SelectionMeter(state: state),
      ],
    );
  }
}

class _SelectionMeter extends StatelessWidget {
  const _SelectionMeter({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final ready = state.cuisinesRemaining == 0;
    final count = state.cuisines.length;

    final counter = count == 0
        ? t.onboarding.cuisines.counterNone
        : count == 1
        ? t.onboarding.cuisines.counterOne
        : t.onboarding.cuisines.counterOther(count: count);

    final gate = ready
        ? t.onboarding.cuisines.ready
        : state.cuisinesRemaining == 1
        ? t.onboarding.cuisines.remainingOne
        : t.onboarding.cuisines.remainingOther(count: state.cuisinesRemaining);

    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ready ? AppColors.forest : AppColors.spice,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            counter,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.charcoal,
            ),
          ),
        ),
        Text(
          gate,
          style: theme.textTheme.labelMedium?.copyWith(
            color: ready ? AppColors.forest : AppColors.spice,
          ),
        ),
      ],
    );
  }
}
