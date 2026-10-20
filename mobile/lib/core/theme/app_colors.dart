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

  /// Connection states; deliberately not the primary palette so the accent
  /// stays scarce.
  static const online = Color(0xFF427A54);
  static const waiting = Color(0xFFB8862F);
  static const offline = Color(0xFFA44832);
}
