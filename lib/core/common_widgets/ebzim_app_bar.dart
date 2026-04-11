import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class EbzimAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final Color? color;
  final Color? backgroundColor;

  final PreferredSizeWidget? bottom;

  const EbzimAppBar({
    super.key,
    this.leading,
    this.actions,
    this.color,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final activeColor = color ?? Theme.of(context).primaryColor;

    return AppBar(
      leading: leading,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: (backgroundColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.8),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png', height: 24, color: activeColor),
          const SizedBox(width: 8),
          Text(
            loc.appName,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
              color: activeColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: actions,
      iconTheme: IconThemeData(color: activeColor),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
