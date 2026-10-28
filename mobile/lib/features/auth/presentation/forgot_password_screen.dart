import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/core/widgets/error_banner.dart';
import 'package:seasonpal/features/auth/data/auth_repository.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_controls.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_field.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Password reset request. The API answers 202 for every address, so the
/// success state is intentionally identical for known and unknown emails.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  bool _submitting = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) {
      return;
    }

    setState(() => _error = null);
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _submitting = true);

    try {
      await ref.read(authRepositoryProvider).forgotPassword(_email.text.trim());
      if (!mounted) {
        return;
      }

      setState(() {
        _sent = true;
        _submitting = false;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = localizeApiError(Translations.of(context), error);
        _submitting = false;
      });
    } on Object {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = Translations.of(context).errors.generic;
        _submitting = false;
      });
    }
  }

  void _backToSignIn() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.loginName);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final sentTo = _email.text.trim();

    return AuthScaffold(
      onBack: _backToSignIn,
      showBrand: false,
      centered: true,
      showPrivacyNote: false,
      leading: _sent ? const _SuccessMark() : const _ResetIllustration(),
      title: _sent ? t.auth.forgot.successTitle : t.auth.forgot.title,
      subtitle: _sent ? t.auth.forgot.successBody(email: sentTo) : t.auth.forgot.body,
      footer: _sent
          ? null
          : AuthFooterLink(
              prompt: t.auth.forgot.remembered,
              action: t.auth.forgot.signIn,
              onPressed: _submitting ? null : _backToSignIn,
            ),
      children: _sent
          ? [
              const _DataProtectionCard(),
              const SizedBox(height: 22),
              AuthSubmitButton(
                buttonKey: const Key('forgot-back-to-sign-in'),
                label: t.auth.forgot.backToSignIn,
                leadingIcon: Icons.login_rounded,
                onPressed: _backToSignIn,
              ),
            ]
          : [
              SizedBox(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthField(
                        label: t.auth.forgot.email,
                        fieldKey: const Key('forgot-email'),
                        controller: _email,
                        icon: Icons.mail_outline_rounded,
                        hintText: t.auth.forgot.emailHint,
                        tone: AuthFieldTone.raised,
                        enabled: !_submitting,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.email],
                        autocorrect: false,
                        helperText: t.auth.forgot.inboxHint,
                        helperIcon: Icons.verified_user_outlined,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (value) => _validateEmail(t, value),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        ErrorBanner(message: _error!),
                      ],
                      const SizedBox(height: 18),
                      AuthSubmitButton(
                        buttonKey: const Key('forgot-submit'),
                        label: t.auth.forgot.submit,
                        trailingIcon: Icons.arrow_forward_rounded,
                        busy: _submitting,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const _DataProtectionCard(),
            ],
    );
  }
}

String? _validateEmail(Translations t, String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) {
    return t.auth.forgot.emailRequired;
  }

  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return t.auth.forgot.emailInvalid;
  }

  return null;
}

class _ResetIllustration extends StatelessWidget {
  const _ResetIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 108,
        height: 108,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sageMist.withValues(alpha: 0.65),
              ),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceCard,
                border: Border.all(color: AppColors.line),
                boxShadow: AppShadows.lifted,
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                size: 32,
                color: AppColors.forest,
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.spice,
                  boxShadow: AppShadows.card,
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  size: 15,
                  color: AppColors.creamRaised,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessMark extends StatelessWidget {
  const _SuccessMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 92,
        height: 92,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sageMist,
        ),
        child: Container(
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceCard,
            border: Border.all(color: AppColors.line),
            boxShadow: AppShadows.card,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size: 30,
            color: AppColors.forest,
          ),
        ),
      ),
    );
  }
}

class _DataProtectionCard extends StatelessWidget {
  const _DataProtectionCard();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSunken,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.sage.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceCard,
              boxShadow: AppShadows.card,
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 18,
              color: AppColors.forest,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.auth.forgot.dataTitle, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  t.auth.forgot.dataBody,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
