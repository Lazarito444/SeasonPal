import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App-wide theme. Stage 0 keeps this intentionally small — type scale, color
/// scheme, and button shape — and Stage 4 extends it into the full design
/// system (recipe cards, chips, detail layouts).
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

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.cream,
    textTheme: base.copyWith(
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 44,
        height: 1.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.4,
        color: AppColors.forest,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 36,
        height: 1.08,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.1,
        color: AppColors.forest,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
        color: AppColors.forest,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppColors.charcoal,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 17,
        height: 1.5,
        color: AppColors.charcoalMuted,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 15,
        height: 1.45,
        color: AppColors.charcoalMuted,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
        color: AppColors.charcoalMuted,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.forest,
        foregroundColor: AppColors.creamRaised,
        disabledBackgroundColor: AppColors.sageMist,
        disabledForegroundColor: AppColors.charcoalMuted,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.forest,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.creamRaised,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      labelStyle: const TextStyle(fontSize: 15, color: AppColors.charcoalMuted),
      floatingLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.forest,
      ),
      hintStyle: TextStyle(
        fontSize: 15,
        color: AppColors.charcoalMuted.withValues(alpha: 0.75),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.forest, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.offline),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.offline, width: 1.6),
      ),
      errorStyle: const TextStyle(fontSize: 12.5, color: AppColors.offline),
    ),
  );
}
