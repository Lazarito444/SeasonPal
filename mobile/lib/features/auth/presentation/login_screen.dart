import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/api_error_messages.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../i18n/strings.g.dart';
import 'auth_controller.dart';
import 'widgets/auth_scaffold.dart';

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
          .login(email: _email.text.trim(), password: _password.text);
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
      title: t.auth.login.title,
      subtitle: t.auth.login.subtitle,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              t.auth.login.newHere,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: _submitting
                ? null
                : () => context.goNamed(AppRoutes.registerName),
            child: Text(t.auth.login.createAccount),
          ),
        ],
      ),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('login-email'),
                controller: _email,
                enabled: !_submitting,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                decoration: InputDecoration(labelText: t.auth.login.email),
                validator: (value) => _validateEmail(t, value),
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('login-password'),
                controller: _password,
                enabled: !_submitting,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: t.auth.login.password,
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword
                        ? t.common.showPassword
                        : t.common.hidePassword,
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? t.auth.login.passwordRequired
                    : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 18),
                ErrorBanner(message: _error!),
              ],
              const SizedBox(height: 22),
              FilledButton(
                key: const Key('login-submit'),
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(t.auth.login.submit),
              ),
            ],
          ),
        ),
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
