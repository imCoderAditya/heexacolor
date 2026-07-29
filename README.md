# ThemeVerse (heexacolor) 🌌

**The AI-Powered Design System Engine & Universal Color Suite for Flutter.**

ThemeVerse transforms `heexacolor` into a complete, enterprise-ready AI Design System Engine. Generate complete themes, palettes, WCAG accessibility reports, gradients, glassmorphism, and design token exports from a single line of code—with **100% backward compatibility** for `HexColor`.

---

## ⚡ Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:heexacolor/heexacolor.dart';

// 1. One-Line AI Theme Generation
final theme = ThemeVerse.generate(seed: '#6750A4', style: ThemeStyle.apple);

// 2. Emotional / Brand Mood Theme
final luxuryTheme = ThemeVerse.fromMood(Mood.luxury);

// 3. Universal Color Parsing Extension
final color1 = "royalblue".toColor();
final color2 = "blue-500".toColor();
final color3 = "hsl(120, 100%, 50%)".toColor();

// 4. Backward Compatible HexColor Class
final legacyColor = HexColor("#FF5722");
```

---

## 🚀 Features

- 🎨 **Universal Color Engine**: Parse Hex (`#RGB`, `#RRGGBB`, `#AARRGGBB`), `rgb()`, `rgba()`, `hsl()`, `hsla()`, `hsv()`, `cmyk()`, `lab()`, `oklab()`, 140+ CSS Names, and Tailwind Colors.
- 🤖 **AI Theme & Mood Generator**: Presets for Material 3, Apple, Glass, Cyberpunk, Luxury, Corporate, Minimal, and emotional Moods (Luxury, Banking, Tech, Neon, Medical).
- ♿ **WCAG 2.1 & APCA Accessibility Engine**: Instant contrast ratios, WCAG AA/AAA verification, APCA scoring, and text color contrast recommendations (`color.accessibilityReport()`).
- 💎 **Glassmorphism & Gradients Engine**: Native `GlassContainer`, `GlassDecoration`, Aurora, Mesh, Glass, and Metallic gradients.
- 🎨 **Color Harmonies & Palette Engine**: Complementary, Analogous, Triadic, Tetradic, Monochromatic palettes, Tints, Shades, and Tones.
- ⚙️ **Smart Derivation Engine**: Automatic state colors (`hoverColor`, `pressedColor`, `disabledColor`, `borderColor`, `shadowColor`, `rippleColor`).
- 📤 **Design Token Exporter**: Export complete design tokens to CSS Variables, Tailwind Config, JSON, and Figma Tokens.
- 🛠️ **In-App DevTools & Live Builder**: Embeddable `LiveThemeBuilder` and `ThemeVerseDevTools` widgets.