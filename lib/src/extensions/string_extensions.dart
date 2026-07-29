import 'package:flutter/material.dart';
import '../parser/color_parser.dart';
import '../themes/theme_style.dart';
import '../themes/themeverse_generator.dart';

/// Extension methods for [String].
extension ThemeVerseStringExtensions on String {
  /// Converts string (Hex, RGB, HSL, CSS Name, Tailwind) into a Flutter [Color].
  Color toColor() {
    return ColorParser.parse(this);
  }

  /// Tries to parse string into a Flutter [Color], returning null on failure.
  Color? tryToColor() {
    return ColorParser.tryParse(this);
  }

  /// Generates a full Flutter [ThemeData] using this string as a seed color.
  ThemeData toTheme({
    ThemeStyle style = ThemeStyle.material3,
    Brightness brightness = Brightness.light,
  }) {
    return ThemeVerse.generate(
      seed: this,
      style: style,
      brightness: brightness,
    );
  }
}
