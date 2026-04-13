import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsPost post;
  const NewsDetailScreen({super.key, required this.post});

  static Color _catColor(String cat, BuildContext ctx) {
    final cs = Theme.of(ctx).colorScheme;
    switch (cat) {
      case 'PARTNERSHIP':   return cs.primary;
      case 'ANNOUNCEMENT':  return cs.secondary;
      case 'EVENT_REPORT':  return cs.tertiary;
      default:              return cs.outline;
    }
  }

  static String _catLabel(String cat, String lang) {
    const map = {
      'PARTNERSHIP':  ('شراكة رسمية', 'Partenariat officiel'),
      'ANNOUNCEMENT': ('إعلان', 'Annonce'),
      'EVENT_REPORT': ('تقرير نشاط', 'Compte-rendu'),
    };
    final entry = map[cat];
    if (entry == null) return lang == 'ar' ? 'عام' : 'Général';
    return lang == 'ar' ? entry.$1 : entry.$2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Detect language from locale (fallback to 'ar')
    final lang = Localizations.localeOf(context).languageCode;
    final catColor = _catColor(post.category, context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero App Bar ──
          SliverAppBar(
            expandedHeight: post.imageUrl.isNotEmpty ? 280 : 120,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark ? Colors.black45 : Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: theme.colorScheme.onSurface),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: post.imageUrl.isNotEmpty
                ? FlexibleSpaceBar(
                    background: Image.network(
                      post.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.image_outlined, size: 64, color: theme.colorScheme.primary),
                      ),
                    ),
                  )
                : null,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _catLabel(post.category, lang),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: catColor),
                        ),
                      ),
                      if (post.isPinned) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.push_pin, size: 12, color: AppTheme.primaryColor),
                              const SizedBox(width: 4),
                              Text(lang == 'ar' ? 'مثبّت' : 'Épinglé',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                            ],
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        '${post.publishedAt.day}/${post.publishedAt.month}/${post.publishedAt.year}',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.45)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    post.getTitle(lang),
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Summary
                  if (post.getSummary(lang).isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border(
                          right: BorderSide(color: AppTheme.primaryColor, width: 4),
                        ),
                      ),
                      child: Text(
                        post.getSummary(lang),
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          height: 1.7,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Body
                  if (post.getBody(lang).isNotEmpty)
                    Text(
                      post.getBody(lang),
                      style: GoogleFonts.tajawal(
                        fontSize: 15,
                        height: 1.9,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      ),
                    ),

                  // Partner badge
                  if (post.partnerName != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: theme.colorScheme.primaryContainer),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance, color: theme.colorScheme.primary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lang == 'ar' ? 'شريك الجمعية' : 'Partenaire',
                                    style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                                Text(post.partnerName!,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
