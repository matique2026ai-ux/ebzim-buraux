import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../localization/l10n/app_localizations.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;
  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/leadership')) return 1;
    if (location.startsWith('/activities')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // default
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/leadership');
        break;
      case 2:
        context.go('/activities');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      extendBody: true, // For curved nav bar backgrounds
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.05), blurRadius: 30, offset: const Offset(0, -10))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(icon: Icons.dashboard, label: loc.navDashboard, isSelected: currentIndex == 0, onTap: () => _onItemTapped(0, context)),
                _NavBarItem(icon: Icons.account_balance, label: loc.navDirectory, isSelected: currentIndex == 1, onTap: () => _onItemTapped(1, context)),
                _NavBarItem(icon: Icons.explore, label: loc.navActivities, isSelected: currentIndex == 2, onTap: () => _onItemTapped(2, context)),
                _NavBarItem(icon: Icons.person, label: loc.navProfile, isSelected: currentIndex == 3, onTap: () => _onItemTapped(3, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppTheme.secondaryColor : AppTheme.primaryColor.withValues(alpha: 0.4), size: 28),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppTheme.secondaryColor : AppTheme.primaryColor.withValues(alpha: 0.4),
              letterSpacing: 2,
            ),
          )
        ],
      ),
    );
  }
}
