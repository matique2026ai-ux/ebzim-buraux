import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppTheme.heritageGreenDeep,
      body: Stack(
        children: [
          // 1. Performance-Centric Background (Single color/simple gradient)
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.heritageGreenDeep,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView( // Changed to scrollable for responsiveness
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 48.0),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  
                  // Refined Header (Simplified Copy)
                  Column(
                    children: [
                      Text(
                        loc.langSub.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.premiumParchment.withValues(alpha: 0.5),
                          letterSpacing: 4.0,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        loc.langTitle1, // Now "Language" in ARB
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: AppTheme.premiumParchment,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          loc.langDesc,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.premiumParchment.withValues(alpha: 0.6),
                            height: 1.6,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // The Selector List
                  Column(
                    children: [
                      _buildLanguageSelector(
                        context: context,
                        title: loc.langAr,
                        subtitle: 'ARABIC',
                        localeCode: 'ar',
                        currentLocale: currentLocale.languageCode,
                        onTap: () => ref.read(localeProvider.notifier).state = const Locale('ar'),
                      ),
                      const SizedBox(height: 12),
                      _buildLanguageSelector(
                        context: context,
                        title: loc.langEn,
                        subtitle: 'ENGLISH',
                        localeCode: 'en',
                        currentLocale: currentLocale.languageCode,
                        onTap: () => ref.read(localeProvider.notifier).state = const Locale('en'),
                      ),
                      const SizedBox(height: 12),
                      _buildLanguageSelector(
                        context: context,
                        title: loc.langFr,
                        subtitle: 'FRANÇAIS',
                        localeCode: 'fr',
                        currentLocale: currentLocale.languageCode,
                        onTap: () => ref.read(localeProvider.notifier).state = const Locale('fr'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Primary Action
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () => context.go('/onboarding'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.restrainedGold,
                        foregroundColor: AppTheme.heritageGreenDeep,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        loc.langContinue.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    loc.langSecured.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.premiumParchment.withValues(alpha: 0.3),
                      letterSpacing: 2,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String localeCode,
    required String currentLocale,
    required VoidCallback onTap,
  }) {
    final isSelected = localeCode == currentLocale;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppTheme.restrainedGold.withValues(alpha: 0.1),
        highlightColor: AppTheme.restrainedGold.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppTheme.restrainedGold.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? AppTheme.restrainedGold 
                  : AppTheme.premiumParchment.withValues(alpha: 0.1),
              width: isSelected ? 1.5 : 0.8,
            ),
          ),
          child: Row(
            children: [
              // Marker
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppTheme.restrainedGold : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppTheme.restrainedGold : AppTheme.premiumParchment.withValues(alpha: 0.3),
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.premiumParchment,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppTheme.premiumParchment.withValues(alpha: 0.4),
                        letterSpacing: 1,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              
              if (isSelected)
                const Icon(
                  Icons.check_circle_outline_rounded, 
                  color: AppTheme.restrainedGold, 
                  size: 20
                ),
            ],
          ),
        ),
      ),
    );
  }
}
