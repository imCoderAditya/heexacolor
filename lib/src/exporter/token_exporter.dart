import 'dart:convert';
import 'package:flutter/material.dart';
import '../parser/hex_parser.dart';

/// Exports Theme & Color Design Tokens to CSS, Tailwind, JSON, and Figma format.
class TokenExporter {
  /// Exports a [ColorScheme] to JSON format.
  static String toJSON(ColorScheme scheme) {
    final map = _colorSchemeToMap(scheme);
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  /// Exports a [ColorScheme] to CSS Custom Properties (Variables).
  static String toCSS(ColorScheme scheme, {String selector = ':root'}) {
    final map = _colorSchemeToMap(scheme);
    final buffer = StringBuffer();
    buffer.writeln('$selector {');
    map.forEach((key, hex) {
      final cssKey = _kebabCase(key);
      buffer.writeln('  --color-$cssKey: $hex;');
    });
    buffer.writeln('}');
    return buffer.toString();
  }

  /// Exports a [ColorScheme] to Tailwind CSS Config format.
  static String toTailwind(ColorScheme scheme) {
    final map = _colorSchemeToMap(scheme);
    final buffer = StringBuffer();
    buffer.writeln('module.exports = {');
    buffer.writeln('  theme: {');
    buffer.writeln('    extend: {');
    buffer.writeln('      colors: {');
    map.forEach((key, hex) {
      final camelKey = _camelCase(key);
      buffer.writeln('        \'$camelKey\': \'$hex\',');
    });
    buffer.writeln('      }');
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln('};');
    return buffer.toString();
  }

  /// Exports a [ColorScheme] to Figma Tokens JSON format.
  static String toFigma(ColorScheme scheme) {
    final map = _colorSchemeToMap(scheme);
    final figmaTokens = <String, Map<String, String>>{};

    map.forEach((key, hex) {
      figmaTokens[key] = {
        'value': hex,
        'type': 'color',
      };
    });

    return const JsonEncoder.withIndent('  ').convert(figmaTokens);
  }

  static Map<String, String> _colorSchemeToMap(ColorScheme scheme) {
    return {
      'primary': HexParser.colorToHex(scheme.primary),
      'onPrimary': HexParser.colorToHex(scheme.onPrimary),
      'primaryContainer': HexParser.colorToHex(scheme.primaryContainer),
      'onPrimaryContainer': HexParser.colorToHex(scheme.onPrimaryContainer),
      'secondary': HexParser.colorToHex(scheme.secondary),
      'onSecondary': HexParser.colorToHex(scheme.onSecondary),
      'secondaryContainer': HexParser.colorToHex(scheme.secondaryContainer),
      'onSecondaryContainer': HexParser.colorToHex(scheme.onSecondaryContainer),
      'tertiary': HexParser.colorToHex(scheme.tertiary),
      'onTertiary': HexParser.colorToHex(scheme.onTertiary),
      'surface': HexParser.colorToHex(scheme.surface),
      'onSurface': HexParser.colorToHex(scheme.onSurface),
      'error': HexParser.colorToHex(scheme.error),
      'onError': HexParser.colorToHex(scheme.onError),
      'outline': HexParser.colorToHex(scheme.outline),
    };
  }

  static String _kebabCase(String input) {
    return input.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '-${match.group(1)!.toLowerCase()}',
    );
  }

  static String _camelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toLowerCase() + input.substring(1);
  }
}
