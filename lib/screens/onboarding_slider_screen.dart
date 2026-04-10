import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

class OnboardingSliderScreen extends ConsumerStatefulWidget {
  const OnboardingSliderScreen({super.key});

  @override
  ConsumerState<OnboardingSliderScreen> createState() => _OnboardingSliderScreenState();
}

class _OnboardingSliderScreenState extends ConsumerState<OnboardingSliderScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    } else {
      context.go('/login');
    }
  }

  void _skip() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF), // surface
      body: Stack(
        children: [
          // Background Artistic Elements (Slide 1 specific but ok to leave global)
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 384, height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF004900).withValues(alpha: 0.05),
                boxShadow: const [BoxShadow(color: Color(0xFF004900), blurRadius: 100)],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4, left: -200,
            child: Container(
              width: 512, height: 512,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0E0C8).withValues(alpha: 0.2),
                boxShadow: const [BoxShadow(color: Color(0xFFF0E0C8), blurRadius: 120)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Global Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/logo.png', height: 40),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3FA),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFBFCAB7).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            _buildLangTab('FR', ref.watch(localeProvider).languageCode == 'fr'),
                            _buildLangTab('AR', ref.watch(localeProvider).languageCode == 'ar'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSlide1(),
                      _buildSlide2(),
                      _buildSlide3(),
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

  Widget _buildLangTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : const Color(0xFF404A3B),
        ),
      ),
    );
  }

  // --- SLIDE 1 (Mission) ---
  Widget _buildSlide1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          // Image / Render
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
              boxShadow: const [
                BoxShadow(color: Color(0x1F004900), offset: Offset(0, 40), blurRadius: 60, spreadRadius: -15)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/onboarding_1.png', fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppTheme.primaryColor.withValues(alpha: 0.3), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Content Overlay
          Transform.translate(
            offset: const Offset(0, -60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.museum, color: AppTheme.primaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'THE HERITAGE FOUNDATION',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.secondaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A Legacy of\nCulture & Duty.',
                    style: TextStyle(
                      fontFamily: Theme.of(context).textTheme.headlineLarge?.fontFamily,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Join Association Ebzim in our mission to curate the heritage of Sétif, bridging ancestral wisdom with the digital citizenship of tomorrow.',
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7), height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          
          _buildBottomActions('Begin Journey', Icons.arrow_forward),
        ],
      ),
    );
  }

  // --- SLIDE 2 (Activities) ---
  Widget _buildSlide2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDDEC5).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEDDEC5)),
            ),
            child: const Text('THE MODERN COLLECTIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF6C614E))),
          ),
          const SizedBox(height: 16),
          Text(
            'Experience the soul of Sétif in motion.',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headlineLarge?.fontFamily,
              fontSize: 40,
              color: AppTheme.primaryColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'From artisan workshops to ancestral celebrations, your journey through our shared heritage starts with your participation.',
            style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 32),

          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xFFF3F3FA),
              boxShadow: const [BoxShadow(color: Color(0x14004900), blurRadius: 20)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/onboarding_2.png', fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24, left: 24, right: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('FEATURED EVENT', style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 2)),
                              const SizedBox(height: 4),
                              Text('The Great Roman Gala', style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 24, color: Colors.white, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.arrow_outward, color: Colors.white, size: 20),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 48),
          _buildBottomActions('Discover Your Community', Icons.arrow_forward),
        ],
      ),
    );
  }

  // --- SLIDE 3 (Joining / Form placeholder) ---
  Widget _buildSlide3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('STEP 03 — FINAL STEP', style: TextStyle(fontSize: 10, color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 16),
          Text(
            'Become a Curator of Living Heritage.',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headlineLarge?.fontFamily,
              fontSize: 40,
              color: AppTheme.primaryColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Join Association Ebzim to participate in the digital preservation of Sétif\'s cultural legacy.',
            style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 32),

          // Stacked Visual Card for Identity
          Container(
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(56),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 40)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(56),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/onboarding_3.png', fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppTheme.primaryColor.withValues(alpha: 0.8), Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24, left: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.shield, color: AppTheme.primaryColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Secure Digital ID', style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 18, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                                Text('Verified credentials for archives.', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          _buildBottomActions('Join the Movement', Icons.group_add),
        ],
      ),
    );
  }

  Widget _buildBottomActions(String primaryText, IconData icon) {
    return Column(
      children: [
        // Progress Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final active = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: active ? 40 : 10,
              decoration: BoxDecoration(
                color: active ? AppTheme.primaryColor : const Color(0xFFBFCAB7).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 10,
            shadowColor: AppTheme.primaryColor.withValues(alpha: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(primaryText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 12),
              Icon(icon, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _skip,
          child: Text(
            'SKIP FOR NOW',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
