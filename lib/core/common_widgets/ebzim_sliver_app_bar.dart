import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent, 
      elevation: 0,
      leading: leading,
      centerTitle: true,
      toolbarHeight: 64,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                  ? [
                      const Color(0xFF020F08).withValues(alpha: 0.95),
                      const Color(0xFF020F08).withValues(alpha: 0.85),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.95),
                      Colors.white.withValues(alpha: 0.85),
                    ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08),
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
          Image.asset('assets/images/logo.png', height: 26),
          const SizedBox(width: 10),
          Text(
            loc.appName,
            style: GoogleFonts.tajawal(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: actions,
      iconTheme: IconThemeData(color: AppTheme.accentColor),
    );
  }
}
