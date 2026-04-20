import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';

import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider).languageCode;
    final theme = Theme.of(context);
    final isRtl = currentLocale == 'ar';
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: EbzimBackground(
        child: Stack(
          children: [
            // Background Decor (Adapted for dark background)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: const Color(0xFF006400).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: const [BoxShadow(color: Color(0xFF006400), blurRadius: 120)],
                ),
              ),
            ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: const Color(0xFF005500).withOpacity(0.2),
                borderRadius: BorderRadius.circular(200),
                boxShadow: const [BoxShadow(color: Color(0xFF005500), blurRadius: 100)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header (Translate Icon, Logo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.translate, color: AppTheme.accentColor),
                        ],
                      ),
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.03),
                            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF0E0C8).withOpacity(0.15), // Soft elegant glow
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Center(
                                child: Image.asset('assets/images/logo.png', height: 48)
                                    .animate(onPlay: (controller) => controller.repeat())
                                    .shimmer(duration: 3000.ms, color: Colors.white.withOpacity(0.1))
                                    .custom(
                                      duration: 6.seconds,
                                      builder: (context, value, child) {
                                        return Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..setEntry(3, 2, 0.002)
                                            ..rotateY(-value * 2 * 3.14159),
                                          child: child,
                                        );
                                      },
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE2E2E9),
                          border: Border.all(color: const Color(0xFFBFCAB7).withOpacity(0.15)),
                        ),
                        child: const Icon(Icons.person_outline, size: 20, color: Color(0xFF707A6A)),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          loc.langSub,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            color: AppTheme.accentColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: theme.textTheme.headlineLarge?.fontFamily,
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                            children: [
                              TextSpan(text: '${loc.langTitle1}\n'),
                              if (loc.langTitle2.isNotEmpty)
                                TextSpan(
                                  text: loc.langTitle2,
                                  style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            loc.langDesc,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Sleek Language Cards
                        _buildLanguageCard(context, currentLocale == 'ar', () => ref.read(localeProvider.notifier).setLocale(const Locale('ar')), loc.langAr, isRtl ? 'الشرق الأوسط وشمال أفريقيا' : 'ARABIC', Icons.auto_awesome, AppTheme.primaryColor),
                        const SizedBox(height: 16),
                        _buildLanguageCard(context, currentLocale == 'en', () => ref.read(localeProvider.notifier).setLocale(const Locale('en')), loc.langEn, isRtl ? 'المملكة المتحدة / الولايات المتحدة' : 'UNITED KINGDOM / US', Icons.public, AppTheme.primaryColor),
                        const SizedBox(height: 16),
                        _buildLanguageCard(context, currentLocale == 'fr', () => ref.read(localeProvider.notifier).setLocale(const Locale('fr')), loc.langFr, isRtl ? 'فرنسا / المغرب العربي' : 'FRANCE / MAGHREB', Icons.stars, AppTheme.primaryColor),

                        const SizedBox(height: 64),
                        // Continue CTA
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            onPressed: () => context.go('/onboarding'),
                            style: ElevatedButton.styleFrom(
                               backgroundColor: AppTheme.accentColor,
                               foregroundColor: AppTheme.primaryColor,
                              elevation: 10,
                              shadowColor: AppTheme.primaryColor.withOpacity(0.25),
                              minimumSize: const Size(double.infinity, 64),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(loc.langContinue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 12),
                                Icon(isRtl ? Icons.arrow_back : Icons.arrow_right_alt),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          loc.langSecured.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.white38,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildLanguageCard(BuildContext context, bool isSelected, VoidCallback onTap, String label, String subLabel, IconData icon, Color activeColor) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor.withOpacity(0.5) : const Color(0xFFBFCAB7).withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: activeColor.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))] : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? activeColor : Colors.white.withOpacity(0.5), size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 24, color: isSelected ? activeColor : Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subLabel, style: TextStyle(fontSize: 10, color: isSelected ? AppTheme.secondaryColor : Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ],
              ),
            ),
            if (isSelected) 
              Container(width: 32, height: 32, decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 16))
          ],
        ),
      ),
    );
  }
}
