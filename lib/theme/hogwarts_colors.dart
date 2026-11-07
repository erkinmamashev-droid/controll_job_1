import 'package:flutter/material.dart';

class HogwartsColors {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color get page => const Color(0xFFF5F1E8);
  static Color get pageDark => const Color(0xFF121A16);
  static Color get surface => const Color(0xFFFFFCF5);
  static Color get surfaceDark => const Color(0xFF202B24);
  static Color get input => const Color(0xFFFFFFFF);
  static Color get inputDark => const Color(0xFF29362E);
  static Color get border => const Color(0xFFE9E0D0);
  static Color get borderDark => const Color(0xFF39483E);
  static Color get text => const Color(0xFF263B30);
  static Color get textDark => const Color(0xFFE7EBDD);
  static Color get secondaryText => const Color(0xFF625C50);
  static Color get secondaryTextDark => const Color(0xFFB4BDAF);
  static Color get mutedText => const Color(0xFF827761);
  static Color get mutedTextDark => const Color(0xFFA0AA9F);
  static Color get iconBackground => const Color(0xFFE9EFE9);
  static Color get iconBackgroundDark => const Color(0xFF34463A);

  static Color pageFor(BuildContext context) =>
      isDark(context) ? pageDark : page;

  static Color surfaceFor(BuildContext context) =>
      isDark(context) ? surfaceDark : surface;

  static Color inputFor(BuildContext context) =>
      isDark(context) ? inputDark : input;

  static Color borderFor(BuildContext context) =>
      isDark(context) ? borderDark : border;

  static Color textFor(BuildContext context) =>
      isDark(context) ? textDark : text;

  static Color secondaryTextFor(BuildContext context) =>
      isDark(context) ? secondaryTextDark : secondaryText;

  static Color mutedTextFor(BuildContext context) =>
      isDark(context) ? mutedTextDark : mutedText;

  static Color iconBackgroundFor(BuildContext context) =>
      isDark(context) ? iconBackgroundDark : iconBackground;
}
