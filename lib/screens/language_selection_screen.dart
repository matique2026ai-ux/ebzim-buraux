import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: AppTheme.backgroundDark,
      body: EbzimBackground(
        child: Stack(
          children: [
            // Luminous Ambient Glows
            Positioned(
              top: -100,
              left: -100,
              child: _AmbientGlow(
                color: AppTheme.primaryColor.withValues(alpha: 0.5),
              ),
            ),
            Positioned(
              bottom: -150,
              right: -100,
              child: _AmbientGlow(
                color: AppTheme.accentColor.withValues(alpha: 0.15),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Text(
                                loc.langSub.toUpperCase(),
                                style: GoogleFonts.tajawal(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4.0,
                                  color: AppTheme.accentColor,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 800.ms)
                              .slideY(begin: 0.2),
                          const SizedBox(height: 12),
                          Text(
                                loc.langTitle1,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.tajawal(
                                  fontSize: 34,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 800.ms)
                              .scale(begin: const Offset(0.95, 0.95)),
                          const SizedBox(height: 16),
                          Opacity(
                            opacity: 0.7,
                            child: Text(
                              loc.langDesc,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1.6,
                              ),
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                          const SizedBox(height: 48),
                          _LanguageOption(
                                label: loc.langAr,
                                subLabel: 'اللغة العربية • التراث والأصالة',
                                icon: Icons.auto_awesome_rounded,
                                isSelected: currentLocale == 'ar',
                                onTap: () => ref
                                    .read(localeProvider.notifier)
                                    .setLocale(const Locale('ar')),
                              )
                              .animate()
                              .fadeIn(delay: 500.ms)
                              .slideX(begin: isRtl ? 0.1 : -0.1),
                          const SizedBox(height: 16),
                          _LanguageOption(
                                label: loc.langEn,
                                subLabel: 'English • Heritage & Modernity',
                                icon: Icons.language_rounded,
                                isSelected: currentLocale == 'en',
                                onTap: () => ref
                                    .read(localeProvider.notifier)
                                    .setLocale(const Locale('en')),
                              )
                              .animate()
                              .fadeIn(delay: 600.ms)
                              .slideX(begin: isRtl ? 0.1 : -0.1),
                          const SizedBox(height: 16),
                          _LanguageOption(
                                label: loc.langFr,
                                subLabel: 'Français • Culture et Citoyenneté',
                                icon: Icons.stars_rounded,
                                isSelected: currentLocale == 'fr',
                                onTap: () => ref
                                    .read(localeProvider.notifier)
                                    .setLocale(const Locale('fr')),
                              )
                              .animate()
                              .fadeIn(delay: 700.ms)
                              .slideX(begin: isRtl ? 0.1 : -0.1),
                          const SizedBox(height: 60),
                          _PremiumButton(
                                label: loc.langContinue,
                                isRtl: isRtl,
                                onPressed: () => context.go('/onboarding'),
                              )
                              .animate()
                              .fadeIn(delay: 900.ms)
                              .scale(begin: const Offset(0.9, 0.9)),
                          const SizedBox(height: 40),
                          _FooterBranding(loc: loc),
                          const SizedBox(height: 24),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.translate_rounded,
            color: Colors.white.withValues(alpha: 0.4),
            size: 20,
          ),

          // Center Logo with Institutional Glow
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withValues(alpha: 0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              child: Image.asset('assets/images/logo.png', height: 28),
            ),
          ).animate().shimmer(duration: 2.seconds, color: Colors.white10),

          Icon(
            Icons.security_rounded,
            color: Colors.white.withValues(alpha: 0.4),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String subLabel;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 400.ms,
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppTheme.accentColor, Color(0xFF8B7344)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accentColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon with Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppTheme.primaryColor.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppTheme.accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 20),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subLabel.toUpperCase(),
                      style: GoogleFonts.cairo(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),

              // Selection Indicator
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 28,
                ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  final String label;
  final bool isRtl;
  final VoidCallback onPressed;

  const _PremiumButton({
    required this.label,
    required this.isRtl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: AppTheme.primaryColor,
          minimumSize: const Size(double.infinity, 68),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final Color color;
  const _AmbientGlow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 150, spreadRadius: 50)],
      ),
    );
  }
}

class _FooterBranding extends StatelessWidget {
  final AppLocalizations loc;
  const _FooterBranding({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Stone-Engraved Logo Implementation ──
        Stack(
          alignment: Alignment.center,
          children: [
            // Dark Shadow (Engraving depth)
            Opacity(
              opacity: 0.15,
              child: Transform.translate(
                offset: const Offset(1, 1),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 32,
                  color: Colors.black,
                ),
              ),
            ),
            // Light Highlight (Edge catch)
            Opacity(
              opacity: 0.1,
              child: Transform.translate(
                offset: const Offset(-0.5, -0.5),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          loc.langSecured.toUpperCase(),
          style: GoogleFonts.tajawal(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
            color: Colors.white24,
          ),
        ),
      ],
    );
  }
}
