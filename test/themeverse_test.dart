import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heexacolor/heexacolor.dart';

void main() {
  group('ThemeVerse Generator Unit Tests', () {
    test('generates ThemeData from seed string', () {
      final theme = ThemeVerse.generate(seed: '#6750A4', style: ThemeStyle.material3);
      expect(theme, isA<ThemeData>());
      expect(theme.useMaterial3, isTrue);
    });

    test('generates Theme from Mood preset', () {
      final theme = ThemeVerse.fromMood(Mood.luxury);
      expect(theme, isA<ThemeData>());
    });

    test('generates Theme from Brand Kit name', () {
      final theme = ThemeVerse.fromBrand(name: 'Google');
      expect(theme, isA<ThemeData>());
    });

    test('exports design tokens to CSS, Tailwind, JSON, and Figma', () {
      final theme = ThemeVerse.generate(seed: '#2196F3');
      final scheme = theme.colorScheme;

      final css = TokenExporter.toCSS(scheme);
      expect(css, contains('--color-primary:'));

      final tailwind = TokenExporter.toTailwind(scheme);
      expect(tailwind, contains('module.exports'));

      final json = TokenExporter.toJSON(scheme);
      expect(json, contains('"primary":'));

      final figma = TokenExporter.toFigma(scheme);
      expect(figma, contains('"type": "color"'));
    });
  });
}
