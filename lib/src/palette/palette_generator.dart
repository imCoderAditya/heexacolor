import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Palette & Color Harmonies Generator Engine.
class PaletteGenerator {
  /// Generates a complementary color (180° on color wheel).
  static Color complementary(Color color) {
    final hsl = HSLColor.fromColor(color);
    final newHue = (hsl.hue + 180.0) % 360.0;
    return hsl.withHue(newHue).toColor();
  }

  /// Generates analogous colors (±30° on color wheel).
  static List<Color> analogous(Color color, {double angle = 30.0}) {
    final hsl = HSLColor.fromColor(color);
    final h1 = (hsl.hue + angle) % 360.0;
    final h2 = (hsl.hue - angle + 360.0) % 360.0;
    return [
      hsl.withHue(h2).toColor(),
      color,
      hsl.withHue(h1).toColor(),
    ];
  }

  /// Generates triadic colors (+120°, +240° on color wheel).
  static List<Color> triadic(Color color) {
    final hsl = HSLColor.fromColor(color);
    final h1 = (hsl.hue + 120.0) % 360.0;
    final h2 = (hsl.hue + 240.0) % 360.0;
    return [
      color,
      hsl.withHue(h1).toColor(),
      hsl.withHue(h2).toColor(),
    ];
  }

  /// Generates tetradic colors (+90°, +180°, +270° on color wheel).
  static List<Color> tetradic(Color color) {
    final hsl = HSLColor.fromColor(color);
    return [
      color,
      hsl.withHue((hsl.hue + 90.0) % 360.0).toColor(),
      hsl.withHue((hsl.hue + 180.0) % 360.0).toColor(),
      hsl.withHue((hsl.hue + 270.0) % 360.0).toColor(),
    ];
  }

  /// Generates split-complementary colors (+150°, +210° on color wheel).
  static List<Color> splitComplementary(Color color) {
    final hsl = HSLColor.fromColor(color);
    final h1 = (hsl.hue + 150.0) % 360.0;
    final h2 = (hsl.hue + 210.0) % 360.0;
    return [
      color,
      hsl.withHue(h1).toColor(),
      hsl.withHue(h2).toColor(),
    ];
  }

  /// Generates a monochromatic palette with varying lightness steps.
  static List<Color> monochromatic(Color color, {int count = 5}) {
    final hsl = HSLColor.fromColor(color);
    final step = 0.8 / count;
    final list = <Color>[];
    for (int i = 1; i <= count; i++) {
      final l = (0.1 + i * step).clamp(0.05, 0.95);
      list.add(hsl.withLightness(l).toColor());
    }
    return list;
  }

  /// Generates tints (mixed with White).
  static List<Color> tints(Color color, {int count = 5}) {
    final list = <Color>[];
    for (int i = 1; i <= count; i++) {
      final factor = i / (count + 1);
      list.add(Color.lerp(color, Colors.white, factor)!);
    }
    return list;
  }

  /// Generates shades (mixed with Black).
  static List<Color> shades(Color color, {int count = 5}) {
    final list = <Color>[];
    for (int i = 1; i <= count; i++) {
      final factor = i / (count + 1);
      list.add(Color.lerp(color, Colors.black, factor)!);
    }
    return list;
  }

  /// Generates tones (mixed with Gray).
  static List<Color> tones(Color color, {int count = 5}) {
    final list = <Color>[];
    for (int i = 1; i <= count; i++) {
      final factor = i / (count + 1);
      list.add(Color.lerp(color, const Color(0xFF808080), factor)!);
    }
    return list;
  }

  /// Random Color Generator according to style presets.
  static Color random({RandomColorStyle style = RandomColorStyle.vibrant}) {
    final rand = math.Random();
    switch (style) {
      case RandomColorStyle.neon:
        final h = rand.nextDouble() * 360.0;
        return HSLColor.fromAHSL(1.0, h, 1.0, 0.5).toColor();
      case RandomColorStyle.pastel:
        final h = rand.nextDouble() * 360.0;
        return HSLColor.fromAHSL(1.0, h, 0.7, 0.85).toColor();
      case RandomColorStyle.luxury:
        final hues = [45.0, 50.0, 210.0, 280.0, 0.0];
        final h = hues[rand.nextInt(hues.length)];
        return HSLColor.fromAHSL(1.0, h, 0.6, 0.35).toColor();
      case RandomColorStyle.dark:
        final h = rand.nextDouble() * 360.0;
        return HSLColor.fromAHSL(1.0, h, 0.5, 0.15).toColor();
      case RandomColorStyle.minimal:
        final l = 0.2 + rand.nextDouble() * 0.6;
        return HSLColor.fromAHSL(1.0, 0.0, 0.0, l).toColor();
      case RandomColorStyle.vibrant:
        final h = rand.nextDouble() * 360.0;
        return HSLColor.fromAHSL(1.0, h, 0.85, 0.55).toColor();
    }
  }
}

/// Presets for Random Color Generation.
enum RandomColorStyle {
  neon,
  pastel,
  luxury,
  dark,
  minimal,
  vibrant,
}
