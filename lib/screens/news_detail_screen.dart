import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';
import 'package:ebzim_app/screens/project_details_screen.dart';
import 'package:ebzim_app/screens/event_details_screen.dart';

class NewsDetailWrapper extends ConsumerWidget {
  final NewsPost? initialPost;
  final String postId;

  const NewsDetailWrapper({super.key, this.initialPost, required this.postId});

  bool _isProject(NewsPost p) {
    const projectCategories = [
      'PROJECT', 'HERITAGE', 'SCIENTIFIC', 'RESTORATION', 
      'ARTISTIC', 'CULTURAL', 'TOURISM', 'CHILD', 'PARTNERSHIP'
    ];
    return projectCategories.contains(p.category.toUpperCase()) || p.contentType == 'PROJECT' || p.isFieldProject;
  }

  bool _isEvent(NewsPost p) {
    return p.contentType == 'EVENT' || p.category.toUpperCase() == 'EVENT' || p.category.toUpperCase() == 'WORKSHOP';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Check if initial post is a special type
    if (initialPost != null) {
      if (_isProject(initialPost!)) return ProjectDetailsScreen(project: initialPost!);
      if (_isEvent(initialPost!)) return EventDetailsScreen(eventId: initialPost!.id, initialEvent: initialPost);
      return NewsDetailScreen(post: initialPost!);
    }
    
    final postAsync = ref.watch(postDetailsProvider(postId));
    
    return postAsync.when(
      data: (post) {
        if (post == null) return const Scaffold(body: Center(child: Text('Content not found')));
        
        // 2. Dynamic redirection based on type
        if (_isProject(post)) return ProjectDetailsScreen(project: post);
        if (_isEvent(post)) return EventDetailsScreen(eventId: post.id, initialEvent: post);
        
        return NewsDetailScreen(post: post);
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('Error loading content'))),
    );
  }
}

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
      backgroundColor: Colors.transparent,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero App Bar ──
          EbzimSliverAppBar(
            expandedHeight: post.imageUrl.isNotEmpty ? 280 : 120,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
            background: post.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.black12),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.image_outlined, size: 64, color: theme.colorScheme.primary),
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
                          right: lang == 'ar' ? const BorderSide(color: AppTheme.primaryColor, width: 4) : BorderSide.none,
                          left: lang != 'ar' ? const BorderSide(color: AppTheme.primaryColor, width: 4) : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        post.getSummary(lang),
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          // fontStyle removed for accessibility,
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
      ),
    );
  }
}
