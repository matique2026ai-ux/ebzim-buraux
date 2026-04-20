import 'dart:ui';
import 'package:ebzim_app/core/common_widgets/ebzim_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/services/storage_service.dart';
import 'package:ebzim_app/core/services/auth_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    // Proactive check: if session is already loaded or loads while on splash, move immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndAutoRedirect();
      // Add a slight delay for institutional branding wow-factor, then auto-redirect if not already handled
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          final auth = ref.read(authProvider);
          if (!auth.isAuthenticated) {
            _redirect();
          }
        }
      });
    });
  }

  void _checkAndAutoRedirect() {
    final auth = ref.read(authProvider);
    // If we already know the user is authenticated from a previous fast-loading session
    if (auth.isAuthenticated && !auth.isInitializing) {
      _performAuthenticatedRedirect(auth);
    }
  }

  void _performAuthenticatedRedirect(AuthState auth) {
    final role = auth.user?.membershipLevel ?? 'USER';
    final isAdmin = role == 'ADMIN' || role == 'SUPER_ADMIN';
    context.go(isAdmin ? '/admin' : '/home');
  }

  Future<void> _redirect() async {
    if (!mounted) return;
    final storage = ref.read(storageServiceProvider);
    final isFirstLaunch = await storage.isFirstLaunch();
    final token = await storage.getToken();
    
    if (!mounted) return;
    
    if (isFirstLaunch) {
      context.go('/language');
    } else if (token != null) {
      context.go('/dashboard');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // Reactive listener: if auth state completes while we are here, jump out
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && !next.isInitializing) {
        _performAuthenticatedRedirect(next);
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: EbzimBackground(
        child: Stack(
          children: [
            // ── Ambient Floating Particles ──
            ...List.generate(6, (index) => Positioned(
              top: (index * 150.0) % size.height,
              left: (index * 200.0) % size.width,
              child: Icon(
                Icons.auto_awesome, 
                color: AppTheme.accentColor.withOpacity(0.1), 
                size: 20 + (index * 5.0)
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                .fadeIn(duration: 2.seconds)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: (2 + index).seconds)
                .moveY(begin: 0, end: -30, duration: (3 + index).seconds, curve: Curves.easeInOut),
            )),

            // ── Main Content ──
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // ── Interactive Logo with Halo ──
                      _buildGlowingLogo(),

                      const SizedBox(height: 60),

                      // ── Institutional Titles ──
                      _buildTitles(isAr),

                      const SizedBox(height: 56),

                      // ── Action Button ──
                      _buildExploreButton(context),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            // ── Top Bar (Language & Navigation) ──
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLanguageToggle(context),
                ],
              ),
            ),

            // ── Bottom Signature ──
            _buildBottomSignature(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowingLogo() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds, curve: Curves.easeInOut),

          // Logo Container
          Container(
            width: 140,
            height: 140,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0A1A0A).withOpacity(0.6),
              border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 1.5),
            ),
            child: const EbzimLogo(
              size: 80,
              color: AppTheme.accentColor,
            ),
          ).animate()
           .fadeIn(duration: 800.ms)
           .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack)
           .shimmer(delay: 1.seconds, duration: 1500.ms, color: Colors.white24),

          // Sparkle Detail (Star & Crescent - Algerian Identity)
          Positioned(
            top: 15,
            right: 15,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Star
                const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 22)
                  .animate(onPlay: (c) => c.repeat())
                  .rotate(duration: 3.seconds)
                  .scale(begin: const Offset(0.6, 0.6), end: const Offset(1.0, 1.0), duration: 1.seconds, curve: Curves.easeInOut),
                
                // Crescent (Offset to the left of the star)
                Transform.translate(
                  offset: const Offset(-12, 0),
                  child: Icon(Icons.nightlight_round, color: AppTheme.accentColor.withOpacity(0.8), size: 20)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveX(begin: -2, end: 2, duration: 2.seconds, curve: Curves.easeInOut)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 1.5.seconds),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitles(bool isAr) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'جمعية إبزيم للثقافة والمواطنة',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -0.5,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0, duration: 600.ms, curve: Curves.easeOut),

        const SizedBox(height: 16),

        // English Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Ebzim Association for Culture and Citizenship',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.accentColor.withOpacity(0.8),
              letterSpacing: 0.5,
              height: 1.5,
            ),
          ),
        ).animate().fadeIn(delay: 600.ms).moveY(begin: 10, end: 0, duration: 600.ms),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: const Text(
            'SÉTIF  ·  ALGÉRIE  ·  EST. 2024',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0,
              color: Colors.white54,
            ),
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }

  Widget _buildExploreButton(BuildContext context) {
    return Container(
      width: 220,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accentColor,
            AppTheme.accentColor.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: _redirect,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Localizations.localeOf(context).languageCode == 'ar' ? 'استكشف' : 'Découvrir',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 28),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1.seconds).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
  }

  Widget _buildLanguageToggle(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/language'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.translate_rounded, color: AppTheme.accentColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  'EN | FR | AR', 
                  style: GoogleFonts.inter(
                    color: Colors.white, 
                    fontSize: 10, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 1.5
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1200.ms).moveX(begin: -20, end: 0);
  }

  Widget _buildBottomSignature(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 20,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EbzimLogo(size: 16, isEngraved: true),
              const SizedBox(width: 8),
              const Text(
                'PATRIMOINE CULTUREL & CITOYENNETÉ', 
                style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 2.5)
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'COPYRIGHT © AKROUR TOUFIK', 
            style: TextStyle(color: AppTheme.accentColor, fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 1.5)
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 1500.ms),
    );
  }
}
