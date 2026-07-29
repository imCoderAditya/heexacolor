import 'package:flutter/material.dart';

/// Smart State & Derivative Colors Engine.
class SmartColorEngine {
  /// Computes hover color (subtly lighter or darker based on brightness).
  static Color hoverColor(Color base) {
    return base.computeLuminance() > 0.5
        ? Color.lerp(base, Colors.black, 0.08)!
        : Color.lerp(base, Colors.white, 0.12)!;
  }

  /// Computes pressed color.
  static Color pressedColor(Color base) {
    return base.computeLuminance() > 0.5
        ? Color.lerp(base, Colors.black, 0.18)!
        : Color.lerp(base, Colors.white, 0.24)!;
  }

  /// Computes disabled color (reduced opacity and desaturated).
  static Color disabledColor(Color base) {
    final hsl = HSLColor.fromColor(base);
    final desaturated = hsl.withSaturation(hsl.saturation * 0.2).toColor();
    return desaturated.withValues(alpha: 0.38);
  }

  /// Computes selected color state.
  static Color selectedColor(Color base) {
    return base.withValues(alpha: 0.16);
  }

  /// Computes border color for container elements.
  static Color borderColor(Color base) {
    return base.computeLuminance() > 0.5
        ? base.withValues(alpha: 0.25)
        : Colors.white.withValues(alpha: 0.20);
  }

  /// Computes soft shadow color.
  static Color shadowColor(Color base) {
    return base.computeLuminance() > 0.5
        ? Colors.black.withValues(alpha: 0.12)
        : base.withValues(alpha: 0.35);
  }

  /// Computes splash/ripple effect color.
  static Color rippleColor(Color base) {
    return base.computeLuminance() > 0.5
        ? Colors.black.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.20);
  }

  /// Computes divider color.
  static Color dividerColor(Color base) {
    return base.computeLuminance() > 0.5
        ? Colors.black.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.15);
  }
}
