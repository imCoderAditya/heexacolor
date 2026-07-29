import 'dart:ui';
import 'package:flutter/material.dart';
import '../smart_color/smart_color_engine.dart';

/// Glassmorphism & Visual Effects Engine for ThemeVerse.
class GlassDecoration {
  /// Builds a [BoxDecoration] with glassmorphic transparency and border highlights.
  static BoxDecoration build({
    Color baseColor = Colors.white,
    double opacity = 0.15,
    double borderRadius = 16.0,
    Color? borderColor,
  }) {
    final effectiveBorder = borderColor ?? SmartColorEngine.borderColor(baseColor);

    return BoxDecoration(
      color: baseColor.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: effectiveBorder,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}

/// A high-performance Glassmorphic container widget built for Flutter.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double opacity;
  final double borderRadius;
  final Color baseColor;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.blur = 12.0,
    this.opacity = 0.15,
    this.borderRadius = 16.0,
    this.baseColor = Colors.white,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: GlassDecoration.build(
              baseColor: baseColor,
              opacity: opacity,
              borderRadius: borderRadius,
              borderColor: borderColor,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
