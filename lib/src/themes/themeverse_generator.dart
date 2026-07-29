import 'package:flutter/material.dart';
import '../parser/color_parser.dart';
import 'theme_style.dart';
import 'mood.dart';

/// Main ThemeVerse AI Design System Generator.
class ThemeVerse {
  /// Generates a production-ready [ThemeData] from seed color or style preset.
  static ThemeData generate({
    String? seed,
    Color? seedColor,
    ThemeStyle style = ThemeStyle.material3,
    Brightness brightness = Brightness.light,
  }) {
    final effectiveSeed = seedColor ??
        (seed != null ? ColorParser.parse(seed) : _getStyleSeed(style));

    final isDark = brightness == Brightness.dark;

    switch (style) {
      case ThemeStyle.apple:
        return _buildAppleTheme(effectiveSeed, isDark);
      case ThemeStyle.glass:
        return _buildGlassTheme(effectiveSeed, isDark);
      case ThemeStyle.luxury:
        return _buildLuxuryTheme(effectiveSeed, isDark);
      case ThemeStyle.cyberpunk:
        return _buildCyberpunkTheme(effectiveSeed, isDark);
      case ThemeStyle.corporate:
      case ThemeStyle.finance:
        return _buildCorporateTheme(effectiveSeed, isDark);
      case ThemeStyle.minimal:
        return _buildMinimalTheme(effectiveSeed, isDark);
      case ThemeStyle.material3:
      default:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: effectiveSeed,
            brightness: brightness,
          ),
        );
    }
  }

  /// Generates a [ThemeData] based on emotional / brand [Mood].
  static ThemeData fromMood(Mood mood, {Brightness brightness = Brightness.light}) {
    final seed = _getMoodSeed(mood);
    return generate(seedColor: seed, brightness: brightness);
  }

  /// Generates a complete Theme from a seed color.
  static ThemeData fromSeed(Color seed, {Brightness brightness = Brightness.light}) {
    return generate(seedColor: seed, brightness: brightness);
  }

  /// Generates a Brand Design Kit Theme from company name and optional primary color.
  static ThemeData fromBrand({
    required String name,
    Color? primaryColor,
    Brightness brightness = Brightness.light,
  }) {
    final effectivePrimary = primaryColor ?? _hashStringToColor(name);
    return generate(seedColor: effectivePrimary, brightness: brightness);
  }

  static Color _getStyleSeed(ThemeStyle style) {
    switch (style) {
      case ThemeStyle.apple:
        return const Color(0xFF007AFF);
      case ThemeStyle.glass:
        return const Color(0xFF00D2FF);
      case ThemeStyle.luxury:
        return const Color(0xFFD4AF37); // Gold
      case ThemeStyle.cyberpunk:
        return const Color(0xFFFF007F); // Neon Pink
      case ThemeStyle.corporate:
      case ThemeStyle.finance:
        return const Color(0xFF0F52BA); // Sapphire
      case ThemeStyle.gaming:
        return const Color(0xFF7B2CBF);
      case ThemeStyle.healthcare:
        return const Color(0xFF00A896);
      case ThemeStyle.minimal:
        return const Color(0xFF2B2D42);
      case ThemeStyle.material3:
      default:
        return const Color(0xFF6750A4);
    }
  }

  static Color _getMoodSeed(Mood mood) {
    switch (mood) {
      case Mood.luxury:
        return const Color(0xFFD4AF37);
      case Mood.success:
        return const Color(0xFF2ECC71);
      case Mood.warning:
        return const Color(0xFFF39C12);
      case Mood.error:
        return const Color(0xFFE74C3C);
      case Mood.happiness:
        return const Color(0xFFFFD166);
      case Mood.trust:
      case Mood.banking:
        return const Color(0xFF1D3557);
      case Mood.medical:
        return const Color(0xFF06D6A0);
      case Mood.travel:
        return const Color(0xFF118AB2);
      case Mood.food:
        return const Color(0xFFFF6B6B);
      case Mood.gaming:
      case Mood.cyberpunk:
      case Mood.neon:
        return const Color(0xFF8338EC);
      case Mood.technology:
      case Mood.space:
        return const Color(0xFF3A86FF);
    }
  }

  static Color _hashStringToColor(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = input.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final finalHash = hash.abs();
    final r = (finalHash & 0xFF0000) >> 16;
    final g = (finalHash & 0x00FF00) >> 8;
    final b = finalHash & 0x0000FF;
    return Color.fromRGBO(r, g, b, 1.0);
  }

  static ThemeData _buildAppleTheme(Color seed, bool isDark) {
    final bg = isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7);
    final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: isDark ? Brightness.dark : Brightness.light,
        surface: cardBg,
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData _buildGlassTheme(Color seed, bool isDark) {
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  static ThemeData _buildLuxuryTheme(Color seed, bool isDark) {
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFFAF9F6);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: const Color(0xFFD4AF37),
      ),
    );
  }

  static ThemeData _buildCyberpunkTheme(Color seed, bool isDark) {
    const bg = Color(0xFF0D0221);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF007F),
        brightness: Brightness.dark,
        secondary: const Color(0xFF00F5D4),
      ),
    );
  }

  static ThemeData _buildCorporateTheme(Color seed, bool isDark) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  static ThemeData _buildMinimalTheme(Color seed, bool isDark) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }
}
