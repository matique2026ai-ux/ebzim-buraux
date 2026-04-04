import 'package:flutter/material.dart';
import '../localization/l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class EbzimAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;

  const EbzimAppBar({
    super.key,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AppBar(
      leading: leading,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png', height: 24, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            loc.appName,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppTheme.primaryColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
