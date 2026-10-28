import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/core/widgets/brand_mark.dart';
import 'package:seasonpal/core/widgets/error_banner.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_controller.dart';
import 'package:seasonpal/features/onboarding/presentation/onboarding_state.dart';
import 'package:seasonpal/features/onboarding/presentation/steps/cuisines_step.dart';
import 'package:seasonpal/features/onboarding/presentation/steps/diet_step.dart';
import 'package:seasonpal/features/onboarding/presentation/steps/recap_step.dart';
import 'package:seasonpal/features/onboarding/presentation/steps/rhythm_step.dart';
import 'package:seasonpal/features/onboarding/presentation/steps/welcome_step.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Five quiet steps: welcome, cuisines, diet (plus interests), rhythm, done.
/// Answers stay local until the final step saves them.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final isWelcome = state.step == 0;

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
                    if (!isWelcome)
                      const Padding(
                        padding: EdgeInsets.only(top: 6, bottom: 8),
                        child: Center(child: BrandLockup()),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        key: ValueKey(state.step),
                        padding: EdgeInsets.fromLTRB(
                          20,
                          isWelcome ? 20 : 8,
                          20,
                          24,
                        ),
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

class _StepBody extends StatelessWidget {
  const _StepBody({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return switch (state.step) {
      0 => const WelcomeStep(),
      1 => CuisinesStep(state: state, controller: controller),
      2 => DietStep(state: state, controller: controller),
      3 => RhythmStep(state: state, controller: controller),
      _ => RecapStep(state: state, controller: controller),
    };
  }
}

class _WizardFooter extends StatelessWidget {
  const _WizardFooter({required this.state, required this.controller});

  final OnboardingState state;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isLast = state.isLastStep;

    final label = switch (state.step) {
      0 => t.onboarding.welcome.start,
      1 => t.onboarding.cuisines.next,
      2 => t.onboarding.diet.next,
      3 => t.onboarding.rhythm.next,
      _ => t.onboarding.done.finish,
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.96),
        border: const Border(top: BorderSide(color: AppColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.error != null) ...[
            ErrorBanner(message: state.error!),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              if (state.step > 0) ...[
                _BackButton(
                  onPressed: state.isSaving ? null : controller.back,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: FilledButton(
                  key: const Key('onboarding-primary'),
                  onPressed: state.isSaving || !state.canContinue ? null : () => isLast ? controller.finish() : controller.next(),
                  child: state.isSaving
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox.square(
                              dimension: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.creamRaised,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(t.onboarding.footer.saving),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(child: Text(label)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              ),
            ],
          ),
          if (state.step == 0)
            TextButton(
              key: const Key('onboarding-skip'),
              onPressed: state.isSaving ? null : controller.skip,
              child: Text(t.onboarding.welcome.skip),
            ),
          if (isLast)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                t.onboarding.done.footnote,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('onboarding-back'),
      onPressed: onPressed,
      tooltip: Translations.of(context).common.back,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surfaceCard,
        foregroundColor: AppColors.forest,
        minimumSize: const Size(54, 54),
        shape: const CircleBorder(),
        side: const BorderSide(color: AppColors.line),
      ),
      icon: const Icon(Icons.arrow_back_rounded, size: 20),
    );
  }
}
