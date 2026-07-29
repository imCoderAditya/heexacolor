import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heexacolor/heexacolor.dart';

void main() {
  group('AccessibilityEngine Unit Tests', () {
    test('calculates contrast ratio correctly for Black and White', () {
      final ratio = AccessibilityEngine.contrastRatio(Colors.black, Colors.white);
      expect(ratio, closeTo(21.0, 0.1));
    });

    test('recommends White text for Dark background', () {
      final bestText = AccessibilityEngine.bestTextColor(Colors.black);
      expect(bestText, equals(Colors.white));
    });

    test('recommends Black text for Light background', () {
      final bestText = AccessibilityEngine.bestTextColor(Colors.white);
      expect(bestText, equals(Colors.black));
    });

    test('generates WCAG AA/AAA compliance report', () {
      final report = Colors.black.accessibilityReport(Colors.white);
      expect(report.isWcagAANormalText, isTrue);
      expect(report.isWcagAAANormalText, isTrue);
    });
  });
}
