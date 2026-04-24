import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  String _selectedCategory = 'ALL';

  static const _categories = [
    ('ALL', 'الكل', 'Tout'),
    ('ANNOUNCEMENT', 'إعلانات', 'Annonces'),
    ('PARTNERSHIP', 'شراكات', 'Partenariats'),
    ('EVENT_REPORT', 'تقارير', 'Comptes-rendus'),
  ];

  /* String _catLabel(String code, String lang) { // Removed to fix unused element warning
    final cat = _categories.firstWhere(
      (c) => c.$1 == code,
      orElse: () => (code, code, code),
    );
    return lang == 'ar' ? cat.$2 : cat.$3;
  } */

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = ref.watch(localeProvider).languageCode;
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
          const EbzimSliverAppBar(),
          
          // ── Header & Filters ──
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100), // Safe zone for pinned app bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'ar' ? 'الأخبار والمستجدات' : 'Actualités',
                        style: GoogleFonts.tajawal(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lang == 'ar'
                            ? 'آخر أخبار الجمعية والشراكات الرسمية'
                            : 'Dernières nouvelles et partenariats officiels',
                        style: TextStyle(
                          fontSize: 14,
                          // fontStyle removed for accessibility,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Category Filter ──
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, i) {
                      final cat = _categories[i];
                      final isSelected = _selectedCategory == cat.$1;
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: FilterChip(
                          label: Text(
                            lang == 'ar' ? cat.$2 : cat.$3,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : (isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54),
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = cat.$1),
                          backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                          selectedColor: AppTheme.accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── News List ──
          newsAsync.when(
            data: (posts) {
              final filtered = _selectedCategory == 'ALL'
                  ? posts.where((p) => const {'ANNOUNCEMENT', 'PARTNERSHIP', 'EVENT_REPORT'}.contains(p.category.toUpperCase()) || p.category.isEmpty).toList()
                  : posts
                      .where((p) => p.category == _selectedCategory)
                      .toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.newspaper, size: 64, color: Colors.white.withValues(alpha: 0.1)),
                        const SizedBox(height: 12),
                        Text(
                          lang == 'ar' ? 'لا توجد أخبار في هذه الفئة' : 'Aucune actualité dans cette catégorie',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _NewsCard(post: post, lang: lang)
                            .animate()
                            .fadeIn(delay: (index * 80).ms)
                            .slideY(begin: 0.05),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.accentColor,
                  strokeWidth: 2,
                ),
              ),
            ),
            error: (_, _) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 48, color: Colors.white.withValues(alpha: 0.1)),
                    Icon(Icons.wifi_off, size: 48, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => ref.invalidate(newsProvider),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text(lang == 'ar' ? 'إعادة المحاولة' : 'Réessayer'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
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

// ── News Card ──
class _NewsCard extends StatelessWidget {
  final NewsPost post;
  final String lang;
  const _NewsCard({required this.post, required this.lang});

  Color _categoryColor(String category, BuildContext context) {
    final theme = Theme.of(context);
    switch (category) {
      case 'PARTNERSHIP': return theme.colorScheme.primary;
      case 'ANNOUNCEMENT': return theme.colorScheme.secondary;
      case 'EVENT_REPORT': return theme.colorScheme.tertiary;
      default: return theme.colorScheme.outline;
    }
  }

  String _categoryLabel(String category, String lang) {
    final labels = {
      'PARTNERSHIP': lang == 'ar' ? 'شراكة رسمية' : 'Partenariat Officiel',
      'ANNOUNCEMENT': lang == 'ar' ? 'إعلان' : 'Annonce',
      'EVENT_REPORT': lang == 'ar' ? 'تقرير نشاط' : 'Compte-rendu',
    };
    return labels[category] ?? (lang == 'ar' ? 'عام' : 'Général');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catColor = _categoryColor(post.category, context);

    return GestureDetector(
      onTap: () => context.push('/news/${post.id}', extra: post),
      child: Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.network(
                    post.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 180,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(Icons.image_outlined, size: 48, color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  // Pinned badge
                  if (post.isPinned)
                    PositionedDirectional(
                      top: 12,
                      end: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.push_pin, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              lang == 'ar' ? 'مثبّت' : 'Épinglé',
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Date row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (post.category == 'PARTNERSHIP')
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 4),
                              child: Icon(Icons.handshake, size: 11, color: catColor),
                            ),
                          Text(
                            _categoryLabel(post.category, lang),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: catColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${post.publishedAt.day}/${post.publishedAt.month}/${post.publishedAt.year}',
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  post.getTitle(lang),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Summary
                Text(
                  post.getSummary(lang),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Partner badge
                if (post.partnerName != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.colorScheme.primaryContainer),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.account_balance, size: 14, color: theme.colorScheme.primary),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            post.partnerName!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0369A1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}
