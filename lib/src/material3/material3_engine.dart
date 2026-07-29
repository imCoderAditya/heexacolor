import 'package:flutter/material.dart';

/// Represents a Material 3 Tonal Palette with 13 standard tone steps.
class MaterialTonalPalette {
  final Color tone100;
  final Color tone99;
  final Color tone95;
  final Color tone90;
  final Color tone80;
  final Color tone70;
  final Color tone60;
  final Color tone50;
  final Color tone40;
  final Color tone30;
  final Color tone20;
  final Color tone10;
  final Color tone0;

  const MaterialTonalPalette({
    required this.tone100,
    required this.tone99,
    required this.tone95,
    required this.tone90,
    required this.tone80,
    required this.tone70,
    required this.tone60,
    required this.tone50,
    required this.tone40,
    required this.tone30,
    required this.tone20,
    required this.tone10,
    required this.tone0,
  });

  /// Get color by tone integer (0-100).
  Color getTone(int tone) {
    if (tone >= 100) return tone100;
    if (tone >= 99) return tone99;
    if (tone >= 95) return tone95;
    if (tone >= 90) return tone90;
    if (tone >= 80) return tone80;
    if (tone >= 70) return tone70;
    if (tone >= 60) return tone60;
    if (tone >= 50) return tone50;
    if (tone >= 40) return tone40;
    if (tone >= 30) return tone30;
    if (tone >= 20) return tone20;
    if (tone >= 10) return tone10;
    return tone0;
  }
}

/// Material 3 & Material You Dynamic Color Engine.
class Material3Engine {
  /// Generates a 13-tone Material 3 Tonal Palette from a seed color.
  static MaterialTonalPalette generateTonalPalette(Color seed) {
    final hsl = HSLColor.fromColor(seed);

    Color makeTone(double lightness) {
      return hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
    }

    return MaterialTonalPalette(
      tone100: const Color(0xFFFFFFFF),
      tone99: makeTone(0.99),
      tone95: makeTone(0.95),
      tone90: makeTone(0.90),
      tone80: makeTone(0.80),
      tone70: makeTone(0.70),
      tone60: makeTone(0.60),
      tone50: makeTone(0.50),
      tone40: makeTone(0.40),
      tone30: makeTone(0.30),
      tone20: makeTone(0.20),
      tone10: makeTone(0.10),
      tone0: const Color(0xFF000000),
    );
  }

  /// Generates a full Material 3 [ColorScheme] from a seed color.
  static ColorScheme generateColorScheme(Color seed, {Brightness brightness = Brightness.light}) {
    return ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
  }
}
