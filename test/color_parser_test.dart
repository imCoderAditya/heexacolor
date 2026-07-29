import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heexacolor/heexacolor.dart';

void main() {
  group('ColorParser Unit Tests', () {
    test('parses RGB and RGBA function syntax', () {
      final c1 = ColorParser.parse('rgb(255, 0, 0)');
      expect(c1, equals(const Color(0xFFFF0000)));

      final c2 = ColorParser.parse('rgba(0, 255, 0, 0.5)');
      expect((c2.g * 255).round(), equals(255));
      expect((c2.a * 100).round(), equals(50));
    });

    test('parses HSL function syntax', () {
      final c = ColorParser.parse('hsl(120, 100%, 50%)');
      expect((c.g * 255).round(), equals(255));
      expect((c.r * 255).round(), equals(0));
    });

    test('parses CSS Color Names', () {
      final c1 = 'royalblue'.toColor();
      expect(c1, equals(const Color(0xFF4169E1)));

      final c2 = 'coral'.toColor();
      expect(c2, equals(const Color(0xFFFF7F50)));
    });

    test('parses Tailwind Colors', () {
      final c = 'blue-500'.toColor();
      expect(c, equals(const Color(0xFF3B82F6)));
    });

    test('String extension toTheme() works', () {
      final theme = '#6750A4'.toTheme(style: ThemeStyle.material3);
      expect(theme.colorScheme.primary, isNotNull);
    });
  });
}
