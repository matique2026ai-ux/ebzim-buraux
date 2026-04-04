import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTrailingPressed;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.onTrailingPressed,
    this.trailing,
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
                fontStyle: FontStyle.italic,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          if (trailing != null)
            InkWell(
              onTap: onTrailingPressed,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}
