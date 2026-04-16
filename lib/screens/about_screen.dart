import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/cms_content_service.dart';
import 'package:ebzim_app/core/models/cms_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';

// ─────────────────────────────────────────────────────────────────────────────
// About Screen — Ebzim pour la Culture et la Citoyenneté
// Members from statute (Art. 14 — Bureau Exécutif, ratified 14/12/2024)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isFr = Localizations.localeOf(context).languageCode == 'fr';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final partnersAsync = ref.watch(partnersProvider);
    final leadershipAsync = ref.watch(leadershipProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // ── Transparent AppBar with back navigation ────────────────────
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black.withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2)),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
                          color: AppTheme.accentColor,
                          size: 18,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                ),
              ),
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(color: Colors.transparent),
                ),
              ),
              iconTheme: IconThemeData(color: AppTheme.accentColor),
            ),

            // ── HERO — Photo + Cinematic Overlay ──────────────────────────
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height * 0.52,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/about_hero.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.backgroundDark,
                        child: const Icon(Icons.account_balance, size: 80, color: AppTheme.accentColor),
                      ),
                    ),
                  ),
                  // Multi-layer gradient for cinematic look
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.35, 0.75, 1.0],
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            AppTheme.backgroundDark.withValues(alpha: 0.7),
                            isDark ? AppTheme.backgroundDark : const Color(0xFFF3EFE6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // UNESCO Badge top-right
                  Positioned(
                    top: 70,
                    right: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF009FDA).withValues(alpha: 0.5), width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.public_rounded, color: Color(0xFF009FDA), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'UNESCO',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                  ),
                  // Hero text overlay
                  Positioned(
                    bottom: 32,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _GoldPill(
                          label: isAr
                              ? 'جمعية ولائية • سطيف'
                              : isFr
                                  ? 'Association Wilayale • Sétif'
                                  : 'Wilaya Association • Sétif',
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isAr
                              ? 'جمعية إبزيم\nللثقافة والمواطنة'
                              : isFr
                                  ? 'Association Ebzim\npour la Culture et la Citoyenneté'
                                  : 'Ebzim Association\nfor Culture & Citizenship',
                          style: GoogleFonts.tajawal(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.15,
                            shadows: [
                              Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20),
                            ],
                          ),
                        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.15),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── OUR STORY ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _GlassSection(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.auto_stories_outlined,
                        label: isAr ? 'قصتنا' : isFr ? 'Notre Histoire' : 'Our Story',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isAr
                            ? 'تأسست جمعية إبزيم للثقافة والمواطنة في ولاية سطيف، لتُشكّل فضاءً مدنياً راقياً يجمع بين الفعل الثقافي والمواطنة الفاعلة. نشأت من رحم التزام عميق بصون الذاكرة الجزائرية وتعزيز الهوية الحضارية لمنطقة سطيف ذات الإرث الحضاري العريق.'
                            : isFr
                                ? 'Fondée à Sétif, l\'association Ebzim pour la Culture et la Citoyenneté incarne un espace civique d\'excellence, alliant l\'action culturelle à une citoyenneté active. Elle est née d\'un engagement profond pour la sauvegarde de la mémoire algérienne et la valorisation de l\'identité civilisationnelle de la région de Sétif.'
                                : 'Founded in Sétif, the Ebzim Association for Culture and Citizenship embodies a civic space of excellence, combining cultural action with active citizenship. Born from a deep commitment to safeguarding Algerian memory and enhancing the civilizational identity of the Sétif region.',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.75),
                      ),
                      const SizedBox(height: 24),
                      // Quote
                      Container(
                        padding: const EdgeInsetsDirectional.only(start: 18, top: 12, bottom: 12),
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            start: BorderSide(color: AppTheme.accentColor, width: 3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr
                                  ? '"الثقافة ليست ترفاً، بل هي السلاح الأبقى لصون الهوية وبناء المواطن."'
                                  : isFr
                                      ? '"La culture n\'est pas un luxe, c\'est l\'arme la plus durable pour préserver l\'identité et former le citoyen."'
                                      : '"Culture is not a luxury — it is the most enduring weapon for preserving identity and building the citizen."',
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: AppTheme.accentColor,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => context.push('/statute'),
                              icon: const Icon(Icons.gavel_rounded, size: 14),
                              label: Text(
                                isAr ? 'اقرأ القانون الأساسي' : isFr ? 'Lire les statuts' : 'Read Founding Charter',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.accentColor,
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.06),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── MISSION & VISION ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.track_changes_rounded,
                        title: isAr ? 'الرسالة' : isFr ? 'Mission' : 'Mission',
                        body: isAr
                            ? 'نشر الثقافة وتعزيز المواطنة وصون تراث ولاية سطيف الحضاري.'
                            : isFr
                                ? 'Diffuser la culture, renforcer la citoyenneté et préserver le patrimoine de Sétif.'
                                : 'Spread culture, strengthen citizenship, and preserve the heritage of Sétif.',
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.visibility_outlined,
                        title: isAr ? 'الرؤية' : isFr ? 'Vision' : 'Vision',
                        body: isAr
                            ? 'جمعية رائدة تُجسّد نموذج المجتمع المدني الجزائري الفاعل وطنياً ودولياً.'
                            : isFr
                                ? 'Une association pionnière incarnant le modèle de la société civile algérienne active.'
                                : 'A pioneering association embodying the model of active Algerian civil society nationally and internationally.',
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.06),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── STRATEGIC PARTNERSHIPS — Institutional Dossiers ─────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _GlassSection(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.handshake_outlined,
                        label: isAr ? 'شراكاتنا الاستراتيجية' : isFr ? 'Partenariats Stratégiques' : 'Strategic Partnerships',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 20),
                      partnersAsync.when(
                        data: (partners) {
                          if (partners.isEmpty) return _NoDataPlaceholder(isAr: isAr);
                          return Column(
                            children: partners.map((p) => _PartnerDossier(partner: p, lang: isAr ? 'ar' : isFr ? 'fr' : 'en', isDark: isDark)).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => _NoDataPlaceholder(isAr: isAr),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.06),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── RESTORATION PROJECT SHOWCASE ───────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _ProjectShowcaseCard(isDark: isDark, isAr: isAr, isFr: isFr),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.06),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── EXECUTIVE BOARD — Dynamic Leadership ───────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _GlassSection(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.people_alt_outlined,
                        label: isAr ? 'المكتب التنفيذي' : isFr ? 'Bureau Exécutif' : 'Executive Board',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 20),
                      leadershipAsync.when(
                        data: (leaders) {
                          if (leaders.isEmpty) return _NoDataPlaceholder(isAr: isAr);
                          return Column(
                            children: leaders.map((leader) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _DynamicLeaderCard(
                                leader: leader,
                                lang: isAr ? 'ar' : isFr ? 'fr' : 'en',
                                isDark: isDark,
                              ),
                            )).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => _NoDataPlaceholder(isAr: isAr),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.06),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── VALUES ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _GlassSection(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.diamond_outlined,
                        label: isAr ? 'قيمنا' : isFr ? 'Nos Valeurs' : 'Our Values',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _values(isAr, isFr).map((v) => _ValueChip(label: v, isDark: isDark)).toList(),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.06),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── INSTITUTIONAL RESOURCES ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _GlassSection(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.auto_stories_outlined,
                        label: isAr ? 'الموارد المؤسساتية' : isFr ? 'Ressources Institutionnelles' : 'Institutional Resources',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _ResourceButton(
                        label: isAr ? 'المكتبة الرقمية والبحوث' : isFr ? 'Bibliothèque et Recherches' : 'Library & Research',
                        icon: Icons.library_books_outlined,
                        onTap: () => context.push('/library'),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _ResourceButton(
                        label: isAr ? 'القانون الأساسي للجمعية' : isFr ? 'Statut de l\'Association' : 'Association Statute',
                        icon: Icons.gavel_outlined,
                        onTap: () => context.push('/statute'),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 850.ms).slideY(begin: 0.06),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── CTA — JOIN US ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentColor.withValues(alpha: 0.15),
                        AppTheme.accentColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.workspace_premium_rounded, color: AppTheme.accentColor, size: 42),
                      const SizedBox(height: 14),
                      Text(
                        isAr
                            ? 'انضم إلى إبزيم'
                            : isFr
                                ? 'Rejoignez Ebzim'
                                : 'Join Ebzim',
                        style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isAr
                            ? 'كن جزءاً من مجتمع يصنع الفارق في الحفاظ على الهوية الجزائرية'
                            : isFr
                                ? 'Faites partie d\'une communauté qui fait la différence dans la préservation de l\'identité algérienne'
                                : 'Be part of a community making a difference in preserving Algerian identity',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context.push('/membership/discover'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: AppTheme.backgroundDark,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          isAr ? 'قدّم طلب الانخراط' : isFr ? 'Déposer une adhésion' : 'Apply for Membership',
                          style: GoogleFonts.tajawal(fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 900.ms).scale(begin: const Offset(0.97, 0.97)),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────────────────────────────────────

// (Mock classes removed)

// (Board data moved to StatuteService)

List<String> _values(bool isAr, bool isFr) => isAr
    ? ['النزاهة', 'المواطنة الفاعلة', 'صون التراث', 'الإبداع', 'التطوع', 'الشفافية', 'الانفتاح']
    : isFr
        ? ['Intégrité', 'Citoyenneté Active', 'Patrimoine', 'Créativité', 'Bénévolat', 'Transparence', 'Ouverture']
        : ['Integrity', 'Active Citizenship', 'Heritage', 'Creativity', 'Volunteerism', 'Transparency', 'Openness'];

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _GlassSection extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _GlassSection({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppTheme.accentColor.withValues(alpha: 0.12),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  const _SectionHeader({required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentColor, size: 20),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              color: AppTheme.accentColor,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldPill extends StatelessWidget {
  final String label;
  const _GoldPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          color: AppTheme.accentColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final bool isDark;
  const _MiniCard({required this.icon, required this.title, required this.body, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.accentColor.withValues(alpha: isDark ? 0.1 : 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.accentColor, size: 26),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartnerDossier extends StatelessWidget {
  final Partner partner;
  final String lang;
  final bool isDark;
  const _PartnerDossier({required this.partner, required this.lang, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = partner.color != null ? Color(int.parse(partner.color!.replaceFirst('#', '0xFF'))) : AppTheme.accentColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: CachedNetworkImage(
                  imageUrl: partner.logoUrl,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => Icon(Icons.business, color: color),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partner.getName(lang),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'شريك استراتيجي', // Fixed type or could be derived later
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Icon(Icons.verified_rounded, color: color, size: 18),
            ],
          ),
          if (partner.getGoals(lang).isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              partner.getGoals(lang),
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectShowcaseCard extends StatelessWidget {
  final bool isDark;
  final bool isAr;
  final bool isFr;
  const _ProjectShowcaseCard({required this.isDark, required this.isAr, required this.isFr});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/caserne_restoration.png',
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 220,
              color: AppTheme.primaryColor,
              child: const Icon(Icons.apartment_outlined, size: 60, color: AppTheme.accentColor),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isAr ? 'جارٍ التنفيذ' : isFr ? 'En cours' : 'In Progress',
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isAr
                      ? 'ترميم الثكنة العسكرية — الحامة، سطيف'
                      : isFr
                          ? 'Restauration de la Caserne — El Hamman, Sétif'
                          : 'Military Barracks Restoration — El Hamman, Sétif',
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10)],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.military_tech_outlined, color: Colors.white60, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      isAr ? 'وزارة المجاهدين وذوي الحقوق' : isFr ? 'Min. des Moudjahidines' : 'Ministry of Mujahideen',
                      style: const TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DynamicLeaderCard extends StatelessWidget {
  final EbzimLeader leader;
  final String lang;
  final bool isDark;
  const _DynamicLeaderCard({required this.leader, required this.lang, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accentColor.withValues(alpha: 0.1),
            border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3), width: 1),
          ),
          child: leader.photoUrl != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: leader.photoUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Icon(Icons.person, color: AppTheme.accentColor),
                    errorWidget: (context, url, error) => const Icon(Icons.person, color: AppTheme.accentColor),
                  ),
                )
              : const Icon(Icons.person_outline_rounded, color: AppTheme.accentColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leader.getName(lang),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                leader.getRole(lang),
                style: TextStyle(color: AppTheme.accentColor, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoDataPlaceholder extends StatelessWidget {
  final bool isAr;
  const _NoDataPlaceholder({required this.isAr});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
            child: Text(isAr ? 'لا توجد بيانات متاحة حالياً' : 'Aucune donnée disponible',
                style: const TextStyle(color: Colors.grey, fontSize: 12))),
      );
}

class _ValueChip extends StatelessWidget {
  final String label;
  final bool isDark;
  const _ValueChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: isDark ? 0.07 : 0.06),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: isDark ? 0.2 : 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppTheme.accentColor, size: 13),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: isDark ? Colors.white70 : AppTheme.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _ResourceButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.accentColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.accentColor, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

