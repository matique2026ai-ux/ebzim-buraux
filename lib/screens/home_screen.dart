import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/widgets/event_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final loc = AppLocalizations.of(context)!; // Removed to fix unused variable warning
    final lang = ref.watch(localeProvider).languageCode;
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final newsAsync = ref.watch(newsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ════════════════════════════════════════
          // HERO SECTION
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, Color(0xFF003D30), Color(0xFF001A14)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Background geometric pattern
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.04,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                  // Ambient glow
                  Positioned(
                    top: -80, right: -80,
                    child: Container(
                      width: 300, height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.secondaryColor.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Logo
                              Image.asset('assets/images/logo.png', height: 40,
                                  color: Colors.white, colorBlendMode: BlendMode.srcIn),
                              // Nav actions
                              Row(
                                children: [
                                  _GlassIconButton(
                                    icon: Icons.notifications_outlined,
                                    onTap: () => context.push('/notifications'),
                                  ),
                                  const SizedBox(width: 8),
                                  _GlassIconButton(
                                    icon: Icons.translate_outlined,
                                    onTap: () => context.push('/language'),
                                  ),
                                  const SizedBox(width: 8),
                                  _GlassIconButton(
                                    icon: Icons.person_outline,
                                    onTap: () => context.go('/dashboard'),
                                  ),
                                ],
                              ),
                            ],
                          ).animate().fadeIn(duration: 600.ms),

                          const SizedBox(height: 48),

                          // Association label
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              lang == 'ar'
                                  ? 'جمعية ولائية • سطيف • الجزائر'
                                  : 'Association Provinciale • Sétif • Algérie',
                              style: const TextStyle(
                                color: AppTheme.accentColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                          const SizedBox(height: 20),

                          // Main title
                          Text(
                            lang == 'ar'
                                ? 'جمعية إبزيم\nللثقافة والمواطنة'
                                : 'Association Ebzim\npour la Culture\net la Citoyenneté',
                            style: TextStyle(
                              fontFamily: theme.textTheme.headlineLarge?.fontFamily,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.15,
                            ),
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                          const SizedBox(height: 16),

                          Text(
                            lang == 'ar'
                                ? 'نحو حفظ الذاكرة الجماعية وصون الهوية الثقافية\nفي ولاية سطيف'
                                : 'Pour la préservation de la mémoire collective\net l\'identité culturelle de la wilaya de Sétif',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                              height: 1.6,
                            ),
                          ).animate().fadeIn(delay: 400.ms),

                          const SizedBox(height: 36),

                          // CTA Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _HeroButton(
                                  label: lang == 'ar' ? 'طلب عضوية' : 'Demander l\'adhésion',
                                  isPrimary: true,
                                  icon: Icons.card_membership,
                                  onTap: () => context.push('/membership/apply'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _HeroButton(
                                  label: lang == 'ar' ? 'اكتشف الجمعية' : 'Découvrir',
                                  isPrimary: false,
                                  icon: Icons.explore_outlined,
                                  onTap: () => context.go('/dashboard'),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ════════════════════════════════════════
          // STATS STRIP
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatChip(value: '2024', label: lang == 'ar' ? 'تأسست سنة' : 'Fondée en'),
                  _StatDivider(),
                  _StatChip(value: '15+', label: lang == 'ar' ? 'عضو مؤسس' : 'Membres fondateurs'),
                  _StatDivider(),
                  _StatChip(value: '9', label: lang == 'ar' ? 'لجان متخصصة' : 'Comités spécialisés'),
                  _StatDivider(),
                  _StatChip(value: '2', label: lang == 'ar' ? 'شراكة رسمية' : 'Partenariats officiels'),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms),
          ),

          // ════════════════════════════════════════
          // LATEST NEWS
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: _SectionHeader(
                title: lang == 'ar' ? 'آخر الأخبار' : 'Actualités récentes',
                onViewAll: () => context.go('/news'),
                lang: lang,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: newsAsync.when(
              data: (posts) {
                if (posts.isEmpty) return const SizedBox.shrink();
                final pinned = posts.where((p) => p.isPinned).take(2).toList();
                final toShow = pinned.isNotEmpty ? pinned : posts.take(2).toList();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: toShow.map((post) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NewsPreviewCard(post: post, lang: lang),
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: LinearProgressIndicator(color: AppTheme.primaryColor),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),

          // ════════════════════════════════════════
          // PARTNERSHIPS BANNER
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: lang == 'ar' ? 'شركاؤنا الرسميون' : 'Nos partenaires officiels',
                    lang: lang,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _PartnerCard(
                          icon: Icons.museum_outlined,
                          nameAr: 'المتحف الوطني للآثار',
                          nameFr: 'Musée National des Antiquités',
                          city: 'Sétif',
                          color: AppTheme.heritageRed,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PartnerCard(
                          icon: Icons.school_outlined,
                          nameAr: 'جامعة سطيف',
                          nameFr: 'Université de Sétif',
                          city: 'Architecture',
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
          ),

          // ════════════════════════════════════════
          // UPCOMING EVENTS
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
              child: _SectionHeader(
                title: lang == 'ar' ? 'الأنشطة القادمة' : 'Activités à venir',
                onViewAll: () => context.go('/activities'),
                lang: lang,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: eventsAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return Center(
                      child: Text(
                        lang == 'ar' ? 'لا توجد أنشطة مجدولة' : 'Aucune activité planifiée',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: events.take(6).length,
                    itemBuilder: (context, index) => EventCard(
                      event: events[index],
                      onTap: () => context.push('/event/${events[index].id}'),
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppTheme.primaryColor, strokeWidth: 2),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
          ),

          // ════════════════════════════════════════
          // ABOUT TEASER
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, const Color(0xFF004B3E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang == 'ar' ? 'من نحن؟' : 'Qui sommes-nous ?',
                    style: const TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lang == 'ar'
                        ? 'جمعية إبزيم للثقافة والمواطنة جمعية ولائية مقرها سطيف، مصادق عليها وفق القانون 06/12 المؤرخ في 12 جانفي 2012.'
                        : 'L\'association Ebzim est une association provinciale basée à Sétif, fondée conformément à la loi 06/12 du 12 janvier 2012.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.push('/about'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang == 'ar' ? 'اقرأ أكثر' : 'En savoir plus',
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, color: AppTheme.accentColor, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ══ Reusable Components ══

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final IconData icon;
  final VoidCallback onTap;
  const _HeroButton({required this.label, required this.isPrimary, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.accentColor : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPrimary ? Colors.transparent : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isPrimary ? Colors.white : Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? Colors.white : Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: Colors.grey.shade200);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final String lang;
  const _SectionHeader({required this.title, this.onViewAll, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              lang == 'ar' ? 'عرض الكل' : 'Voir tout',
              style: const TextStyle(
                color: AppTheme.secondaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class _NewsPreviewCard extends StatelessWidget {
  final NewsPost post;
  final String lang;
  const _NewsPreviewCard({required this.post, required this.lang});

  @override
  Widget build(BuildContext context) {
    final isPartnership = post.category == 'PARTNERSHIP';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPartnership
              ? const Color(0xFFBFDBFE)
              : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon or Category indicator
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: isPartnership
                  ? const Color(0xFFEFF6FF)
                  : AppTheme.primaryColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPartnership ? Icons.handshake : Icons.campaign_outlined,
              color: isPartnership ? const Color(0xFF0369A1) : AppTheme.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.partnerName != null)
                  Text(
                    post.partnerName!,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0369A1),
                      letterSpacing: 0.5,
                    ),
                  ),
                if (post.partnerName != null) const SizedBox(height: 2),
                Text(
                  post.getTitle(lang),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${post.publishedAt.day}/${post.publishedAt.month}/${post.publishedAt.year}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final IconData icon;
  final String nameAr;
  final String nameFr;
  final String city;
  final Color color;
  const _PartnerCard({
    required this.icon,
    required this.nameAr,
    required this.nameFr,
    required this.city,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            nameAr,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            city,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
