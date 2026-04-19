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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final defaultColor = isDark 
        ? const Color(0x99000000) 
        : Colors.white.withOpacity(0.7); // Pearl Silk in light mode
    
    final defaultBorder = Border.all(
        color: isDark 
            ? AppTheme.borderGlass 
            : Colors.black.withOpacity(0.05)
    );

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? defaultColor,
            borderRadius: borderRadius ?? BorderRadius.circular(24),
            border: border ?? defaultBorder,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
