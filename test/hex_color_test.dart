import 'package:flutter_test/flutter_test.dart';
import 'package:heexacolor/heexacolor.dart';

void main() {
  group('HexColor Backward Compatibility Tests', () {
    test('parses 6-digit hex string with hash', () {
      final color = HexColor('#FF5722');
      expect(color.r * 255, closeTo(255, 1));
      expect(color.g * 255, closeTo(87, 1));
      expect(color.b * 255, closeTo(34, 1));
    });

    test('parses 6-digit hex string without hash', () {
      final color = HexColor('4CAF50');
      expect(color.g * 255, closeTo(175, 1));
    });

    test('parses 8-digit hex string with alpha', () {
      final color = HexColor('#80FF5722');
      expect(color.a * 255, closeTo(128, 1));
    });
  });
}
