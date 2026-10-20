import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_backdrop.dart';
import '../../../core/widgets/app_choice_chip.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/error_banner.dart';
import '../domain/onboarding_options.dart';
import '../domain/user_preferences.dart';
import 'onboarding_controller.dart';
import 'onboarding_state.dart';

/// Five quiet steps: welcome, cuisines, diet (plus interests), rhythm, done.
/// Answers stay local until the final step saves them.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  children: [
                    _WizardHeader(
                      step: state.step,
                      onBack: state.isFirstStep ? null : controller.back,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: ValueKey(state.step),
                        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                        child: _StepBody(state: state, controller: controller),
                      ),
                    ),
                    _WizardFooter(state: state, controller: controller),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({required this.step, this.onBack});

  final int step;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 24, 0),
      child: Column(
        children: [
          Row(
            children: [
              if (onBack == null)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: BrandMark(size: 34),
                )
              else
                IconButton(
                  key: const Key('onboarding-back-top'),
                  onPressed: onBack,
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back_rounded, size: 21),
                ),
              const Spacer(),
              Text(
                'STEP ${step + 1} OF ${OnboardingState.stepCount}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (
                var index = 0;
                index < OnboardingState.stepCount;
                index++
              ) ...[
                if (index > 0) const SizedBox(width: 6),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= step ? AppColors.forest : AppColors.line,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return switch (state.step) {
      0 => const _WelcomeStep(),
      1 => _CuisinesStep(state: state, controller: controller),
      2 => _DietStep(state: state, controller: controller),
      3 => _RhythmStep(state: state, controller: controller),
      _ => _DoneStep(state: state),
    };
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
        ),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(body, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'A QUICK TASTE OF YOU',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
        ),
        const SizedBox(height: 12),
        Text(
          "Let's set the table.",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 14),
        Text(
          "A few questions so SeasonPal can suggest dishes that fit your "
          "kitchen — not someone else's.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 34),
        const _Note(
          icon: Icons.public_rounded,
          title: 'Cuisines you love',
          body: 'The flavours you reach for on a normal week.',
        ),
        const _Note(
          icon: Icons.no_food_outlined,
          title: 'Anything you avoid',
          body: 'Allergies and diets we should always respect.',
        ),
        const _Note(
          icon: Icons.schedule_rounded,
          title: 'The time you have',
          body: 'Tuesday dinner looks different from a Sunday project.',
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.sageMist.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timelapse_rounded,
                size: 17,
                color: AppColors.forest,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'About a minute, start to finish.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.forest,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.creamRaised,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Icon(icon, size: 20, color: AppColors.forest),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CuisinesStep extends StatelessWidget {
  const _CuisinesStep({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeading(
          eyebrow: 'Your taste',
          title: 'What do you crave?',
          body:
              'Pick the cuisines you reach for most. Choose as many as '
              'you like.',
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final cuisine in OnboardingOptions.cuisines)
              AppChoiceChip(
                key: Key('cuisine-$cuisine'),
                label: cuisine,
                selected: state.cuisines.contains(cuisine),
                onTap: () => controller.toggleCuisine(cuisine),
              ),
          ],
        ),
      ],
    );
  }
}

class _DietStep extends StatelessWidget {
  const _DietStep({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeading(
          eyebrow: 'Your table',
          title: 'Anything off the menu?',
          body:
              "Allergies, diets, or ingredients you'd rather skip. Pick "
              'everything that applies.',
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final restriction in OnboardingOptions.dietaryRestrictions)
              AppChoiceChip(
                key: Key('diet-$restriction'),
                label: restriction,
                selected: state.dietaryRestrictions.contains(restriction),
                onTap: () => controller.toggleDietaryRestriction(restriction),
              ),
          ],
        ),
        const SizedBox(height: 34),
        Container(height: 1, color: AppColors.line),
        const SizedBox(height: 26),
        Text(
          'What are you into?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          'Optional — it helps us tune the suggestions.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final interest in OnboardingOptions.interests)
              AppChoiceChip(
                key: Key('interest-$interest'),
                label: interest,
                selected: state.interests.contains(interest),
                onTap: () => controller.toggleInterest(interest),
              ),
          ],
        ),
      ],
    );
  }
}

class _RhythmStep extends StatelessWidget {
  const _RhythmStep({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeading(
          eyebrow: 'Your rhythm',
          title: 'How do you like to cook?',
          body:
              'We use this to choose techniques and recipes that feel '
              'right for you.',
        ),
        const SizedBox(height: 22),
        for (final level in SkillLevel.values) ...[
          _SkillOption(
            key: Key('skill-${level.name}'),
            level: level,
            selected: state.skillLevel == level,
            onTap: () => controller.setSkillLevel(level),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 22),
        Text(
          'Time on a usual night',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          'Leave it unset if it changes day to day.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final minutes in OnboardingOptions.cookTimes)
              AppChoiceChip(
                key: Key('time-$minutes'),
                label: OnboardingOptions.cookTimeLabel(minutes),
                selected: state.cookTimeMinutes == minutes,
                onTap: () => controller.toggleCookTime(minutes),
              ),
          ],
        ),
      ],
    );
  }
}

class _SkillOption extends StatelessWidget {
  const _SkillOption({
    required this.level,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final SkillLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${level.label}. ${level.description}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? AppColors.sageMist : AppColors.creamRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? AppColors.forest : AppColors.line,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.forest : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.forest : AppColors.line,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: AppColors.creamRaised,
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    final cuisines = state.cuisines.isEmpty
        ? 'Open to anything'
        : state.cuisines.join(', ');
    final diet = state.dietaryRestrictions.isEmpty
        ? 'No restrictions'
        : state.dietaryRestrictions.join(', ');
    final time = state.cookTimeMinutes == null
        ? 'No set time'
        : OnboardingOptions.cookTimeLabel(state.cookTimeMinutes!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.sageMist,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 26,
            color: AppColors.forest,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Your kitchen is ready.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        Text(
          "Here's what we'll cook with. You can change any of it later.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.creamRaised,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              _SummaryRow(label: 'Cuisines', value: cuisines),
              _SummaryRow(label: 'Diet', value: diet),
              _SummaryRow(label: 'Skill', value: state.skillLevel.label),
              _SummaryRow(label: 'Usual time', value: time, isLast: true),
            ],
          ),
        ),
        if (state.interests.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Also into',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.spice),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final interest in state.interests)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sageMist.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    interest,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.forest),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WizardFooter extends StatelessWidget {
  const _WizardFooter({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final isLast = state.isLastStep;
    final label = state.isFirstStep
        ? 'Begin'
        : isLast
        ? 'Finish setup'
        : 'Continue';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.94),
        border: const Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.error != null) ...[
            ErrorBanner(message: state.error!),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              if (!state.isFirstStep) ...[
                TextButton(
                  key: const Key('onboarding-back'),
                  onPressed: state.isSaving ? null : controller.back,
                  child: const Text('Back'),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: FilledButton(
                  key: const Key('onboarding-primary'),
                  onPressed: state.isSaving
                      ? null
                      : () {
                          if (isLast) {
                            controller.finish();
                          } else {
                            controller.next();
                          }
                        },
                  child: state.isSaving
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text('Saving…'),
                          ],
                        )
                      : Text(label),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
