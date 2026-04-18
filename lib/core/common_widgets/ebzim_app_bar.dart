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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Always use accent gold for the premium feel requested by user
    final activeColor = AppTheme.accentColor;
    final bgColor = isDark ? AppTheme.backgroundDark : Colors.white;

    return AppBar(
      leading: leading,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), // High blur for premium feel
          child: Container(
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: isDark ? 0.4 : 0.7),
              border: Border(
                bottom: BorderSide(
                  color: activeColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png', 
            height: 28, 
            color: activeColor,
            colorBlendMode: BlendMode.srcIn,
          ),
          const SizedBox(width: 12),
          Text(
            loc.appName,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
              color: activeColor,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.5,
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
