import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/widgets/error_banner.dart';
import 'package:seasonpal/features/auth/presentation/auth_controller.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_controls.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_field.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:seasonpal/features/auth/presentation/widgets/password_strength_meter.dart';
import 'package:seasonpal/i18n/strings.g.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscurePassword = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // The strength meter follows the text field keystroke by keystroke.
    _password.addListener(_handlePasswordChanged);
  }

  void _handlePasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _password.removeListener(_handlePasswordChanged);
    _displayName.dispose();
    _email.dispose();
    _password.dispose();
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
      await ref
          .read(authControllerProvider.notifier)
          .register(
            email: _email.text.trim(),
            password: _password.text,
            displayName: _displayName.text.trim(),
          );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      final message = localizeApiError(Translations.of(context), error);
      setState(() {
        _error = message;
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

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AuthScaffold(
      title: t.auth.register.title,
      titleAccent: t.auth.register.titleAccent,
      subtitle: t.auth.register.subtitle,
      footer: AuthFooterLink(
        prompt: t.auth.register.alreadyHere,
        action: t.auth.register.signIn,
        actionKey: const Key('register-sign-in'),
        onPressed: _submitting ? null : () => context.goNamed(AppRoutes.loginName),
      ),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthField(
                label: t.auth.register.name,
                fieldKey: const Key('register-name'),
                controller: _displayName,
                icon: Icons.person_outline_rounded,
                hintText: t.auth.register.nameHint,
                labelHint: t.auth.register.optional,
                enabled: !_submitting,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: (value) => (value != null && value.trim().length > 80) ? t.auth.register.nameTooLong : null,
              ),
              const SizedBox(height: 14),
              AuthField(
                label: t.auth.register.email,
                fieldKey: const Key('register-email'),
                controller: _email,
                icon: Icons.mail_outline_rounded,
                hintText: t.auth.register.emailHint,
                labelHint: t.auth.register.required,
                enabled: !_submitting,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                validator: (value) => _validateEmail(t, value),
              ),
              const SizedBox(height: 14),
              AuthField(
                label: t.auth.register.password,
                fieldKey: const Key('register-password'),
                controller: _password,
                icon: Icons.lock_outline_rounded,
                hintText: '••••••••••••',
                labelHint: t.auth.register.passwordHint,
                enabled: !_submitting,
                obscureText: _obscurePassword,
                onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                onFieldSubmitted: (_) => _submit(),
                validator: (value) => _validatePassword(t, value),
              ),
              const SizedBox(height: 10),
              PasswordStrengthMeter(password: _password.text),
              const SizedBox(height: 18),
              FormField<bool>(
                initialValue: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (accepted) => (accepted ?? false) ? null : t.auth.register.termsRequired,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthCheckboxRow(
                      value: field.value ?? false,
                      onChanged: field.didChange,
                      label: t.auth.register.terms,
                      checkKey: const Key('register-terms'),
                    ),
                    if (field.hasError) ...[
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 34),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12.5,
                            color: AppColors.offline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                ErrorBanner(message: _error!),
              ],
              const SizedBox(height: 18),
              AuthSubmitButton(
                buttonKey: const Key('register-submit'),
                label: t.auth.register.submit,
                leadingIcon: Icons.eco_rounded,
                busy: _submitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AuthDivider(label: t.auth.social.continueWith),
        const SizedBox(height: 16),
        const AuthSocialButtons(),
      ],
    );
  }
}

String? _validateEmail(Translations t, String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) {
    return t.auth.register.emailRequired;
  }

  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return t.auth.register.emailInvalid;
  }

  return null;
}

String? _validatePassword(Translations t, String? value) {
  if (value == null || value.isEmpty) {
    return t.auth.register.passwordRequired;
  }

  if (value.length < 8) {
    return t.auth.register.passwordTooShort;
  }

  // Mirror ASP.NET Identity's defaults so the form fails before the API does;
  // its registration error is deliberately generic.
  final hasUpper = RegExp(r'\p{Lu}', unicode: true).hasMatch(value);
  final hasLower = RegExp(r'\p{Ll}', unicode: true).hasMatch(value);
  final hasDigit = RegExp(r'\p{Nd}', unicode: true).hasMatch(value);
  final hasSymbol = RegExp(r'[^\p{L}\p{N}]', unicode: true).hasMatch(value);
  if (!hasUpper || !hasLower || !hasDigit || !hasSymbol) {
    return t.auth.register.passwordTooWeak;
  }

  return null;
}
