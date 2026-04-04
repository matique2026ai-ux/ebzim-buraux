import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color overrideColor;
  final EdgeInsetsGeometry padding;
  final BoxBorder? border;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 1.0, // Reduced from 20.0 for stability/performance
    this.overrideColor = Colors.white,
    this.padding = const EdgeInsets.all(32),
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: overrideColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
        border: border ?? Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: padding,
      child: child,
    );
  }
}
