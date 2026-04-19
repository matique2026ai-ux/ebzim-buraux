import 'package:flutter/material.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginRequiredOverlay extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData icon;

  const LoginRequiredOverlay({
    super.key,
    this.title,
    this.message,
    this.icon = Icons.lock_person_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : theme.colorScheme.onSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: GlassCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentColor.withOpacity(0.1),
                ),
                child: Icon(icon, size: 48, color: AppTheme.accentColor),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 24),
              Text(
                title ?? loc.authWelcome,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              Text(
                message ?? 'يرجى تسجيل الدخول للوصول إلى هذه الميزة والمساهمة في أنشطة الجمعية.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor.withOpacity(0.6),
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    loc.authAccessButton,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.95, 0.95)),
            ],
          ),
        ),
      ),
    );
  }
}
