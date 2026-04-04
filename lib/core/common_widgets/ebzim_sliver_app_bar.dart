import 'package:flutter/material.dart';
import '../localization/l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class EbzimSliverAppBar extends StatelessWidget {
  final Widget? leading;
  final List<Widget>? actions;

  const EbzimSliverAppBar({
    super.key,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.backgroundLight.withValues(alpha: 242), // ~0.95 opacity
      elevation: 0,
      forceElevated: true,
      leading: leading,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png', height: 24, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            loc.appName,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: actions,
      iconTheme: const IconThemeData(color: AppTheme.primaryColor),
    );
  }
}
