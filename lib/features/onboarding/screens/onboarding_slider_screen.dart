import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';

class OnboardingSliderScreen extends ConsumerStatefulWidget {
  const OnboardingSliderScreen({super.key});

  @override
  ConsumerState<OnboardingSliderScreen> createState() => _OnboardingSliderScreenState();
}

class _OnboardingSliderScreenState extends ConsumerState<OnboardingSliderScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppTheme.heritageGreenDeep,
      body: Stack(
        children: [
          // 1. Cinematic Foundation (Radial Depth)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.5, -0.3),
                radius: 1.2,
                colors: [
                  AppTheme.heritageGreenEmerald,
                  AppTheme.heritageGreenDeep,
                ],
                stops: [0.0, 0.8],
              ),
            ),
          ),

          // 2. Performance-Centric Overlay
          Container(
            color: Colors.black.withValues(alpha: 0.1),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: 'app_logo',
                        child: Image.asset(
                          'assets/images/logo.png', 
                          height: 32, 
                          color: AppTheme.premiumParchment.withValues(alpha: 0.9)
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Allow quick toggle for onboarding preview
                          final currentLocale = ref.read(localeProvider);
                          final newLocale = currentLocale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
                          ref.read(localeProvider.notifier).state = newLocale;
                        },
                        icon: const Icon(Icons.language_rounded, size: 16),
                        label: Text(ref.watch(localeProvider).languageCode.toUpperCase()),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.restrainedGold,
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 800.ms),

                // Main Slider Area
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildNarrativeSlide(
                        context: context,
                        loc: loc,
                        image: 'assets/images/onboarding_1.png',
                        tag: loc.onb1Tag,
                        titleWidget: RichText(
                          text: TextSpan(
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: AppTheme.premiumParchment,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                            children: [
                              TextSpan(text: '${loc.onb1Title1}\n'),
                              TextSpan(
                                text: '${loc.onb1TitleHighlight} ',
                                style: const TextStyle(
                                  color: AppTheme.restrainedGold,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextSpan(text: loc.onb1Title2),
                            ],
                          ),
                        ),
                        description: loc.onb1Desc,
                      ),
                      _buildNarrativeSlide(
                        context: context,
                        loc: loc,
                        image: 'assets/images/onboarding_2.png',
                        tag: loc.onb2Tag,
                        titleWidget: Text(
                          loc.onb2Title,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: AppTheme.premiumParchment,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        description: loc.onb2Desc,
                      ),
                      _buildNarrativeSlide(
                        context: context,
                        loc: loc,
                        image: 'assets/images/onboarding_3.png',
                        tag: loc.onb3Tag,
                        titleWidget: Text(
                          loc.onb3Title,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: AppTheme.premiumParchment,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        description: loc.onb3Desc,
                      ),
                    ],
                  ),
                ),

                // Footer Section (Progress & Actions)
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                  child: Column(
                    children: [
                      // Architectural Progress Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final isActive = _currentPage == index;
                          return AnimatedContainer(
                            duration: 500.ms,
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            height: 4,
                            width: isActive ? 48 : 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: isActive 
                                ? const LinearGradient(
                                    colors: [AppTheme.restrainedGold, Color(0xFF8D6E1C)],
                                  )
                                : null,
                              color: isActive ? null : AppTheme.premiumParchment.withValues(alpha: 0.15),
                            ),
                          );
                        }),
                      ).animate().fadeIn(delay: 800.ms),

                      const SizedBox(height: 48),

                      Column(
                        children: [
                          _buildPrimaryAction(context, loc, isRtl),
                          const SizedBox(height: 12),
                          if (_currentPage < 2)
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: Text(
                                loc.onboardingSkip.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme.premiumParchment.withValues(alpha: 0.4),
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ).animate().fadeIn(delay: 1000.ms),
                        ],
                      ),
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

  Widget _buildNarrativeSlide({
    required BuildContext context,
    required AppLocalizations loc,
    required String image,
    required String tag,
    required Widget titleWidget,
    required String description,
  }) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Cinematic Image Frame
            Container(
              height: MediaQuery.of(context).size.height * 0.38,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(image, fit: BoxFit.cover),
                    // Luxury Vignette Overlay
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.0,
                          colors: [
                            Colors.transparent,
                            AppTheme.heritageGreenDeep.withValues(alpha: 0.2),
                            AppTheme.heritageGreenDeep.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(key: ValueKey(image))
              .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
              .scale(begin: const Offset(0.95, 0.95), duration: 2000.ms, curve: Curves.easeOut),

            const SizedBox(height: 48),

            // Text Content Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.restrainedGold.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.restrainedGold,
                      letterSpacing: 4,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ).animate(key: ValueKey('tag_$image'))
                  .fadeIn(delay: 200.ms)
                  .slideX(begin: 0.05),

                const SizedBox(height: 24),

                titleWidget.animate(key: ValueKey('title_$image'))
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.1),

                const SizedBox(height: 24),

                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.premiumParchment.withValues(alpha: 0.7),
                    height: 1.6,
                    fontSize: 15,
                  ),
                ).animate(key: ValueKey('desc_$image'))
                  .fadeIn(delay: 600.ms)
                  .slideY(begin: 0.1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryAction(BuildContext context, AppLocalizations loc, bool isRtl) {
    final isLastPage = _currentPage == 2;
    
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppTheme.restrainedGold.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage < 2) {
            _pageController.nextPage(
              duration: 800.ms,
              curve: Curves.easeInOutCubic,
            );
          } else {
            context.go('/login');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.restrainedGold,
          foregroundColor: AppTheme.heritageGreenDeep,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 32), // Space to balance the icon's position
            Expanded(
              child: Text(
                isLastPage ? loc.onboardingNext : loc.onboardingNext,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: isRtl ? 0 : 1.5, // Remove spacing for Arabic
                  fontSize: 14,
                ),
              ),
            ),
            AnimatedRotation(
              turns: isLastPage ? 0.25 : 0,
              duration: 400.ms,
              child: Icon(
                isLastPage ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
