import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seasonpal/core/l10n/api_error_messages.dart';
import 'package:seasonpal/core/network/api_exception.dart';
import 'package:seasonpal/core/router/app_router.dart';
import 'package:seasonpal/core/widgets/error_banner.dart';
import 'package:seasonpal/features/auth/presentation/auth_controller.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_controls.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_field.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:seasonpal/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:seasonpal/i18n/strings.g.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscurePassword = true;
  bool _remember = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
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
          .login(
            email: _email.text.trim(),
            password: _password.text,
            remember: _remember,
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

  void _openForgotPassword() {
    if (_submitting) {
      return;
    }

    context.pushNamed(AppRoutes.forgotPasswordName);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AuthScaffold(
      title: t.auth.login.title,
      titleAccent: t.auth.login.titleAccent,
      subtitle: t.auth.login.subtitle,
      footer: AuthFooterLink(
        prompt: t.auth.login.newHere,
        action: t.auth.login.createAccount,
        showArrow: true,
        actionKey: const Key('login-create-account'),
        onPressed: _submitting ? null : () => context.goNamed(AppRoutes.registerName),
      ),
      children: [
        AuthFormCard(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthField(
                    label: t.auth.login.email,
                    fieldKey: const Key('login-email'),
                    controller: _email,
                    icon: Icons.mail_outline_rounded,
                    hintText: t.auth.login.emailHint,
                    enabled: !_submitting,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    autocorrect: false,
                    validator: (value) => _validateEmail(t, value),
                  ),
                  const SizedBox(height: 14),
                  AuthField(
                    label: t.auth.login.password,
                    fieldKey: const Key('login-password'),
                    controller: _password,
                    icon: Icons.lock_outline_rounded,
                    hintText: '••••••••••••',
                    labelAction: t.auth.login.forgot,
                    labelActionKey: const Key('login-forgot'),
                    onLabelAction: _openForgotPassword,
                    enabled: !_submitting,
                    obscureText: _obscurePassword,
                    onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) => (value == null || value.isEmpty) ? t.auth.login.passwordRequired : null,
                  ),
                  const SizedBox(height: 12),
                  AuthCheckboxRow(
                    value: _remember,
                    onChanged: _submitting ? (_) {} : (value) => setState(() => _remember = value),
                    label: t.auth.login.remember,
                    checkKey: const Key('login-remember'),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    ErrorBanner(message: _error!),
                  ],
                  const SizedBox(height: 18),
                  AuthSubmitButton(
                    buttonKey: const Key('login-submit'),
                    label: t.auth.login.submit,
                    trailingIcon: Icons.arrow_forward_rounded,
                    busy: _submitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ],
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
    return t.auth.login.emailRequired;
  }

  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return t.auth.login.emailInvalid;
  }

  return null;
}
