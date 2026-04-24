import 'package:flutter/material.dart';

/// A GestureDetector that is fully accessibility-compliant.
/// - Wraps with [Semantics] so screen readers can announce the action.
/// - Enforces minimum 44×44 touch target (WCAG 2.5.5).
/// - Does NOT use italic text for small labels.
class AccessibleTap extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String semanticLabel;
  final bool isButton;
  final bool excludeSemantics;

  const AccessibleTap({
    super.key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.isButton = true,
    this.excludeSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: isButton,
      enabled: onTap != null,
      excludeSemantics: excludeSemantics,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          child: child,
        ),
      ),
    );
  }
}

/// Wraps an [IconButton] with proper semantics and enforces min touch target.
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color? color;
  final double size;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: true,
      enabled: onPressed != null,
      child: IconButton(
        icon: Icon(icon, size: size, color: color),
        tooltip: tooltip,
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      ),
    );
  }
}
