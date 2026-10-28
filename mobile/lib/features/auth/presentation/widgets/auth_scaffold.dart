import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';
import 'package:seasonpal/core/theme/app_theme.dart';
import 'package:seasonpal/core/widgets/app_backdrop.dart';
import 'package:seasonpal/i18n/strings.g.dart';

/// Shared frame for the auth screens: cream page, quiet brand row, editorial
/// headline with an italic accent, and one readable column. The reset screen
/// swaps the brand row for a back button and centres its header.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.subtitle,
    required this.children,
    this.titleAccent,
    this.leading,
    this.onBack,
    this.footer,
    this.centered = false,
    this.showBrand = true,
    this.showPrivacyNote = true,
    super.key,
  });

  final String title;

  /// Rendered after [title] in Playfair italic forest ("Welcome *back*.").
  final String? titleAccent;
  final String subtitle;

  /// Optional illustration between the header row and the headline.
  final Widget? leading;

  final VoidCallback? onBack;
  final List<Widget> children;
  final Widget? footer;
  final bool centered;
  final bool showBrand;
  final bool showPrivacyNote;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final align = centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final hasHeader = onBack != null || showBrand;

    final titleStyle = theme.textTheme.displayMedium?.copyWith(
      color: AppColors.charcoal,
    );

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: align,
                    children: [
                      if (onBack != null)
                        SizedBox(
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _BackButton(onPressed: onBack!),
                          ),
                        )
                      else if (showBrand)
                        const _AuthBrandRow(),
                      if (leading != null) ...[
                        SizedBox(height: hasHeader ? 26 : 4),
                        leading!,
                      ],
                      if (hasHeader || leading != null) const SizedBox(height: 26),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: title),
                            if (titleAccent != null)
                              TextSpan(
                                text: ' $titleAccent',
                                style: titleStyle?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.forest,
                                ),
                              ),
                          ],
                        ),
                        textAlign: textAlign,
                        style: titleStyle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        textAlign: textAlign,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 26),
                      ...children,
                      if (footer != null) ...[
                        const SizedBox(height: 24),
                        footer!,
                      ],
                      if (showPrivacyNote) ...[
                        const SizedBox(height: 22),
                        // Full width so the note centres against the page, not
                        // against the left-aligned headline column.
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            t.app.privacyNote,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.charcoalMuted.withValues(
                                alpha: 0.7,
                              ),
                              letterSpacing: 0.9,
                            ),
                          ),
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

/// Forest medallion plus wordmark; the same lockup as the design exports, kept
/// local so the onboarding header keeps its own lighter mark.
class _AuthBrandRow extends StatelessWidget {
  const _AuthBrandRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.forest,
            shape: BoxShape.circle,
            boxShadow: AppShadows.card,
          ),
          child: const Icon(
            Icons.eco_rounded,
            size: 18,
            color: AppColors.creamRaised,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          'SeasonPal',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: AppColors.forest,
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return IconButton(
      key: const Key('auth-back'),
      tooltip: t.common.back,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surfaceCard,
        foregroundColor: AppColors.forest,
        side: const BorderSide(color: AppColors.line),
        minimumSize: const Size(40, 40),
        padding: EdgeInsets.zero,
      ),
      icon: const Icon(Icons.arrow_back_rounded, size: 20),
    );
  }
}
