import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/services/cms_content_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/widgets/event_card.dart';
import 'package:ebzim_app/core/models/cms_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/services/web_helper.dart';
import 'package:video_player/video_player.dart';
import 'package:ebzim_app/widgets/stats_strip.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final lang = ref.watch(localeProvider).languageCode;
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final newsAsync = ref.watch(newsProvider);
    final slidesAsync = ref.watch(heroSlidesProvider);
    final partnersAsync = ref.watch(partnersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ════════════════════════════════════════
          // DYNAMIC HERO CAROUSEL
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: slidesAsync.when(
              data: (slides) {
                if (slides.isEmpty) return _FallbackHero(lang: lang);
                return _SunriseCarousel(slides: slides, lang: lang);
              },
              loading: () => _HeroLoading(),
              error: (_, __) => _FallbackHero(lang: lang),
            ),
          ),

          // ════════════════════════════════════════
          // STATS STRIP
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: const StatsStrip()
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 400))
                .slideY(begin: 0.05),
          ),

          // ════════════════════════════════════════
          // PLATFORM INTRO (Digital House of Ebzim)
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _PublicPlatformCard(loc: loc),
            ),
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
                // Filter to only show general news/announcements, excluding projects
                final newsPosts = posts.where((p) => 
                  p.category.toUpperCase() == 'ANNOUNCEMENT' || 
                  p.category.isEmpty
                ).toList();

                if (newsPosts.isEmpty) return const SizedBox.shrink();
                
                final pinned = newsPosts.where((p) => p.isPinned).take(2).toList();
                final toShow = pinned.isNotEmpty ? pinned : newsPosts.take(2).toList();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: toShow.asMap().entries.map((entry) {
                      final i = entry.key;
                      final post = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NewsPreviewCard(post: post, lang: lang)
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: i * 100), duration: const Duration(milliseconds: 600))
                            .slideY(begin: 0.1),
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
          // INSTITUTIONAL PROJECTS SECTION
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: _SectionHeader(
                title: lang == 'ar' ? 'المشاريع المؤسساتية' : 'Projets Institutionnels',
                onViewAll: () => context.go('/heritage'),
                lang: lang,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: newsAsync.when(
              data: (posts) {
                // Filter specifically for projects
                final projects = posts.where((p) => 
                  p.category.toUpperCase() != 'ANNOUNCEMENT' && 
                  p.category.isNotEmpty
                ).take(4).toList();

                if (projects.isEmpty) return const SizedBox.shrink();

                return SizedBox(
                  height: 360,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (ctx, index) {
                      final project = projects[index];
                      return _HomeProjectCard(
                        project: project,
                        lang: lang,
                        isDark: theme.brightness == Brightness.dark,
                      ).animate(delay: (index * 150).ms).fadeIn(duration: 600.ms).slideX(begin: 0.1);
                    },
                  ),
                );
              },
              loading: () => const SizedBox(height: 340, child: Center(child: CircularProgressIndicator())),
              error: (_, __) => const SizedBox.shrink(),
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
                  partnersAsync.when(
                    data: (partners) {
                      if (partners.isEmpty) return const SizedBox.shrink();
                      return SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: partners.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (ctx, index) {
                            final p = partners[index];
                            return _DynamicPartnerCard(partner: p, lang: lang);
                          },
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox.shrink(),
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
                    ).animate(delay: Duration(milliseconds: index * 150)).fadeIn(duration: const Duration(milliseconds: 600)).slideX(begin: 0.1),
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
          // INSTITUTIONAL SECTION
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: _InstitutionalSection(lang: lang),
            ),
          ),

          // ════════════════════════════════════════
          // ABOUT TEASER
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF081C10), Color(0xFF042D1A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: AppTheme.accentColor.withOpacity(0.1), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            lang == 'ar' ? 'رسالتنا الثقافية' : 'NOTRE MISSION',
                            style: const TextStyle(
                              color: AppTheme.accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          lang == 'ar' ? 'من نحن؟' : 'Qui sommes-nous ?',
                          style: GoogleFonts.tajawal(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          lang == 'ar'
                              ? 'جمعية إبزيم للثقافة والمواطنة جمعية ولائية مقرها سطيف، مصادق عليها وفق القانون 06/12 المؤرخ في 12 جانفي 2012.'
                              : 'L\'association Ebzim est une association provinciale basée à Sétif, fondée conformément à la loi 06/12 du 12 janvier 2012.',
                          style: GoogleFonts.cairo(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: () => context.push('/about'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  lang == 'ar' ? 'اكتشف المزيد' : 'Découvrir plus',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  lang == 'ar' ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(delay: 3.seconds, duration: 2.seconds),
                      ],
                    ),
                  ),
                  // Decorative Icon
                  Positioned(
                    bottom: -20,
                    left: lang == 'ar' ? -20 : null,
                    right: lang == 'fr' ? -20 : null,
                    child: Opacity(
                      opacity: 0.05,
                      child: Icon(Icons.account_balance_rounded, size: 180, color: Colors.white),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(begin: -0.05, end: 0.05, duration: 5.seconds),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
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
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary ? [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: 300.ms,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: isPrimary ? LinearGradient(
                colors: [AppTheme.accentColor, AppTheme.accentColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ) : null,
              color: isPrimary ? null : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPrimary ? Colors.white24 : Colors.white.withOpacity(0.1),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroVideoCardBackground extends StatefulWidget {
  final String videoUrl;
  const _HeroVideoCardBackground({required this.videoUrl});

  @override
  State<_HeroVideoCardBackground> createState() => _HeroVideoCardBackgroundState();
}

class _HeroVideoCardBackgroundState extends State<_HeroVideoCardBackground> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          _controller.setLooping(true);
          _controller.setVolume(0);
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();
    return SizedOverflowBox(
      size: Size.infinite,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final String lang;
  const _SectionHeader({required this.title, this.onViewAll, required this.lang});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : AppTheme.primaryColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.accentColor, Colors.transparent]),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ).animate().scaleX(begin: 0, end: 1, duration: 600.ms, curve: Curves.easeOutBack),
          ],
        ),
        if (onViewAll != null)
          Semantics(
            label: lang == 'ar' ? 'عرض الكل' : 'Voir tout',
            button: true,
            child: GestureDetector(
              onTap: onViewAll,
              child: Container(
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.accentColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang == 'ar' ? 'عرض الكل' : 'Voir tout',
                      style: lang == 'ar'
                          ? GoogleFonts.cairo(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold)
                          : GoogleFonts.playfairDisplay(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    Icon(lang == 'ar' ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
                        color: AppTheme.accentColor, size: 10),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAr = lang == 'ar';
    
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1A0F) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: post.isPinned 
              ? AppTheme.accentColor.withOpacity(0.3) 
              : (isDark ? Colors.white.withOpacity(0.05) : AppTheme.primaryColor.withOpacity(0.05)),
          width: post.isPinned ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: post.isPinned 
                ? AppTheme.accentColor.withOpacity(0.1) 
                : Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/news/${post.id}', extra: post),
          borderRadius: BorderRadius.circular(28),
          child: Row(
            children: [
              // Image or Placeholder
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: isAr ? Radius.zero : const Radius.circular(28),
                  right: isAr ? const Radius.circular(28) : Radius.zero,
                ),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      post.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: post.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (ctx, url) => Container(color: Colors.black12),
                              errorWidget: (ctx, url, err) => _buildPlaceholder(isDark),
                            )
                          : _buildPlaceholder(isDark),
                      if (post.isPinned)
                        Positioned(
                          top: 8,
                          left: isAr ? 8 : null,
                          right: isAr ? null : 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                            child: const Icon(Icons.push_pin_rounded, size: 10, color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (post.isPinned ? AppTheme.accentColor : AppTheme.primaryColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          post.category.toUpperCase(),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: post.isPinned ? AppTheme.accentColor : (isDark ? Colors.white70 : AppTheme.primaryColor),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        post.getTitle(lang),
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                          color: isDark ? Colors.white : AppTheme.primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.event_note_rounded, size: 12, color: theme.hintColor.withOpacity(0.5)),
                          const SizedBox(width: 6),
                          Text(
                            '${post.publishedAt.day}/${post.publishedAt.month}/${post.publishedAt.year}',
                            style: GoogleFonts.outfit(fontSize: 11, color: theme.hintColor.withOpacity(0.7), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                  color: AppTheme.accentColor.withOpacity(0.3),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? Colors.white.withOpacity(0.1) : AppTheme.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.newspaper_rounded,
          color: isDark ? Colors.white12 : AppTheme.primaryColor.withOpacity(0.1),
          size: 32,
        ),
      ),
    );
  }
}

class _DynamicPartnerCard extends StatelessWidget {
  final Partner partner;
  final String lang;
  const _DynamicPartnerCard({required this.partner, required this.lang});

  @override
  Widget build(BuildContext context) {
    final color = partner.color != null ? Color(int.parse(partner.color!.replaceFirst('#', '0xFF'))) : AppTheme.primaryColor;
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: partner.logoUrl,
              placeholder: (context, url) => Container(color: Colors.grey.shade50),
              errorWidget: (context, url, error) => const Icon(Icons.business, size: 40, color: Colors.grey),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            partner.getName(lang),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SunriseCarousel extends ConsumerStatefulWidget {
  final List<HeroSlide> slides;
  final String lang;
  const _SunriseCarousel({required this.slides, required this.lang});

  @override
  ConsumerState<_SunriseCarousel> createState() => _SunriseCarouselState();
}

class _SunriseCarouselState extends ConsumerState<_SunriseCarousel> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 6), () {
      if (!mounted) return;
      final nextIndex = (_currentIndex + 1) % widget.slides.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOutQuart,
      );
      setState(() => _currentIndex = nextIndex);
      _startTimer();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image with Cross-fade (Sunrise effect)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemCount: widget.slides.length,
            itemBuilder: (context, index) {
              final slide = widget.slides[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: slide.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(color: AppTheme.primaryColor),
                      ).animate().fadeIn(duration: 1200.ms),
                      // Overlay Gradient (Dynamic based on slide design)
                      Builder(
                        builder: (context) {
                          Color baseColor = AppTheme.primaryColor;
                          if (slide.glassColor != null && slide.glassColor!.isNotEmpty) {
                            try {
                              String hex = slide.glassColor!.replaceFirst('#', '');
                              if (hex.length == 3) hex = hex.split('').map((e) => e + e).join('');
                              if (hex.length == 6) hex = 'FF' + hex;
                              baseColor = Color(int.parse(hex, radix: 16));
                            } catch (_) {}
                          }
                          
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.2),
                                  baseColor.withOpacity(slide.overlayOpacity),
                                  baseColor,
                                ],
                              ),
                            ),
                          );
                        }
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // Content Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo & Top Actions
                  _buildTopBar(context),
                  const Spacer(),
                  // Dynamic Slide Content
                  _buildSlideContent(widget.slides[_currentIndex]),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Hero(
          tag: 'app_logo',
          child: Image.asset('assets/images/logo.png', height: 44, color: Colors.white, colorBlendMode: BlendMode.srcIn),
        ),
        Row(
          children: [
            if (kDebugMode)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: _GlassIconButton(
                  icon: Icons.logout_rounded, 
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ),
            _GlassIconButton(icon: Icons.translate_outlined, onTap: () => context.push('/language')),
            const SizedBox(width: 8),
            _GlassIconButton(icon: Icons.person_outline, onTap: () => context.go('/dashboard')),
          ],
        ),
      ],
    ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: -0.2);
  }

  Widget _buildSlideContent(HeroSlide slide) {
    final theme = Theme.of(context);
    final hasContent = slide.getTitle(widget.lang).trim().isNotEmpty || slide.getSubtitle(widget.lang).trim().isNotEmpty;
    
    // Check membership status to conditionally show 'Join Now'
    final userState = ref.watch(currentUserProvider);
    final user = userState.value;
    final role = user?.membershipLevel ?? 'PUBLIC';
    final isMember = role == 'MEMBER' || role == 'ADMIN' || role == 'SUPER_ADMIN';

    // Robust color parsing for the masterpiece glass
    Color glassBaseColor = Colors.black.withOpacity(0.1);
    if (slide.glassColor != null && slide.glassColor!.isNotEmpty) {
      try {
        String hex = slide.glassColor!.replaceFirst('#', '');
        if (hex.length == 3) hex = hex.split('').map((e) => e + e).join(''); // Handle #F00 -> #FF0000
        if (hex.length == 6) hex = 'FF' + hex;
        glassBaseColor = Color(int.parse(hex, radix: 16)).withOpacity(slide.overlayOpacity);
      } catch (_) {
        // Fallback to primary if invalid
        glassBaseColor = AppTheme.primaryColor.withOpacity(slide.overlayOpacity);
      }
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: glassBaseColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Stack(
              children: [
                // Video Background inside Card
                if (slide.videoUrl != null && slide.videoUrl!.isNotEmpty)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.3, // Faint video as requested
                      child: _HeroVideoCardBackground(videoUrl: slide.videoUrl!),
                    ),
                  ),

                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasContent) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          widget.lang == 'ar' ? 'اكتشف إرثنا' : 'DISCOVER HERITAGE',
                          style: GoogleFonts.playfairDisplay(
                            color: AppTheme.accentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ).animate(key: ValueKey('chip_${slide.id}')).fadeIn(duration: 600.ms).slideX(begin: -0.1),
                      const SizedBox(height: 24),
                      Text(
                        slide.getTitle(widget.lang),
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 38,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          shadows: [Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 2))],
                        ),
                      ).animate(key: ValueKey('title_${slide.id}')).fadeIn(delay: 100.ms, duration: 800.ms).slideY(begin: 0.1),
                      const SizedBox(height: 18),
                      Text(
                        slide.getSubtitle(widget.lang),
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.7,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate(key: ValueKey('sub_${slide.id}')).fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.1),
                      const SizedBox(height: 40),
                    ],

                    // Mind-blowing Buttons
                    if (slide.buttonText != null && slide.buttonText!.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _HeroButton(
                              label: slide.buttonText!,
                              isPrimary: true,
                              icon: Icons.auto_awesome_rounded,
                              onTap: () {
                                if (slide.buttonLink != null && slide.buttonLink!.isNotEmpty) {
                                  if (slide.buttonLink!.startsWith('http')) {
                                    WebHelper.launchURL(slide.buttonLink!);
                                  } else {
                                    context.push(slide.buttonLink!);
                                  }
                                }
                              },
                            ).animate(key: ValueKey('btn1_${slide.id}')).scale(delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          if (!isMember) ...[
                            Expanded(
                              child: _HeroButton(
                                label: widget.lang == 'ar' ? 'طلب عضوية' : 'Join Now',
                                isPrimary: true,
                                icon: Icons.auto_awesome_rounded,
                                onTap: () => context.push('/membership/apply'),
                              ).animate(key: ValueKey('btn1_${slide.id}')).scale(delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut),
                            ),
                            const SizedBox(width: 16),
                          ],
                          Expanded(
                            child: _HeroButton(
                              label: widget.lang == 'ar' ? 'تصفح النشاطات' : 'Explore',
                              isPrimary: isMember ? true : false,
                              icon: Icons.rocket_launch_rounded,
                              onTap: () => context.go('/activities'),
                            ).animate(key: ValueKey('btn2_${slide.id}')).scale(delay: 500.ms, duration: 600.ms, curve: Curves.elasticOut),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 1.seconds).scale(begin: const Offset(0.95, 0.95));
  }
}

class _FallbackHero extends StatelessWidget {
  final String lang;
  const _FallbackHero({required this.lang});
  @override
  Widget build(BuildContext context) => Container(height: 300, color: AppTheme.primaryColor, child: const Center(child: Text("EBZIM")));
}

class _HeroLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(height: 520, color: AppTheme.primaryColor.withOpacity(0.1), child: const Center(child: CircularProgressIndicator()));
}

// ─────────────────────────────────────────────────────────────────────────────
// INSTITUTIONAL SECTION — Heritage Projects + Civic Report
// ─────────────────────────────────────────────────────────────────────────────
class _InstitutionalSection extends StatelessWidget {
  final String lang;
  const _InstitutionalSection({required this.lang});

  @override
  Widget build(BuildContext context) {
    final isAr = lang == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              width: 36, height: 3,
              decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(2)),
              margin: const EdgeInsetsDirectional.only(end: 12),
            ),
            Text(
              (isAr ? 'ابزيم تعمل • مشاريع ميدانية' : 'Ebzim en action • Projets terrain').toUpperCase(),
              style: GoogleFonts.playfairDisplay(
                color: AppTheme.accentColor,
                fontSize: 10,
                letterSpacing: 3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 520.ms),
        const SizedBox(height: 18),

        // Diverse Projects Card
        _InstitutionalCard(
          icon: Icons.apartment_outlined,
          iconColor: const Color(0xFFD4AF37),
          tag: isAr ? 'ثقافة • مجتمع • تراث' : 'Culture • Société • Patrimoine',
          title: isAr ? 'المشاريع' : 'Projets',
          subtitle: isAr
              ? 'مشاريع ثقافية، اجتماعية، وتطوعية متنوعة...'
              : 'Projets culturels, sociaux et initiatives bénévoles diverses...',
          buttonLabel: isAr ? 'استعراض المشاريع' : 'Voir les projets',
          buttonIcon: Icons.arrow_outward_rounded,
          isDark: isDark,
          delay: 550,
          onTap: () => context.push('/heritage'),
        ),
        const SizedBox(height: 14),

        // Digital Library Card
        _InstitutionalCard(
          icon: Icons.auto_stories_outlined,
          iconColor: const Color(0xFF8B5CF6),
          tag: isAr ? 'معرفة • أرشيف • بحوث' : 'Savoir • Archives • Recherche',
          title: isAr ? 'المكتبة الرقمية' : 'Bibliothèque Numérique',
          subtitle: isAr
              ? 'أرشيف الثكنة، بحوث علم الآثار، تقارير المواطنة...'
              : 'Archives Caserne, recherche archéologique, rapports citoyenneté...',
          buttonLabel: isAr ? 'تصفح المكتبة' : 'Explorer la bibliothèque',
          buttonIcon: Icons.library_books_outlined,
          isDark: isDark,
          delay: 600,
          onTap: () => context.push('/library'),
        ),
        const SizedBox(height: 14),

        // Contributions Card
        _InstitutionalCard(
          icon: Icons.volunteer_activism_outlined,
          iconColor: const Color(0xFFE11D48),
          tag: isAr ? 'دعم • اشتراك • مساهمة' : 'Soutien • Adhésion • Appui',
          title: isAr ? 'المساهمات والاشتراكات' : 'Contributions & Adhésions',
          subtitle: isAr
              ? 'تجديد العضوية السنوية، دعم مشاريع الترميم...'
              : 'Renouvellement annuel, soutien aux projets de restauration...',
          buttonLabel: isAr ? 'المساهمة الآن' : 'Contribuer maintenant',
          buttonIcon: Icons.favorite_border_rounded,
          isDark: isDark,
          delay: 650,
          onTap: () => context.push('/contributions'),
        ),
        const SizedBox(height: 14),

        // Civic Report Card
        _InstitutionalCard(
          icon: Icons.shield_outlined,
          iconColor: const Color(0xFF22C55E),
          tag: isAr ? 'مجتمع مدني • إبلاغ مدني' : 'Société civile • Signalement civique',
          title: isAr ? 'بلّغ عن انتهاك' : 'Signaler une violation',
          subtitle: isAr
              ? 'تراث عمراني، سرقة أثرية، تشويه الفضاء العام…'
              : 'Patrimoine urbain, vol archéologique, dégradation de l\'espace public…',
          buttonLabel: isAr ? 'إرسال بلاغ' : 'Envoyer un signalement',
          buttonIcon: Icons.send_rounded,
          isDark: isDark,
          delay: 640,
          onTap: () => context.push('/report'),
        ),
      ],
    );
  }
}

class _InstitutionalCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String tag;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final IconData buttonIcon;
  final bool isDark;
  final int delay;
  final VoidCallback onTap;

  const _InstitutionalCard({
    required this.icon,
    required this.iconColor,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.isDark,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardBgStrong = isDark ? const Color(0xFF0F1A0F) : Colors.white;
    Color textPrimary = isDark ? Colors.white : const Color(0xFF1A1C1A);
    Color textMuted = isDark ? const Color(0x73FFFFFF) : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: cardBgStrong,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? iconColor.withOpacity(0.2) : iconColor.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: iconColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: iconColor.withOpacity(0.2)),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2.seconds),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag,
                        style: GoogleFonts.tajawal(
                          color: iconColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: textMuted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonLabel,
                            style: GoogleFonts.cairo(
                              color: iconColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(buttonIcon, color: iconColor, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: 0.05);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLATFORM THEME HELPERS (Shared with Dashboard)
// ─────────────────────────────────────────────────────────────────────────────
const Color _kGold = AppTheme.accentColor;
Color _cardBorder(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x22FFFFFF) : Colors.black.withOpacity(0.1);
Color _cardBgStrong(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0x12FFFFFF) : Colors.white.withOpacity(0.1);
Color _textPrimary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1C1A);
Color _textSecondary(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? const Color(0xCCFFFFFF) : Colors.black87;

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC PLATFORM INTRO CARD
// ─────────────────────────────────────────────────────────────────────────────
class _PublicPlatformCard extends StatelessWidget {
  final AppLocalizations loc;
  const _PublicPlatformCard({required this.loc});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [const Color(0xFF081C10), const Color(0xFF04140B)]
            : [Colors.white, const Color(0xFFF0F9F4)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.05),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppTheme.accentColor.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 3.seconds, color: Colors.white10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(isDark ? 0.03 : 0.4),
                  border: Border(
                    bottom: BorderSide(color: AppTheme.accentColor.withOpacity(0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.auto_awesome_mosaic_rounded, color: AppTheme.accentColor, size: 24),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2.seconds),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.dashPublicIntroTitle,
                            style: GoogleFonts.tajawal(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : AppTheme.primaryColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Container(
                            height: 2,
                            width: 60,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppTheme.accentColor, Colors.transparent]),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.dashPublicIntroDesc,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.7,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _PremiumPillarChip(icon: Icons.palette_rounded, label: loc.dashPillar1, color: const Color(0xFFD4AF37)),
                        _PremiumPillarChip(icon: Icons.account_balance_rounded, label: loc.dashPillar2, color: const Color(0xFF22C55E)),
                        _PremiumPillarChip(icon: Icons.people_alt_rounded, label: loc.dashPillar3, color: const Color(0xFF3B82F6)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic);
  }
}

class _PremiumPillarChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _PremiumPillarChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.tajawal(
              fontSize: 13,
              color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(delay: 2.seconds, duration: 1.5.seconds, color: Colors.white10);
  }
}


class _HomeProjectCard extends StatelessWidget {
  final NewsPost project;
  final String lang;
  final bool isDark;

  const _HomeProjectCard({
    required this.project,
    required this.lang,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = lang == 'ar';
    return GestureDetector(
      onTap: () => context.push('/project/${project.id}', extra: project),
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1A0F) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? AppTheme.accentColor.withOpacity(0.1) : AppTheme.primaryColor.withOpacity(0.05),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image & Progress Overlay
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: project.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                        ),
                      ),
                    ),
                  ),
                  // Progress Bar on image
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isAr ? 'تقدم المشروع' : 'PROGRÈS',
                              style: GoogleFonts.playfairDisplay(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                            ),
                            Text(
                              '${(project.progressPercentage * 100).toInt()}%',
                              style: const TextStyle(color: AppTheme.accentColor, fontSize: 13, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: project.progressPercentage,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            color: AppTheme.accentColor,
                            minHeight: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Positioned(
                    top: 12,
                    left: isAr ? null : 12,
                    right: isAr ? 12 : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)],
                      ),
                      child: Text(
                        _getStatusLabel(project.projectStatus, isAr),
                        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900, fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                ],
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        project.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.getTitle(lang),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.getSummary(lang),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        height: 1.5,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusLabel(String status, bool isAr) {
    switch (status) {
      case 'PREPARING': return isAr ? 'تحضير' : 'Prép.';
      case 'ONGOING': return isAr ? 'جاري' : 'En cours';
      case 'COMPLETED': return isAr ? 'مكتمل' : 'Terminé';
      default: return isAr ? 'ميداني' : 'Terrain';
    }
  }
}
