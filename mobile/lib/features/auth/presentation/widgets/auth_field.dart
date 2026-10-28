import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Surface the field sits on. Login and registration put fields inside or over
/// the cream canvas and use the sage-tinted inset; the reset screen floats a
/// white field directly on the page.
enum AuthFieldTone { tinted, raised }

/// Labelled form field for the auth screens: tracked uppercase label, leading
/// icon, optional trailing label action ("Forgot your password?"), optional
/// helper line, and a focus state that lifts the fill to white.
///
/// The field keeps its own [FocusNode] only to repaint the fill and the icon
/// when focus changes; validation stays with the enclosing [Form].
class AuthField extends StatefulWidget {
  const AuthField({
    required this.label,
    required this.controller,
    required this.icon,
    this.fieldKey,
    this.hintText,
    this.labelHint,
    this.labelAction,
    this.onLabelAction,
    this.labelActionKey,
    this.helperText,
    this.helperIcon,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.obscureText = false,
    this.onToggleObscure,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
    this.tone = AuthFieldTone.tinted,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;

  /// Key placed on the [TextFormField] so tests can address the input directly.
  final Key? fieldKey;

  final String? hintText;

  /// Small, non-interactive note at the end of the label row ("Required",
  /// "Min. 8 characters").
  final String? labelHint;

  /// Short interactive link at the end of the label row.
  final String? labelAction;
  final VoidCallback? onLabelAction;
  final Key? labelActionKey;

  final String? helperText;
  final IconData? helperIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final bool autocorrect;

  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final AuthFieldTone tone;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late final FocusNode _focusNode = FocusNode()..addListener(_handleFocusChange);

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final focused = _focusNode.hasFocus;
    final restingFill = widget.tone == AuthFieldTone.raised ? AppColors.surfaceCard : AppColors.surfaceSunken;

    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: AppColors.charcoalMuted,
      letterSpacing: 1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.label.toUpperCase(), style: labelStyle)),
            if (widget.labelAction != null)
              TextButton(
                key: widget.labelActionKey,
                onPressed: widget.enabled ? widget.onLabelAction : null,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.spice,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(widget.labelAction!),
              )
            else if (widget.labelHint != null)
              Flexible(
                child: Text(
                  widget.labelHint!,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: AppColors.charcoalMuted.withValues(alpha: 0.85),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          key: widget.fieldKey,
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          textCapitalization: widget.textCapitalization,
          autocorrect: widget.autocorrect,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            height: 1.35,
            color: AppColors.charcoal,
          ),
          cursorColor: AppColors.forest,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: !widget.enabled
                ? restingFill.withValues(alpha: 0.6)
                : focused
                ? AppColors.surfaceCard
                : restingFill,
            contentPadding: const EdgeInsets.fromLTRB(0, 16, 10, 16),
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 14, end: 10),
              child: Icon(
                widget.icon,
                size: 20,
                color: focused ? AppColors.forest : AppColors.charcoalMuted.withValues(alpha: 0.8),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            suffixIcon: widget.onToggleObscure == null
                ? null
                : IconButton(
                    tooltip: widget.obscureText ? t.common.showPassword : t.common.hidePassword,
                    onPressed: widget.enabled ? widget.onToggleObscure : null,
                    icon: Icon(
                      widget.obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    color: AppColors.charcoalMuted,
                    visualDensity: VisualDensity.compact,
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              borderSide: const BorderSide(color: AppColors.forest, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              borderSide: const BorderSide(color: AppColors.offline),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              borderSide: const BorderSide(color: AppColors.offline, width: 1.6),
            ),
            errorStyle: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12.5,
              color: AppColors.offline,
            ),
          ),
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.helperIcon ?? Icons.info_outline_rounded,
                size: 15,
                color: AppColors.forest.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(widget.helperText!, style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
