import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class EbzimSliverAppBar extends StatelessWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? background;
  final double expandedHeight;
  final bool pinned;

  const EbzimSliverAppBar({
    super.key,
    this.leading,
    this.actions,
    this.background,
    this.expandedHeight = 64.0,
    this.pinned = true,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppTheme.accentColor;
    final bgColor = isDark ? AppTheme.backgroundDark : Colors.white;

    return SliverAppBar(
      floating: false,
      pinned: pinned,
      backgroundColor: Colors.transparent, 
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: leading,
      centerTitle: true,
      toolbarHeight: 64,
      expandedHeight: expandedHeight > 64 ? expandedHeight : null,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: background,
        titlePadding: EdgeInsets.zero,
        centerTitle: true,
        title: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: isDark ? 0.4 : 0.7),
                border: Border(
                  bottom: BorderSide(
                    color: activeColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
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
                      style: GoogleFonts.tajawal(
                        color: activeColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      actions: actions,
      iconTheme: IconThemeData(color: activeColor),
    );
  }
}
