import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';

import 'package:ebzim_app/core/theme/app_theme.dart';

// Design tokens — inherited from global theme
Color get _kNavBg => AppTheme.backgroundDark;
const _kNavBorder = Color(0x1AFFFFFF);     // 10% white top border
Color get _kActiveColor => AppTheme.accentColor;   // Muted Gold from theme
const _kInactiveColor = Color(0x80FFFFFF); // 50% white

class MainShellScreen extends StatelessWidget {
  final Widget child;
  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/home')) return 0;
    if (loc.startsWith('/activities')) return 1;
    if (loc.startsWith('/news')) return 2;
    if (loc.startsWith('/about') || loc.startsWith('/directory')) return 3;
    if (loc.startsWith('/dashboard') || loc.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/activities'); break;
      case 2: context.go('/news'); break;
      case 3: context.go('/about'); break;
      case 4: context.go('/dashboard'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final l = AppLocalizations.of(context)!;

    final items = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: l.navDashboard),
      _NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: l.navActivities),
      _NavItem(icon: Icons.article_outlined, activeIcon: Icons.article_rounded, label: l.navNews),
      _NavItem(icon: Icons.account_balance_outlined, activeIcon: Icons.account_balance_rounded, label: l.navDirectory),
      _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l.navProfile),
    ];

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: _NavBar(
        items: items,
        currentIndex: currentIndex,
        onTap: (i) => _onItemTapped(i, context),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA CLASS
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV BAR CONTAINER
// ─────────────────────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _NavBar({required this.items, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundDark.withOpacity(0.97) : Colors.white.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.30 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border(
          top: BorderSide(color: isDark ? _kNavBorder : Colors.black.withOpacity(0.05), width: 1.0),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Row(
                children: items.asMap().entries.map((e) {
                  return Expanded(
                    child: _NavTile(
                      item: e.value,
                      index: e.key,
                      isSelected: currentIndex == e.key,
                      onTap: () => onTap(e.key),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV TILE
// ─────────────────────────────────────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final _NavItem item;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? _kActiveColor : theme.primaryColor;
    final inactiveColor = isDark ? _kInactiveColor : Colors.black38;
    final color = isSelected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation.drive(Tween(begin: 0.85, end: 1.0)),
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey<bool>(isSelected),
                  size: 25,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.cairo(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  letterSpacing: 0.2,
                ),
                child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

