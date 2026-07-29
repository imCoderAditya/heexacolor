import 'package:flutter/material.dart';
import 'src/parser/hex_parser.dart';

export 'src/themeverse.dart';

/// Legacy [HexColor] class retained for 100% backward compatibility.
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    return HexParser.parseHex(hexColor);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
