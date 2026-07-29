import 'package:flutter_test/flutter_test.dart';
import 'package:heexacolor/heexacolor.dart';

void main() {
  test('heexacolor exports ThemeVerse engine and HexColor', () {
    expect(HexColor('#FF5722'), isNotNull);
    expect(ThemeVerse.generate(seed: '#6750A4'), isNotNull);
  });
}
