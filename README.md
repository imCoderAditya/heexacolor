<p align="center">
  <img src="https://raw.githubusercontent.com/imCoderAditya/heexacolor/main/doc/assets/themeverse_banner.png" alt="ThemeVerse Banner" width="100%" />
</p>

<h1 align="center">ThemeVerse (heexacolor)</h1>

<p align="center">
  <b>The AI-Powered Design System Engine & Universal Color Suite for Flutter.</b>
</p>

<p align="center">
  <a href="https://pub.dev/packages/heexacolor"><img src="https://img.shields.io/pub/v/heexacolor.svg" alt="Pub Version"></a>
  <a href="https://github.com/imCoderAditya/heexacolor"><img src="https://img.shields.io/github/stars/imCoderAditya/heexacolor?style=social" alt="GitHub Stars"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Platform-Flutter%20%7C%20Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue" alt="Platform Support"></a>
</p>

---

## 🌌 Overview

**ThemeVerse** transforms `heexacolor` into a complete, production-ready AI Design System Engine for Flutter. 

Generate complete Flutter themes (`ThemeData`), color palettes, WCAG 2.1 accessibility contrast reports, gradients, glassmorphic UI, and design token exports from a single line of code—while maintaining **100% backward compatibility** for legacy `HexColor`.

---

## 📱 Visual Showcase

<p align="center">
  <img src="https://raw.githubusercontent.com/imCoderAditya/heexacolor/main/doc/assets/themeverse_showcase_preview.png" alt="ThemeVerse Showcase Preview" width="600" />
</p>

---

## ⚡ Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:heexacolor/heexacolor.dart';

// 1. One-Line AI Theme Generation
final theme = ThemeVerse.generate(seed: '#6750A4', style: ThemeStyle.apple);

// 2. Emotional / Brand Mood Theme
final luxuryTheme = ThemeVerse.fromMood(Mood.luxury);

// 3. Universal Color Parsing Extensions
final color1 = "royalblue".toColor();               // 140+ CSS Color Names
final color2 = "blue-500".toColor();                // Tailwind Colors
final color3 = "hsl(120, 100%, 50%)".toColor();     // HSL / HSLA

// 4. Backward Compatible HexColor Class
final legacyColor = HexColor("#FF5722");
```

---

## 🔥 Key Features

### 1. 🎨 Universal Color Parsing Engine
Parse Hex (`#RGB`, `#RRGGBB`, `#AARRGGBB`), `rgb()`, `rgba()`, `hsl()`, `hsla()`, `hsv()`, `cmyk()`, `lab()`, `oklab()`, 140+ CSS Color Names, and Tailwind Colors in pure Dart.

```dart
Color c1 = "royalblue".toColor();
Color c2 = "emerald-500".toColor();
Color c3 = "rgb(255, 87, 34)".toColor();
Color c4 = "hsl(210, 100%, 50%)".toColor();
```

### 2. 🤖 AI Theme & Mood Generator
Generate complete Flutter `ThemeData` based on design system presets or brand emotional moods.

```dart
// Style Presets: Material 3, Apple, Glass, Cyberpunk, Luxury, Corporate, Minimal
ThemeData appleTheme = ThemeVerse.generate(style: ThemeStyle.apple);

// Mood Presets: Luxury, Banking, Medical, Travel, Food, Gaming, Neon
ThemeData techTheme = ThemeVerse.fromMood(Mood.technology);

// Brand Kit Generator
ThemeData brandTheme = ThemeVerse.fromBrand(name: "Google");
```

### 3. ♿ WCAG 2.1 & APCA Accessibility Studio
Calculates relative luminance contrast ratios, WCAG AA/AAA compliance, APCA lightness scores, and recommends the optimal contrast text color (Black or White).

```dart
final report = color.accessibilityReport(backgroundColor);

print(report.contrastRatio);         // e.g. 14.2:1
print(report.isWcagAANormalText);     // true
print(report.recommendedTextColor);   // Colors.black / Colors.white
```

### 4. 💎 Glassmorphism & GPU Gradients
Native backdrop blur container (`GlassContainer`) and GPU-accelerated gradients.

```dart
// Glassmorphic Backdrop Blur Container
GlassContainer(
  blur: 14,
  opacity: 0.18,
  borderRadius: 20,
  child: Text('Glass Card'),
)

// Gradients
BoxDecoration(
  gradient: GradientEngine.aurora(), // Aurora Borealis Gradient
  // Or GradientEngine.metallic(seedColor: Color(0xFFD4AF37))
)
```

### 5. 🎨 Color Harmonies & Palettes
Derive Complementary, Analogous, Triadic, Tetradic, Monochromatic palettes, Tints, Shades, and Tones.

```dart
List<Color> triadic = color.triadic();
List<Color> tints = color.tints(count: 6);
List<Color> shades = color.shades(count: 6);
```

### 6. ⚙️ Smart Derived State Colors
Zero-config state color derivation for interactive components:

```dart
Color hover = color.hoverColor;
Color pressed = color.pressedColor;
Color disabled = color.disabledColor;
Color border = color.borderColor;
Color shadow = color.shadowColor;
```

### 7. 📤 Design Token Exporter
Export your color schemes instantly to CSS Custom Properties, Tailwind Config, JSON, or Figma Tokens.

```dart
String css = TokenExporter.toCSS(colorScheme);
String tailwind = TokenExporter.toTailwind(colorScheme);
String figmaJson = TokenExporter.toFigma(colorScheme);
```

---

## 🛠️ Interactive Example Showcase App

Run the included showcase application in `example/lib/main.dart` to experience ThemeVerse in action with a responsive floating glass navigation system:

```bash
cd example
flutter run
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.