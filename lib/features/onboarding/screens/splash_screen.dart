import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/common_widgets/glass_card.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // 1. Performance-Centric Background
          Positioned.fill(
            child: Container(
              color: AppTheme.heritageGreenDeep,
            ),
          ),
          
          // 2. Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Glass Panel
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    blur: 30,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Typography Phase
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    loc.splashTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Amiri', // Forcing serif look for the splash
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: AppTheme.primaryColor,
                          blurRadius: 20,
                        )
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  loc.splashSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Newsreader',
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  loc.splashCaption.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                
                const SizedBox(height: 64),
                
                // Explorer CTA
                TextButton(
                  onPressed: () => context.go('/language'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        loc.splashAction.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
