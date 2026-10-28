import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Primary auth action. Takes the whole width, swaps its label for a spinner
/// while the request is in flight, and can carry an icon on either side.
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.leadingIcon,
    this.trailingIcon,
    this.buttonKey,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: buttonKey,
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 18),
                  const SizedBox(width: 9),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 9),
                  Icon(trailingIcon, size: 18),
                ],
              ],
            ),
    );
  }
}

/// "New here? Create an account" line that closes the auth screens.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    required this.prompt,
    required this.action,
    required this.onPressed,
    this.actionKey,
    this.showArrow = false,
    super.key,
  });

  final String prompt;
  final String action;
  final VoidCallback? onPressed;
  final Key? actionKey;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      children: [
        Text(prompt, style: theme.textTheme.bodyMedium),
        TextButton(
          key: actionKey,
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.forest,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  action,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.sage,
                    decorationThickness: 1.4,
                  ),
                ),
              ),
              if (showArrow) ...[
                const SizedBox(width: 3),
                const Icon(Icons.north_east_rounded, size: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Hairline divider with a centred tracked label.
class AuthDivider extends StatelessWidget {
  const AuthDivider({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Expanded(child: Divider(height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.charcoalMuted.withValues(alpha: 0.8),
              letterSpacing: 1.1,
            ),
          ),
        ),
        const Expanded(child: Divider(height: 1)),
      ],
    );
  }
}

/// Apple and Google entries from the design. The API has no social sign-in yet,
/// so they are deliberately disabled; the caption below says so.
class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                icon: Icons.apple,
                label: t.auth.social.apple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SocialButton(
                icon: Icons.g_mobiledata_rounded,
                label: t.auth.social.google,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          t.auth.social.planned,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.charcoalMuted.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surfaceCard,
        foregroundColor: AppColors.charcoal,
        disabledBackgroundColor: AppColors.surfaceCard,
        disabledForegroundColor: AppColors.charcoalMuted.withValues(alpha: 0.65),
        side: const BorderSide(color: AppColors.line),
        minimumSize: const Size(0, 50),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: icon == Icons.g_mobiledata_rounded ? 24 : 19),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Checkbox used for "Keep me signed in" and the terms gate. The whole row is
/// the tap target; the box is drawn by hand so it can fill forest like the
/// exported design instead of using the Material tint.
class AuthCheckboxRow extends StatelessWidget {
  const AuthCheckboxRow({
    required this.value,
    required this.onChanged,
    required this.label,
    this.checkKey,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final Key? checkKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      checked: value,
      label: label,
      onTap: () => onChanged(!value),
      excludeSemantics: true,
      child: InkWell(
        key: checkKey,
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: value ? AppColors.forest : AppColors.surfaceSunken,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                    border: Border.all(
                      color: value ? AppColors.forest : AppColors.line,
                      width: 1.4,
                    ),
                  ),
                  child: value
                      ? const Icon(
                          Icons.check_rounded,
                          size: 15,
                          color: AppColors.creamRaised,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.charcoal,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
