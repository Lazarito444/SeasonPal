import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/core/widgets/brand_mark.dart';
import 'package:seasonpal/core/widgets/error_banner.dart';
import 'package:seasonpal/features/auth/presentation/auth_controller.dart';
import 'package:seasonpal/features/auth/presentation/auth_gate.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Shown while restoring a stored session, and when that restore failed (for
/// example, the API is not running).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final gate = ref.watch(authGateProvider);
    final auth = ref.watch(authControllerProvider);
    final error = auth.error;

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const BrandMark(size: 58),
                      const SizedBox(height: 24),
                      Text(
                        'SeasonPal',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        t.app.tagline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 40),
                      if (gate == AuthGate.error) ...[
                        ErrorBanner(
                          message: error is ApiException ? localizeApiError(t, error) : t.auth.splash.restoreFailed,
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: () => ref.invalidate(authControllerProvider),
                          child: Text(t.common.tryAgain),
                        ),
                      ] else ...[
                        const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          t.auth.splash.loading,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.charcoalMuted),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
