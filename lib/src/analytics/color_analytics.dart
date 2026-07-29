import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Color Analytics & Metrics Engine.
class ColorAnalytics {
  /// Calculates relative luminance according to WCAG specifications.
  static double relativeLuminance(Color color) {
    double transform(double val) {
      return val <= 0.03928 ? val / 12.92 : math.pow((val + 0.055) / 1.055, 2.4).toDouble();
    }

    final r = transform(color.r);
    final g = transform(color.g);
    final b = transform(color.b);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculates Euclidean color distance in RGB space (0.0 to ~441.67).
  static double distanceRgb(Color c1, Color c2) {
    final dr = (c1.r - c2.r) * 255;
    final dg = (c1.g - c2.g) * 255;
    final db = (c1.b - c2.b) * 255;
    return math.sqrt(dr * dr + dg * dg + db * db);
  }

  /// Calculates Perceptual Similarity score between two colors (0.0 = completely different, 1.0 = identical).
  static double similarity(Color c1, Color c2) {
    final maxDist = math.sqrt(255 * 255 * 3);
    final dist = distanceRgb(c1, c2);
    return (1.0 - (dist / maxDist)).clamp(0.0, 1.0);
  }

  /// Evaluates color temperature in Kelvin (approximate).
  static int colorTemperature(Color color) {
    final r = color.r * 255;
    final b = color.b * 255;
    if (b == 0) return 1000;

    final ratio = r / b;
    if (ratio > 2.0) return 2700; // Warm (Incandescent)
    if (ratio > 1.4) return 4000; // Neutral (Warm White)
    if (ratio > 1.0) return 5500; // Daylight
    return 7500; // Cool / Blue sky
  }
}
