import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/services/storage_service.dart';
import 'package:ebzim_app/core/services/cms_content_service.dart';
import '../core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/models/cms_models.dart';

class OnboardingSliderScreen extends ConsumerStatefulWidget {
  const OnboardingSliderScreen({super.key});

  @override
  ConsumerState<OnboardingSliderScreen> createState() =>
      _OnboardingSliderScreenState();
}

class _OnboardingSliderScreenState
    extends ConsumerState<OnboardingSliderScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _completeOnboarding() {
    ref.read(storageServiceProvider).setFirstLaunchCompleted();
    context.go('/home');
  }

  void _nextPage(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuart,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final slidesAsync = ref.watch(onboardingSlidesProvider);
    final loc = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider).languageCode;
    final isAr = locale == 'ar';

    return Scaffold(
      backgroundColor: Colors.black,
      body: slidesAsync.when(
        data: (slides) {
          final effectiveSlides =
              slides.isNotEmpty ? slides : _getDefaultSlides(loc, locale);
          return Stack(
            children: [
              // Dynamic Background based on current slide
              _buildBackground(effectiveSlides[_currentPage]),

              // Slides Content
              PageView.builder(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: effectiveSlides.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildSlideContent(
                      effectiveSlides[index], locale, index);
                },
              ),

              // Header (Logo + Language)
              _buildHeader(loc, locale),

              // Footer (Navigation)
              _buildFooter(effectiveSlides.length, loc, isAr),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (_, __) => Center(
          child: Text(
            'Error loading onboarding',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(HeroSlide slide) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      child: Stack(
        key: ValueKey(slide.id),
        fit: StackFit.expand,
        children: [
          if (slide.imageUrl.startsWith('http'))
            CachedNetworkImage(
              imageUrl: slide.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.black),
            )
          else
            Image.asset(
              slide.imageUrl,
              fit: BoxFit.cover,
            ),
          // Gradient Overlay for Premium Look
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black,
                ],
                stops: const [0.0, 0.4, 0.8, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc, String locale) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Premium Engraved Logo Look
            _buildEngravedLogo(),
            
            // Language Selector Glassmorphism
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.05),
                    BlendMode.srcOver,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _buildLangBtn('AR', locale == 'ar'),
                        _buildLangBtn('FR', locale == 'fr'),
                        _buildLangBtn('EN', locale == 'en'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2);
  }

  Widget _buildEngravedLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(1, 1),
            blurRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            offset: const Offset(-1, -1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.8,
            child: Image.asset('assets/images/logo.png', height: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'EBZIM',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              fontSize: 13,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 1,
                ),
                Shadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  offset: const Offset(-1, -1),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangBtn(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(Locale(label.toLowerCase()));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSlideContent(HeroSlide slide, String locale, int index) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag / Category
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                'COLLECTIVE MEMORY • 0${index + 1}',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ).animate(key: ValueKey('tag_$index')).fadeIn(delay: 200.ms).slideX(begin: -0.1),

            // Glass Card for Content
            _buildGlassCard(slide, locale, index),
            
            const SizedBox(height: 120), // Spacer for bottom actions
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard(HeroSlide slide, String locale, int index) {
    // Standardize design token parsing (Copy-pasted logic from HomeScreen for consistency)
    final double finalOpacity = slide.overlayOpacity;
    Color glassBaseColor = Colors.black;

    if (slide.overlayColor != null && slide.overlayColor!.trim().isNotEmpty) {
      try {
        String hex = slide.overlayColor!.trim().toUpperCase().replaceFirst('#', '');
        if (hex.length == 3) hex = hex.split('').map((c) => c + c).join('');
        if (hex.length == 6) hex = 'FF$hex';
        if (hex.length == 8) glassBaseColor = Color(int.parse(hex, radix: 16));
      } catch (e) {
        glassBaseColor = AppTheme.primaryColor;
      }
    }
    
    final Color finaloverlayColor = glassBaseColor.withValues(alpha: finalOpacity);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: finaloverlayColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Title
              Text(
                slide.getTitle(locale),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ).animate(key: ValueKey('title_$index')).fadeIn(delay: 400.ms).slideY(begin: 0.1),

              const SizedBox(height: 16),

              // Description
              Text(
                slide.getSubtitle(locale),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ).animate(key: ValueKey('desc_$index')).fadeIn(delay: 600.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    ).animate(key: ValueKey('glass_$index')).fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildFooter(int totalPages, AppLocalizations loc, bool isAr) {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: Column(
        children: [
          // Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(totalPages, (index) {
              final active = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.only(right: 8),
                height: 4,
                width: active ? 40 : 12,
                decoration: BoxDecoration(
                  color: active ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
          const SizedBox(height: 40),

          // Action Buttons
          Row(
            children: [
              // Skip Button
              Expanded(
                child: TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Text(
                    loc.onboardingSkip.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Next/Done Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _nextPage(totalPages),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (_currentPage == totalPages - 1
                                ? loc.onboardingDone
                                : loc.onboardingNext)
                            .toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        isAr ? Icons.arrow_back : Icons.arrow_forward,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2);
  }

  List<HeroSlide> _getDefaultSlides(AppLocalizations loc, String locale) {
    return [
      HeroSlide(
        id: 'default_1',
        titleAr: 'إرث من الثقافة والواجب',
        titleEn: 'A Legacy of Culture & Duty',
        titleFr: 'Un héritage de culture et de devoir',
        subtitleAr: 'انضم إلى تجربة إبزيم لاكتشاف كنوز سطيف، حيث يلتقي الماضي بروح العصر.',
        subtitleEn: 'Join the Ebzim experience to discover the treasures of Sétif, where the past meets the spirit of the age.',
        subtitleFr: 'Rejoignez l\'expérience Ebzim pour découvrir les trésors de Sétif, où le passé rencontre l\'esprit de l\'époque.',
        imageUrl: 'assets/images/onboarding_1.png',
        location: 'ONBOARDING',
      ),
      HeroSlide(
        id: 'default_2',
        titleAr: 'جسر رقمي نحو الحكمة',
        titleEn: 'A Digital Bridge to Wisdom',
        titleFr: 'Un pont numérique vers la sagesse',
        subtitleAr: 'تمكين الوصول إلى الأرشيفات واللقاءات التي تشكل هويتنا الجماعية.',
        subtitleEn: 'Enabling access to archives and gatherings that shape our collective identity.',
        subtitleFr: 'Permettre l\'accès aux archives et aux rencontres qui façonnent notre identité collective.',
        imageUrl: 'assets/images/onboarding_2.png',
        location: 'ONBOARDING',
      ),
      HeroSlide(
        id: 'default_3',
        titleAr: 'كن جزءاً من صون الذاكرة',
        titleEn: 'Be Part of Memory Preservation',
        titleFr: 'Participez à la préservation de la mémoire',
        subtitleAr: 'مساهمتك اليوم تؤمن بقاء إرثنا الثقافي للأجيال القادمة.',
        subtitleEn: 'Your contribution today secures the survival of our heritage for future generations.',
        subtitleFr: 'Votre contribution aujourd\'hui assure la survie de notre patrimoine pour les générations futures.',
        imageUrl: 'assets/images/onboarding_3.png',
        location: 'ONBOARDING',
      ),
    ];
  }
}
