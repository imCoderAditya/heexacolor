import 'package:flutter/material.dart';

/// Gradient Engine for ThemeVerse.
class GradientEngine {
  /// Generates a smooth [LinearGradient] between colors.
  static LinearGradient linear({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
    );
  }

  /// Generates a [RadialGradient].
  static RadialGradient radial({
    required List<Color> colors,
    Alignment center = Alignment.center,
    double radius = 0.5,
    List<double>? stops,
  }) {
    return RadialGradient(
      colors: colors,
      center: center,
      radius: radius,
      stops: stops,
    );
  }

  /// Generates a [SweepGradient].
  static SweepGradient sweep({
    required List<Color> colors,
    Alignment center = Alignment.center,
    double startAngle = 0.0,
    double endAngle = 6.283185307179586, // 2 * pi
  }) {
    return SweepGradient(
      colors: colors,
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }

  /// Generates an Aurora borealis style multi-tone gradient.
  static LinearGradient aurora({List<Color>? colors}) {
    final palette = colors ??
        const [
          Color(0xFF00F2FE),
          Color(0xFF4FACFE),
          Color(0xFF000046),
          Color(0xFF1CB5E0),
        ];

    return LinearGradient(
      colors: palette,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Generates a Glassmorphic background gradient.
  static LinearGradient glass({Color baseColor = Colors.white, double opacity = 0.2}) {
    return LinearGradient(
      colors: [
        baseColor.withValues(alpha: opacity),
        baseColor.withValues(alpha: opacity * 0.4),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Generates a Metallic reflection gradient (Silver / Gold / Platinum).
  static LinearGradient metallic({Color? seedColor}) {
    final base = seedColor ?? const Color(0xFFD4AF37); // Gold default
    final hsl = HSLColor.fromColor(base);

    final highlight = hsl.withLightness((hsl.lightness + 0.3).clamp(0.0, 1.0)).toColor();
    final shadow = hsl.withLightness((hsl.lightness - 0.25).clamp(0.0, 1.0)).toColor();

    return LinearGradient(
      colors: [shadow, base, highlight, base, shadow],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Generates a Mesh multi-color blended gradient representation.
  static LinearGradient mesh({
    Color primary = const Color(0xFF673AB7),
    Color secondary = const Color(0xFF00BCD4),
    Color tertiary = const Color(0xFFFF4081),
  }) {
    return LinearGradient(
      colors: [primary, secondary, tertiary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
