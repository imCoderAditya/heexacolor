import 'package:flutter/material.dart';
import '../analytics/color_analytics.dart';

/// Detailed Accessibility Compliance Report.
class AccessibilityReport {
  final Color foreground;
  final Color background;
  final double contrastRatio;
  final bool isWcagAANormalText;
  final bool isWcagAALargeText;
  final bool isWcagAAANormalText;
  final bool isWcagAAALargeText;
  final double apcaScore;
  final Color recommendedTextColor;

  const AccessibilityReport({
    required this.foreground,
    required this.background,
    required this.contrastRatio,
    required this.isWcagAANormalText,
    required this.isWcagAALargeText,
    required this.isWcagAAANormalText,
    required this.isWcagAAALargeText,
    required this.apcaScore,
    required this.recommendedTextColor,
  });

  @override
  String toString() {
    return 'AccessibilityReport(contrastRatio: ${contrastRatio.toStringAsFixed(2)}, WCAG AA: $isWcagAANormalText, WCAG AAA: $isWcagAAANormalText, APCA: ${apcaScore.toStringAsFixed(1)})';
  }
}

/// Accessibility & Contrast Calculation Engine.
class AccessibilityEngine {
  /// Calculates WCAG 2.1 Contrast Ratio between two colors (1.0 to 21.0).
  static double contrastRatio(Color foreground, Color background) {
    final l1 = ColorAnalytics.relativeLuminance(foreground);
    final l2 = ColorAnalytics.relativeLuminance(background);

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Evaluates APCA Contrast Score (approximate lightweight model).
  static double apcaContrast(Color text, Color background) {
    final txtLum = ColorAnalytics.relativeLuminance(text);
    final bgLum = ColorAnalytics.relativeLuminance(background);

    if ((txtLum - bgLum).abs() < 0.0005) return 0.0;

    double score;
    if (bgLum > txtLum) {
      // Dark text on light background
      score = (bgLum.clamp(0.0, 1.0) - txtLum.clamp(0.0, 1.0)) * 100.0;
    } else {
      // Light text on dark background
      score = (txtLum.clamp(0.0, 1.0) - bgLum.clamp(0.0, 1.0)) * -100.0;
    }
    return score;
  }

  /// Determines the best high-contrast text color (Black or White) for a background color.
  static Color bestTextColor(Color background) {
    final whiteContrast = contrastRatio(Colors.white, background);
    final blackContrast = contrastRatio(Colors.black, background);

    return whiteContrast >= blackContrast ? Colors.white : Colors.black;
  }

  /// Generates a full AccessibilityReport for a foreground/background pair.
  static AccessibilityReport generateReport(Color foreground, Color background) {
    final ratio = contrastRatio(foreground, background);
    final apca = apcaContrast(foreground, background);
    final bestText = bestTextColor(background);

    return AccessibilityReport(
      foreground: foreground,
      background: background,
      contrastRatio: ratio,
      isWcagAANormalText: ratio >= 4.5,
      isWcagAALargeText: ratio >= 3.0,
      isWcagAAANormalText: ratio >= 7.0,
      isWcagAAALargeText: ratio >= 4.5,
      apcaScore: apca,
      recommendedTextColor: bestText,
    );
  }
}
