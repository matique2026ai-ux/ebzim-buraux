import 'package:flutter/material.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTrailingPressed;
  final Widget? trailing;
  final String? trailingLabel;

  const SectionHeader({
    super.key,
    required this.title,
    this.onTrailingPressed,
    this.trailing,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                // No italic — accessibility requirement for readability
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          if (trailing != null)
            Semantics(
              label: trailingLabel ?? title,
              button: onTrailingPressed != null,
              child: InkWell(
                onTap: onTrailingPressed,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  child: Center(child: trailing!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
