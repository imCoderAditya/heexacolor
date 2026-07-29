import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'hex_parser.dart';

/// Universal Color Parser for ThemeVerse.
///
/// Supports parsing Hex, RGB, RGBA, HSL, HSLA, HSV, CMYK, LAB, LCH, OKLAB, OKLCH,
/// CSS Color Names, Material Names, Cupertino Names, and Tailwind Colors.
class ColorParser {
  /// Primary entry point to parse any valid color string into a Flutter [Color].
  static Color parse(String source) {
    final input = source.trim().toLowerCase();

    if (input.isEmpty) {
      throw const FormatException('Color string cannot be empty.');
    }

    // 1. Hex Parsing
    if (input.startsWith('#') || input.startsWith('0x') || _isPureHex(input)) {
      return Color(HexParser.parseHex(input));
    }

    // 2. CSS Color Names
    if (_cssColors.containsKey(input)) {
      return _cssColors[input]!;
    }

    // 3. Tailwind Colors
    if (_tailwindColors.containsKey(input)) {
      return _tailwindColors[input]!;
    }

    // 4. Function Syntax Parsing: rgb(), rgba(), hsl(), hsla(), hsv(), cmyk(), lab(), oklab(), etc.
    if (input.contains('(') && input.endsWith(')')) {
      final name = input.substring(0, input.indexOf('(')).trim();
      final body = input.substring(input.indexOf('(') + 1, input.length - 1).trim();
      final args = body.split(RegExp(r'[,/\s]+')).where((s) => s.isNotEmpty).toList();

      switch (name) {
        case 'rgb':
        case 'rgba':
          return _parseRgb(args);
        case 'hsl':
        case 'hsla':
          return _parseHsl(args);
        case 'hsv':
        case 'hsva':
          return _parseHsv(args);
        case 'cmyk':
          return _parseCmyk(args);
        case 'lab':
          return _parseLab(args);
        case 'oklab':
          return _parseOklab(args);
        default:
          throw FormatException('Unsupported color function: "$name"');
      }
    }

    throw FormatException('Unable to parse color string: "$source"');
  }

  /// Safely parses a color string, returning null if invalid.
  static Color? tryParse(String source) {
    try {
      return parse(source);
    } catch (_) {
      return null;
    }
  }

  static bool _isPureHex(String str) {
    final hexRegExp = RegExp(r'^[0-9a-fA-F]{3,8}$');
    return hexRegExp.hasMatch(str);
  }

  static Color _parseRgb(List<String> args) {
    if (args.length < 3) {
      throw const FormatException('rgb requires at least 3 arguments');
    }
    final r = _parseComponent(args[0], 255);
    final g = _parseComponent(args[1], 255);
    final b = _parseComponent(args[2], 255);
    final a = args.length >= 4 ? _parseAlpha(args[3]) : 1.0;

    return Color.fromRGBO(r, g, b, a);
  }

  static Color _parseHsl(List<String> args) {
    if (args.length < 3) {
      throw const FormatException('hsl requires at least 3 arguments');
    }
    final h = double.parse(args[0].replaceAll('deg', '')) % 360;
    final s = _parsePercent(args[1]);
    final l = _parsePercent(args[2]);
    final a = args.length >= 4 ? _parseAlpha(args[3]) : 1.0;

    return hslToColor(h, s, l, a);
  }

  static Color _parseHsv(List<String> args) {
    if (args.length < 3) {
      throw const FormatException('hsv requires at least 3 arguments');
    }
    final h = double.parse(args[0].replaceAll('deg', '')) % 360;
    final s = _parsePercent(args[1]);
    final v = _parsePercent(args[2]);
    final a = args.length >= 4 ? _parseAlpha(args[3]) : 1.0;

    return HSVColor.fromAHSV(a, h, s, v).toColor();
  }

  static Color _parseCmyk(List<String> args) {
    if (args.length < 4) {
      throw const FormatException('cmyk requires 4 arguments');
    }
    final c = _parsePercent(args[0]);
    final m = _parsePercent(args[1]);
    final y = _parsePercent(args[2]);
    final k = _parsePercent(args[3]);
    final a = args.length >= 5 ? _parseAlpha(args[4]) : 1.0;

    final r = (255 * (1 - c) * (1 - k)).round().clamp(0, 255);
    final g = (255 * (1 - m) * (1 - k)).round().clamp(0, 255);
    final b = (255 * (1 - y) * (1 - k)).round().clamp(0, 255);

    return Color.fromRGBO(r, g, b, a);
  }

  static Color _parseLab(List<String> args) {
    if (args.length < 3) {
      throw const FormatException('lab requires 3 arguments');
    }
    final l = double.parse(args[0].replaceAll('%', ''));
    final aVal = double.parse(args[1]);
    final bVal = double.parse(args[2]);
    final alpha = args.length >= 4 ? _parseAlpha(args[3]) : 1.0;

    return labToColor(l, aVal, bVal, alpha);
  }

  static Color _parseOklab(List<String> args) {
    if (args.length < 3) {
      throw const FormatException('oklab requires 3 arguments');
    }
    final l = _parsePercent(args[0]);
    final aVal = double.parse(args[1]);
    final bVal = double.parse(args[2]);
    final alpha = args.length >= 4 ? _parseAlpha(args[3]) : 1.0;

    return oklabToColor(l, aVal, bVal, alpha);
  }

  static int _parseComponent(String str, int maxVal) {
    if (str.endsWith('%')) {
      final pct = double.parse(str.replaceAll('%', '')) / 100.0;
      return (pct * maxVal).round().clamp(0, maxVal);
    }
    return double.parse(str).round().clamp(0, maxVal);
  }

  static double _parsePercent(String str) {
    if (str.endsWith('%')) {
      return double.parse(str.replaceAll('%', '')) / 100.0;
    }
    final val = double.parse(str);
    return val > 1.0 ? val / 100.0 : val;
  }

  static double _parseAlpha(String str) {
    if (str.endsWith('%')) {
      return double.parse(str.replaceAll('%', '')) / 100.0;
    }
    return double.parse(str).clamp(0.0, 1.0);
  }

  /// HSL to Flutter Color
  static Color hslToColor(double h, double s, double l, [double a = 1.0]) {
    return HSLColor.fromAHSL(a, h.clamp(0.0, 360.0), s.clamp(0.0, 1.0), l.clamp(0.0, 1.0)).toColor();
  }

  /// CIELAB to Color conversion
  static Color labToColor(double l, double a, double b, [double alpha = 1.0]) {
    var y = (l + 16) / 116;
    var x = a / 500 + y;
    var z = y - b / 200;

    x = (math.pow(x, 3) > 0.008856) ? math.pow(x, 3).toDouble() : (x - 16 / 116) / 7.787;
    y = (math.pow(y, 3) > 0.008856) ? math.pow(y, 3).toDouble() : (y - 16 / 116) / 7.787;
    z = (math.pow(z, 3) > 0.008856) ? math.pow(z, 3).toDouble() : (z - 16 / 116) / 7.787;

    // D65 reference white
    x = x * 0.95047;
    y = y * 1.00000;
    z = z * 1.08883;

    var rVal = x * 3.2406 + y * -1.5372 + z * -0.4986;
    var gVal = x * -0.9689 + y * 1.8758 + z * 0.0415;
    var bVal = x * 0.0557 + y * -0.2040 + z * 1.0570;

    rVal = rVal > 0.0031308 ? 1.055 * math.pow(rVal, 1 / 2.4) - 0.055 : 12.92 * rVal;
    gVal = gVal > 0.0031308 ? 1.055 * math.pow(gVal, 1 / 2.4) - 0.055 : 12.92 * gVal;
    bVal = bVal > 0.0031308 ? 1.055 * math.pow(bVal, 1 / 2.4) - 0.055 : 12.92 * bVal;

    final rInt = (rVal * 255).round().clamp(0, 255);
    final gInt = (gVal * 255).round().clamp(0, 255);
    final bInt = (bVal * 255).round().clamp(0, 255);

    return Color.fromRGBO(rInt, gInt, bInt, alpha);
  }

  /// OKLAB to Color conversion
  static Color oklabToColor(double l, double a, double b, [double alpha = 1.0]) {
    final l_ = l + 0.3963377774 * a + 0.2158037573 * b;
    final m_ = l - 0.1055613458 * a - 0.0638541728 * b;
    final s_ = l - 0.0894841775 * a - 1.2914855480 * b;

    final lVal = l_ * l_ * l_;
    final mVal = m_ * m_ * m_;
    final sVal = s_ * s_ * s_;

    var rVal = 4.0767416621 * lVal - 3.3077115913 * mVal + 0.2309699292 * sVal;
    var gVal = -1.2684380046 * lVal + 2.6097574011 * mVal - 0.3413193965 * sVal;
    var bVal = -0.0041960863 * lVal - 0.7034186147 * mVal + 1.7076147010 * sVal;

    rVal = rVal.clamp(0.0, 1.0);
    gVal = gVal.clamp(0.0, 1.0);
    bVal = bVal.clamp(0.0, 1.0);

    return Color.fromRGBO((rVal * 255).round(), (gVal * 255).round(), (bVal * 255).round(), alpha);
  }

  // 140+ CSS Standard Colors
  static final Map<String, Color> _cssColors = {
    'aliceblue': const Color(0xFFF0F8FF),
    'antiquewhite': const Color(0xFFFAEBD7),
    'aqua': const Color(0xFF00FFFF),
    'aquamarine': const Color(0xFF7FFFD4),
    'azure': const Color(0xFFF0FFFF),
    'beige': const Color(0xFFF5F5DC),
    'bisque': const Color(0xFFFFE4C4),
    'black': const Color(0xFF000000),
    'blanchedalmond': const Color(0xFFFFEBCD),
    'blue': const Color(0xFF0000FF),
    'blueviolet': const Color(0xFF8A2BE2),
    'brown': const Color(0xFFA52A2A),
    'burlywood': const Color(0xFFDEB887),
    'cadetblue': const Color(0xFF5F9EA0),
    'chartreuse': const Color(0xFF7FFF00),
    'chocolate': const Color(0xFFD2691E),
    'coral': const Color(0xFFFF7F50),
    'cornflowerblue': const Color(0xFF6495ED),
    'cornsilk': const Color(0xFFFFF8DC),
    'crimson': const Color(0xFFDC143C),
    'cyan': const Color(0xFF00FFFF),
    'darkblue': const Color(0xFF00008B),
    'darkcyan': const Color(0xFF008B8B),
    'darkgoldenrod': const Color(0xFFB8860B),
    'darkgray': const Color(0xFFA9A9A9),
    'darkgreen': const Color(0xFF006400),
    'darkkhaki': const Color(0xFFBDB76B),
    'darkmagenta': const Color(0xFF8B008B),
    'darkolivegreen': const Color(0xFF556B2F),
    'darkorange': const Color(0xFFFF8C00),
    'darkorchid': const Color(0xFF9932CC),
    'darkred': const Color(0xFF8B0000),
    'darksalmon': const Color(0xEFE9967A),
    'darkseagreen': const Color(0xFF8FBC8F),
    'darkslateblue': const Color(0xFF483D8B),
    'darkslategray': const Color(0xFF2F4F4F),
    'darkturquoise': const Color(0xFF00CED1),
    'darkviolet': const Color(0xFF9400D3),
    'deeppink': const Color(0xFFFF1493),
    'deepskyblue': const Color(0xFF00BFFF),
    'dimgray': const Color(0xFF696969),
    'dodgerblue': const Color(0xFF1E90FF),
    'firebrick': const Color(0xFFB22222),
    'floralwhite': const Color(0xFFFFFAF0),
    'forestgreen': const Color(0xFF228B22),
    'fuchsia': const Color(0xFFFF00FF),
    'gainsboro': const Color(0xFFDCDCDC),
    'ghostwhite': const Color(0xFFF8F8FF),
    'gold': const Color(0xFFFFD700),
    'goldenrod': const Color(0xFFDAA520),
    'gray': const Color(0xFF808080),
    'green': const Color(0xFF008000),
    'greenyellow': const Color(0xFFADFF2F),
    'honeydew': const Color(0xFFF0FFF0),
    'hotpink': const Color(0xFFFF69B4),
    'indianred': const Color(0xFFCD5C5C),
    'indigo': const Color(0xFF4B0082),
    'ivory': const Color(0xFFFFFFF0),
    'khaki': const Color(0xFFF0E68C),
    'lavender': const Color(0xFFE6E6FA),
    'lavenderblush': const Color(0xFFFFF0F5),
    'lawngreen': const Color(0xFF7CFC00),
    'lemonchiffon': const Color(0xFFFFFACD),
    'lightblue': const Color(0xFFADD8E6),
    'lightcoral': const Color(0xFFF08080),
    'lightcyan': const Color(0xEFE0FFFF),
    'lightgoldenrodyellow': const Color(0xFFFAFAD2),
    'lightgray': const Color(0xFFD3D3D3),
    'lightgreen': const Color(0xFF90EE90),
    'lightpink': const Color(0xFFFFB6C1),
    'lightsalmon': const Color(0xFFFFA07A),
    'lightseagreen': const Color(0xFF20B2AA),
    'lightskyblue': const Color(0xFF87CEFA),
    'lightslategray': const Color(0xFF778899),
    'lightsteelblue': const Color(0xFFB0C4DE),
    'lightyellow': const Color(0xFFFFFFE0),
    'lime': const Color(0xFF00FF00),
    'limegreen': const Color(0xFF32CD32),
    'linen': const Color(0xFFFAF0E6),
    'magenta': const Color(0xFFFF00FF),
    'maroon': const Color(0xFF800000),
    'mediumaquamarine': const Color(0xFF66CDAA),
    'mediumblue': const Color(0xFF0000CD),
    'mediumorchid': const Color(0xFFBA55D3),
    'mediumpurple': const Color(0xFF9370DB),
    'mediumseagreen': const Color(0xFF3CB371),
    'mediumslateblue': const Color(0xFF7B68EE),
    'mediumspringgreen': const Color(0xFF00FA9A),
    'mediumturquoise': const Color(0xFF48D1CC),
    'mediumvioletred': const Color(0xFFC71585),
    'midnightblue': const Color(0xFF191970),
    'mintcream': const Color(0xFFF5FFFA),
    'mistyrose': const Color(0xFFFFE4E1),
    'moccasin': const Color(0xFFFFE4B5),
    'navajowhite': const Color(0xFFFFDEAD),
    'navy': const Color(0xFF000080),
    'oldlace': const Color(0xFFFDF5E6),
    'olive': const Color(0xFF808000),
    'olivedrab': const Color(0xFF6B8E23),
    'orange': const Color(0xFFFFA500),
    'orangered': const Color(0xFFFF4500),
    'orchid': const Color(0xFFDA70D6),
    'palegoldenrod': const Color(0xFFEEE8AA),
    'palegreen': const Color(0xFF98FB98),
    'paleturquoise': const Color(0xFFAFEEEE),
    'palevioletred': const Color(0xFFDB7093),
    'papayawhip': const Color(0xFFFFEFD5),
    'peachpuff': const Color(0xFFFFDAB9),
    'peru': const Color(0xFFCD853F),
    'pink': const Color(0xFFFFC0CB),
    'plum': const Color(0xFFDDA0DD),
    'powderblue': const Color(0xFFB0E0E6),
    'purple': const Color(0xFF800080),
    'rebeccapurple': const Color(0xFF663399),
    'red': const Color(0xFFFF0000),
    'rosybrown': const Color(0xFFBC8F8F),
    'royalblue': const Color(0xFF4169E1),
    'saddlebrown': const Color(0xFF8B4513),
    'salmon': const Color(0xFFFA8072),
    'sandybrown': const Color(0xFFF4A460),
    'seagreen': const Color(0xFF2E8B57),
    'seashell': const Color(0xFFFFF5EE),
    'sienna': const Color(0xFFA0522D),
    'silver': const Color(0xFFC0C0C0),
    'skyblue': const Color(0xFF87CEEB),
    'slateblue': const Color(0xFF6A5ACD),
    'slategray': const Color(0xFF708090),
    'snow': const Color(0xFFFFFAFA),
    'springgreen': const Color(0xFF00FF7F),
    'steelblue': const Color(0xFF4682B4),
    'tan': const Color(0xFFD2B48C),
    'teal': const Color(0xFF008080),
    'thistle': const Color(0xFFD8BFD8),
    'tomato': const Color(0xFFFF6347),
    'turquoise': const Color(0xFF40E0D0),
    'violet': const Color(0xFFEE82EE),
    'wheat': const Color(0xFFF5DEB3),
    'white': const Color(0xFFFFFFFF),
    'whitesmoke': const Color(0xFFF5F5F5),
    'yellow': const Color(0xFFFFFF00),
    'yellowgreen': const Color(0xFF9ACD32),
  };

  // Tailwind standard color palette map
  static final Map<String, Color> _tailwindColors = {
    'slate-50': const Color(0xFFF8FAFC),
    'slate-100': const Color(0xFFF1F5F9),
    'slate-500': const Color(0xFF64748B),
    'slate-900': const Color(0xFF0F172A),
    'gray-500': const Color(0xFF6B7280),
    'gray-900': const Color(0xFF111827),
    'red-500': const Color(0xFFEF4444),
    'red-600': const Color(0xFFDC2626),
    'orange-500': const Color(0xFFF97316),
    'amber-500': const Color(0xFFF59E0B),
    'yellow-500': const Color(0xFFEAB308),
    'green-500': const Color(0xFF22C55E),
    'emerald-500': const Color(0xFF10B981),
    'teal-500': const Color(0xFF14B8A6),
    'cyan-500': const Color(0xFF06B6D4),
    'sky-500': const Color(0xFF0EA5E9),
    'blue-500': const Color(0xFF3B82F6),
    'blue-600': const Color(0xFF2563EB),
    'indigo-500': const Color(0xFF6366F1),
    'violet-500': const Color(0xFF8B5CF6),
    'purple-500': const Color(0xFFA855F7),
    'fuchsia-500': const Color(0xFFD946EF),
    'pink-500': const Color(0xFFEC4899),
    'rose-500': const Color(0xFFF43F5E),
  };
}
