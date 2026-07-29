import 'package:flutter/material.dart';
import '../parser/hex_parser.dart';
import '../accessibility/accessibility_engine.dart';
import '../smart_color/smart_color_engine.dart';
import '../palette/palette_generator.dart';

/// Extension methods for Flutter [Color].
extension ThemeVerseColorExtensions on Color {
  /// Converts [Color] to Hex String.
  String toHex({bool includeAlpha = true, bool leadingHash = true}) {
    return HexParser.colorToHex(this, includeAlpha: includeAlpha, leadingHash: leadingHash);
  }

  /// Converts [Color] to `rgb(r, g, b)` CSS string.
  String toRgb() {
    final red = (r * 255).round().clamp(0, 255);
    final green = (g * 255).round().clamp(0, 255);
    final blue = (b * 255).round().clamp(0, 255);
    return 'rgb($red, $green, $blue)';
  }

  /// Converts [Color] to `rgba(r, g, b, a)` CSS string.
  String toRgba() {
    final red = (r * 255).round().clamp(0, 255);
    final green = (g * 255).round().clamp(0, 255);
    final blue = (b * 255).round().clamp(0, 255);
    final alphaStr = a.toStringAsFixed(2);
    return 'rgba($red, $green, $blue, $alphaStr)';
  }

  /// Generates a full WCAG accessibility report against a background color.
  AccessibilityReport accessibilityReport([Color background = Colors.white]) {
    return AccessibilityEngine.generateReport(this, background);
  }

  /// Derives hover state color.
  Color get hoverColor => SmartColorEngine.hoverColor(this);

  /// Derives pressed state color.
  Color get pressedColor => SmartColorEngine.pressedColor(this);

  /// Derives disabled state color.
  Color get disabledColor => SmartColorEngine.disabledColor(this);

  /// Derives selected state color.
  Color get selectedColor => SmartColorEngine.selectedColor(this);

  /// Derives border color.
  Color get borderColor => SmartColorEngine.borderColor(this);

  /// Derives soft shadow color.
  Color get shadowColor => SmartColorEngine.shadowColor(this);

  /// Derives ripple effect color.
  Color get rippleColor => SmartColorEngine.rippleColor(this);

  /// Derives divider color.
  Color get dividerColor => SmartColorEngine.dividerColor(this);

  /// Derives complementary color.
  Color get complementary => PaletteGenerator.complementary(this);

  /// Derives analogous palette.
  List<Color> analogous({double angle = 30.0}) => PaletteGenerator.analogous(this, angle: angle);

  /// Derives triadic palette.
  List<Color> triadic() => PaletteGenerator.triadic(this);

  /// Derives tetradic palette.
  List<Color> tetradic() => PaletteGenerator.tetradic(this);

  /// Derives tints (lighter steps).
  List<Color> tints({int count = 5}) => PaletteGenerator.tints(this, count: count);

  /// Derives shades (darker steps).
  List<Color> shades({int count = 5}) => PaletteGenerator.shades(this, count: count);

  /// Derives tones (gray steps).
  List<Color> tones({int count = 5}) => PaletteGenerator.tones(this, count: count);
}
