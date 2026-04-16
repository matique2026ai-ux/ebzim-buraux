import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/services/storage_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: EbzimBackground(
        child: Stack(
          children: [
            // ── Centre Content ──
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      // ── Logo ──
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  width: 132,
                                  height: 132,
                                  padding: const EdgeInsets.all(28),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.3),
                                        Colors.white.withValues(alpha: 0.1),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 30,
                                        offset: const Offset(0, 15),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // Gold accent badge
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF0E0C8),
                                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                                ),
                                child: const Icon(Icons.auto_awesome, color: Color(0xFF4F4533), size: 24),
                              ),
                            ),
                          ],
                        ),
                      ).animate()
                          .fadeIn(duration: 900.ms)
                          .scale(curve: Curves.easeOutBack)
                          .rotate(begin: -0.05, end: 0, duration: 1200.ms, curve: Curves.easeOut),

                      const SizedBox(height: 56),

                      // ── Arabic Title ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'جمعية إبزيم للثقافة والمواطنة',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontSize: 52,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                            shadows: const [
                              Shadow(color: Color(0x66000000), blurRadius: 12, offset: Offset(0, 6)),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                      const SizedBox(height: 12),

                      // ── French Subtitle ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: const Text(
                          'Association Ebzim pour la Culture et la Citoyenneté',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFD3C5AD),
                            letterSpacing: -0.3,
                            height: 1.4,
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

                      const SizedBox(height: 8),

                      // ── Establishment Tag ──
                      Text(
                        'SÉTIF  ·  ALGÉRIE  ·  EST. 2024',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.0,
                          color: const Color(0xFF9DF888).withValues(alpha: 0.6),
                        ),
                      ).animate().fadeIn(delay: 700.ms),

                      const SizedBox(height: 48),

                      // ── Action Button ──
                      Container(
                        width: 200,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFF0E0C8).withValues(alpha: 0.3)),
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: _redirect,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'استكشف',
                                style: GoogleFonts.tajawal(
                                  fontSize: 22,
                                  color: const Color(0xFFF0E0C8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.arrow_forward_rounded, color: Color(0xFFF0E0C8), size: 20),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),

            // ── Language Toggle (top-left) ──
            Positioned(
              top: MediaQuery.of(context).padding.top + 24,
              left: 24,
              child: GestureDetector(
                onTap: () => context.push('/language'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.translate, color: Colors.white, size: 14),
                      SizedBox(width: 6),
                      Text('EN | FR | AR', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms),
            ),

            // ── Bottom Signature ──
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              right: 24,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('PATRIMOINE CULTUREL', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  Text('EST. DÉCEMBRE 2024', style: TextStyle(color: Color(0xFFF0E0C8), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                ],
              ).animate().fadeIn(delay: 1200.ms),
            ),

            // ── Bottom Tonal Fade ──
            Positioned(
              bottom: 0, left: 0, right: 0, height: 120,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppTheme.primaryColor.withValues(alpha: 0.8)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
