import 'package:flutter/material.dart';

import 'package:seasonpal/core/theme/app_colors.dart';

/// Corner radii from the design system. Screens pick a step; nothing invents
/// its own radius.
abstract final class AppRadii {
  static const sm = 6.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const pill = 999.0;
}

/// The two warm ambient elevations used across the app.
abstract final class AppShadows {
  static const card = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowSoft,
      blurRadius: 20,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  static const lifted = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowLifted,
      blurRadius: 30,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];
}

/// App-wide theme: the editorial type pairing from `docs/design/DESIGN.md`
/// (Playfair Display for recipe identity, Plus Jakarta Sans for everything
/// operational), the cream/forest palette, and pill-shaped actions.
ThemeData buildAppTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.forest,
        onPrimary: AppColors.creamRaised,
        secondary: AppColors.sage,
        onSecondary: AppColors.forestDeep,
        surface: AppColors.cream,
        onSurface: AppColors.charcoal,
        outline: AppColors.line,
        error: AppColors.offline,
      );

  final base = ThemeData.light(useMaterial3: true).textTheme;

  // Line heights are expressed as multipliers because that is what Flutter's
  // `TextStyle.height` expects; the ratios come from the design's px pairs.
  TextStyle serif({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    double letterSpacing = 0,
    Color color = AppColors.forest,
  }) {
    return TextStyle(
      fontFamily: 'PlayfairDisplay',
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  TextStyle sans({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    double letterSpacing = 0,
    Color color = AppColors.charcoal,
  }) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.cream,
    fontFamily: 'PlusJakartaSans',
    textTheme: base.copyWith(
      displayLarge: serif(
        size: 40,
        lineHeight: 48,
        weight: FontWeight.w600,
        letterSpacing: -0.8,
      ),
      displayMedium: serif(
        size: 32,
        lineHeight: 40,
        weight: FontWeight.w600,
        letterSpacing: -0.6,
      ),
      headlineLarge: serif(
        size: 28,
        lineHeight: 36,
        weight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      headlineMedium: serif(
        size: 24,
        lineHeight: 32,
        weight: FontWeight.w500,
        letterSpacing: -0.3,
      ),
      headlineSmall: serif(
        size: 20,
        lineHeight: 28,
        weight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleLarge: sans(
        size: 18,
        lineHeight: 26,
        weight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      titleMedium: sans(size: 16, lineHeight: 24, weight: FontWeight.w600),
      titleSmall: sans(size: 14, lineHeight: 20, weight: FontWeight.w600),
      bodyLarge: sans(
        size: 16,
        lineHeight: 24,
        weight: FontWeight.w400,
        color: AppColors.charcoalMuted,
      ),
      bodyMedium: sans(
        size: 14,
        lineHeight: 22,
        weight: FontWeight.w400,
        color: AppColors.charcoalMuted,
      ),
      bodySmall: sans(
        size: 13,
        lineHeight: 18,
        weight: FontWeight.w400,
        color: AppColors.charcoalMuted,
      ),
      labelLarge: sans(size: 14, lineHeight: 20, weight: FontWeight.w600),
      labelMedium: sans(
        size: 12,
        lineHeight: 16,
        weight: FontWeight.w600,
        letterSpacing: 0.24,
        color: AppColors.charcoalMuted,
      ),
      labelSmall: sans(
        size: 11,
        lineHeight: 14,
        weight: FontWeight.w700,
        letterSpacing: 0.44,
        color: AppColors.charcoalMuted,
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.line, space: 1),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.forest,
      linearTrackColor: AppColors.line,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.forest,
        foregroundColor: AppColors.creamRaised,
        disabledBackgroundColor: AppColors.sageMist,
        disabledForegroundColor: AppColors.charcoalMuted.withValues(alpha: 0.7),
        minimumSize: const Size.fromHeight(54),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.forest,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        side: const BorderSide(color: AppColors.line),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.forest,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      elevation: 0,
      backgroundColor: Colors.transparent,
      indicatorColor: AppColors.sageMist,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.forest : AppColors.charcoalMuted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: 22,
          color: selected ? AppColors.forest : AppColors.charcoalMuted,
        );
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      labelStyle: const TextStyle(fontSize: 14, color: AppColors.charcoalMuted),
      floatingLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.forest,
      ),
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.charcoalMuted.withValues(alpha: 0.75),
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
      errorStyle: const TextStyle(fontSize: 12.5, color: AppColors.offline),
    ),
  );
}
