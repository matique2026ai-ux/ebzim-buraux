import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final loc = AppLocalizations.of(context)!; // Removed to fix unused variable warning
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: theme.dividerTheme.color?.withValues(alpha: 0.5) ?? Colors.transparent),
                ),
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
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideY(begin: 0.05),
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
          // ABOUT TEASER
          // ════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, const Color(0xFF003D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.15),
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
                        color: AppTheme.accentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lang == 'ar' ? 'رسالتنا الثقافية' : 'NOTRE MISSION',
                        style: const TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang == 'ar' ? 'من نحن؟' : 'Qui sommes-nous ?',
                      style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lang == 'ar'
                          ? 'جمعية إبزيم للثقافة والمواطنة جمعية ولائية مقرها سطيف، مصادق عليها وفق القانون 06/12 المؤرخ في 12 جانفي 2012.'
                          : 'L\'association Ebzim est une association provinciale basée à Sétif, fondée conformément à la loi 06/12 du 12 janvier 2012.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 15,
                        height: 1.7,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () => context.push('/about'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              lang == 'ar' ? 'اكتشف المزيد' : 'Découvrir plus',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              lang == 'ar' ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                              color: AppTheme.accentColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: isDark ? AppTheme.accentColor : AppTheme.primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 26,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, 
      height: 32, 
      color: Theme.of(context).dividerTheme.color?.withValues(alpha: 0.5) ?? Colors.grey.withValues(alpha: 0.2)
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              lang == 'ar' ? 'عرض الكل' : 'Voir tout',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? AppTheme.accentColor : AppTheme.secondaryColor,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAr = lang == 'ar';
    
    return InkWell(
      onTap: () => context.push('/news/${post.id}', extra: post),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: post.isPinned 
              ? AppTheme.heritageOrange.withValues(alpha: 0.03) 
              : theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: post.isPinned 
                ? AppTheme.heritageOrange.withValues(alpha: 0.5) 
                : theme.dividerTheme.color?.withValues(alpha: 0.5) ?? Colors.transparent,
            width: post.isPinned ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: post.isPinned 
                  ? AppTheme.heritageOrange.withValues(alpha: 0.08) 
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image or Placeholder
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: isAr ? Radius.zero : const Radius.circular(24),
                right: isAr ? const Radius.circular(24) : Radius.zero,
              ),
              child: SizedBox(
                width: 110,
                height: 110,
                child: post.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: post.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(color: theme.dividerTheme.color),
                        errorWidget: (ctx, url, err) => _buildPlaceholder(isDark),
                      )
                    : _buildPlaceholder(isDark),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      post.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: post.isPinned 
                            ? AppTheme.heritageOrange 
                            : (isDark ? AppTheme.accentColor : AppTheme.primaryColor),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.getTitle(lang),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: isDark ? Colors.white : AppTheme.primaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12, color: theme.hintColor),
                        const SizedBox(width: 4),
                        Text(
                          '${post.publishedAt.day}/${post.publishedAt.month}/${post.publishedAt.year}',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                color: isDark ? AppTheme.accentColor.withValues(alpha: 0.5) : AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? Colors.white.withValues(alpha: 0.05) : AppTheme.primaryColor.withValues(alpha: 0.05),
      child: Center(
        child: Icon(
          Icons.newspaper_rounded,
          color: isDark ? Colors.white12 : AppTheme.primaryColor.withValues(alpha: 0.1),
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
        border: Border.all(color: color.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
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

class _SunriseCarousel extends StatefulWidget {
  final List<HeroSlide> slides;
  final String lang;
  const _SunriseCarousel({required this.slides, required this.lang});

  @override
  State<_SunriseCarousel> createState() => _SunriseCarouselState();
}

class _SunriseCarouselState extends State<_SunriseCarousel> {
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
                      // Overlay Gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              AppTheme.primaryColor.withValues(alpha: 0.8),
                              AppTheme.primaryColor,
                            ],
                          ),
                        ),
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    widget.lang == 'ar' ? 'اكتشف إرثنا' : 'DÉCOUVREZ NOTRE HÉRITAGE',
                    style: const TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ).animate(key: ValueKey('chip_${slide.id}')).fadeIn(duration: const Duration(milliseconds: 600)).slideX(begin: -0.1),
                const SizedBox(height: 20),
                Text(
                  slide.getTitle(widget.lang),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 34,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ).animate(key: ValueKey('title_${slide.id}')).fadeIn(delay: const Duration(milliseconds: 100), duration: const Duration(milliseconds: 800)).slideY(begin: 0.1),
                const SizedBox(height: 16),
                Text(
                  slide.getSubtitle(widget.lang),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.75),
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ).animate(key: ValueKey('sub_${slide.id}')).fadeIn(delay: const Duration(milliseconds: 300), duration: const Duration(milliseconds: 800)).slideY(begin: 0.1),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _HeroButton(
                        label: widget.lang == 'ar' ? 'طلب عضوية' : 'Devenir membre',
                        isPrimary: true,
                        icon: Icons.card_membership,
                        onTap: () => context.push('/membership/apply'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _HeroButton(
                        label: widget.lang == 'ar' ? 'تصفح النشاطات' : 'Activités',
                        isPrimary: false,
                        icon: Icons.explore_outlined,
                        onTap: () => context.go('/activities'),
                      ),
                    ),
                  ],
                ).animate(key: ValueKey('btns_${slide.id}')).fadeIn(delay: const Duration(milliseconds: 500), duration: const Duration(milliseconds: 800)).slideY(begin: 0.1),
              ],
            ),
          ),
        ),
      ),
    );
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
  Widget build(BuildContext context) => Container(height: 520, color: AppTheme.primaryColor.withValues(alpha: 0.1), child: const Center(child: CircularProgressIndicator()));
}

