import 'package:flutter/material.dart';

/// SeasonPal palette: forest, cream, sage, charcoal, and a restrained spice
/// accent. Tokens live here so screens never hard-code a hex value.
abstract final class AppColors {
  static const forest = Color(0xFF1E3A2A);
  static const forestDeep = Color(0xFF13251A);
  static const cream = Color(0xFFF5EFE1);
  static const creamRaised = Color(0xFFFDF9EF);
  static const sage = Color(0xFF9BAF86);
  static const sageMist = Color(0xFFE6EBDC);
  static const charcoal = Color(0xFF26261F);
  static const charcoalMuted = Color(0xFF6E6C5E);
  static const spice = Color(0xFFB45A36);
  static const line = Color(0xFFDED3BD);

  /// Elevated surfaces. Recipe and option cards sit on pure white over the
  /// cream canvas; [surfaceSunken] is the sage-tinted inset behind an icon.
  static const surfaceCard = Color(0xFFFFFFFF);
  static const surfaceSunken = Color(0xFFEDF1E4);

  /// Warm ambient shadows. Both are low-opacity slate, never neutral grey, so
  /// stacked cards read as parchment rather than UI plates.
  static const shadowSoft = Color(0x0F26261F);
  static const shadowLifted = Color(0x1F1E3A2A);

  /// Connection states; deliberately not the primary palette so the accent
  /// stays scarce.
  static const online = Color(0xFF427A54);
  static const waiting = Color(0xFFB8862F);
  static const offline = Color(0xFFA44832);
}
