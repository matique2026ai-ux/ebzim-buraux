import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius,
    this.border,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppTheme.surfaceGlass,
            borderRadius: borderRadius ?? BorderRadius.circular(24),
            border: border ?? Border.all(color: AppTheme.borderGlass),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
