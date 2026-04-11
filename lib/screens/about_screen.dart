import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

Color _textPr(BuildContext c) => Theme.of(c).brightness == Brightness.dark ? Colors.white : const Color(0xFF0A2B1D); // Deep Emerald
Color _textSec(BuildContext c) => Theme.of(c).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF1C4D35).withValues(alpha: 0.8);
Color _textHighlight(BuildContext c) => Theme.of(c).brightness == Brightness.dark ? Colors.white : const Color(0xFF8B2F2F); // Brick Red Highlight

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const EbzimSliverAppBar(),
            // ── HERO SECTION ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 160, 24, 40),
                child: Column(
                  children: [
                    const Icon(Icons.account_balance, color: AppTheme.accentColor, size: 48)
                        .animate().fadeIn().scale(delay: 200.ms),
                    const SizedBox(height: 24),
                    Text(
                      loc.aboutHeroTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _textPr(context),
                        height: 1.2,
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    const SizedBox(height: 16),
                    Text(
                      loc.aboutHeroSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textSec(context),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                  ],
                ),
              ),
            ),

            // ── OUR STORY ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Badge(label: loc.aboutStoryBadge),
                      const SizedBox(height: 16),
                      Text(
                        loc.aboutStoryTitle,
                        style: GoogleFonts.tajawal(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: _textPr(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        loc.aboutStoryText1,
                        style: TextStyle(
                          fontSize: 15,
                          color: _textSec(context),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        decoration: const BoxDecoration(
                          border: BorderDirectional(
                            start: BorderSide(color: AppTheme.accentColor, width: 3),
                          ),
                        ),
                        child: Text(
                          loc.aboutStoryQuote,
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.accentColor.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.05),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── MISSION & VISION ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _SmallInfoCard(
                        icon: Icons.track_changes,
                        title: loc.aboutMission,
                        desc: loc.aboutMissionText,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SmallInfoCard(
                        icon: Icons.auto_graph,
                        title: loc.aboutVision,
                        desc: loc.aboutVisionText,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.05),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── VALUES ───────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Badge(label: loc.aboutValues),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ValueTag(label: loc.aboutValue1),
                          _ValueTag(label: loc.aboutValue2),
                          _ValueTag(label: loc.aboutValue3),
                          _ValueTag(label: loc.aboutValue4),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.05),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── HEADQUARTERS ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Badge(label: loc.aboutHqBadge),
                            const SizedBox(height: 16),
                            Text(
                              loc.aboutHqTitle,
                              style: GoogleFonts.tajawal(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _textPr(context),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              loc.aboutHqText,
                              style: TextStyle(
                                fontSize: 14,
                                color: _textSec(context),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const NetworkImage(
                              'https://placehold.co/600x400/020f08/c5a059?text=Setif+Algeria+HQ',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withValues(alpha: 0.2),
                              BlendMode.multiply,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.05),
            ),

            // ── QUOTE ────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
                child: Column(
                  children: [
                    const Icon(Icons.format_quote, color: AppTheme.accentColor, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      loc.aboutQuote,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 22,
                        color: _textHighlight(context),
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(width: 40, height: 1, color: AppTheme.accentColor.withValues(alpha: 0.4)),
                    const SizedBox(height: 16),
                    Text(
                      loc.aboutQuoteAuthor.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1600.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.accentColor,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _SmallInfoCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.accentColor, size: 28),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: _textPr(context),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _textSec(context),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueTag extends StatelessWidget {
  final String label;
  const _ValueTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFF8B2F2F).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFF8B2F2F).withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.accentColor, size: 14),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF8B2F2F), 
              fontSize: 13, 
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}
