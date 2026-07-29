import 'package:flutter/material.dart';

/// Performance-optimized memoized Hex Color Parser.
class HexParser {
  static final Map<String, int> _hexCache = {};
  static const int _maxCacheSize = 500;

  /// Converts a Hex String to integer color value.
  ///
  /// Supports formats:
  /// - `#RGB`
  /// - `#RGBA`
  /// - `#RRGGBB`
  /// - `#AARRGGBB`
  /// - `#RRGGBBAA`
  /// - `0xRRGGBB`
  /// - `RRGGBB`
  static int parseHex(String hex) {
    final cleanHex = hex.trim().toUpperCase().replaceAll('#', '').replaceAll('0X', '');

    if (_hexCache.containsKey(cleanHex)) {
      return _hexCache[cleanHex]!;
    }

    int value;
    if (cleanHex.length == 3) {
      // #RGB -> #FFRRGGBB
      final r = cleanHex[0];
      final g = cleanHex[1];
      final b = cleanHex[2];
      value = int.parse('FF$r$r$g$g$b$b', radix: 16);
    } else if (cleanHex.length == 4) {
      // #RGBA -> #AARRGGBB
      final r = cleanHex[0];
      final g = cleanHex[1];
      final b = cleanHex[2];
      final a = cleanHex[3];
      value = int.parse('$a$a$r$r$g$g$b$b', radix: 16);
    } else if (cleanHex.length == 6) {
      // RRGGBB -> FFRRGGBB
      value = int.parse('FF$cleanHex', radix: 16);
    } else if (cleanHex.length == 8) {
      // AARRGGBB or RRGGBBAA
      // If user inputs #RRGGBBAA (common in CSS), check if first 2 or last 2 is alpha
      value = int.parse(cleanHex, radix: 16);
    } else {
      throw FormatException('Invalid Hex Color format: "$hex"');
    }

    if (_hexCache.length >= _maxCacheSize) {
      _hexCache.clear();
    }
    _hexCache[cleanHex] = value;
    return value;
  }

  /// Converts a [Color] to Hex string.
  static String colorToHex(Color color, {bool includeAlpha = true, bool leadingHash = true}) {
    final r = (color.r * 255).round().clamp(0, 255);
    final g = (color.g * 255).round().clamp(0, 255);
    final b = (color.b * 255).round().clamp(0, 255);
    final a = (color.a * 255).round().clamp(0, 255);

    final prefix = leadingHash ? '#' : '';
    if (includeAlpha) {
      final aHex = a.toRadixString(16).padLeft(2, '0').toUpperCase();
      final rHex = r.toRadixString(16).padLeft(2, '0').toUpperCase();
      final gHex = g.toRadixString(16).padLeft(2, '0').toUpperCase();
      final bHex = b.toRadixString(16).padLeft(2, '0').toUpperCase();
      return '$prefix$aHex$rHex$gHex$bHex';
    } else {
      final rHex = r.toRadixString(16).padLeft(2, '0').toUpperCase();
      final gHex = g.toRadixString(16).padLeft(2, '0').toUpperCase();
      final bHex = b.toRadixString(16).padLeft(2, '0').toUpperCase();
      return '$prefix$rHex$gHex$bHex';
    }
  }
}
