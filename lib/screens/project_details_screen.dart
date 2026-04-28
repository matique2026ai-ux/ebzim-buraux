import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_project_timeline.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailsWrapper extends ConsumerWidget {
  final String projectId;
  final NewsPost? initialProject;
  const ProjectDetailsWrapper({super.key, required this.projectId, this.initialProject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If we already have the project data (passed from the list), show it immediately
    if (initialProject != null) {
      return ProjectDetailsScreen(project: initialProject!);
    }

    final postAsync = ref.watch(postDetailsProvider(projectId));
    return postAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              Text('Error: $err'),
              const SizedBox(height: 16),
              TextButton(onPressed: () => context.go('/home'), child: const Text('Back to Home')),
            ],
          ),
        ),
      ),
      data: (p) => p != null ? ProjectDetailsScreen(project: p) : const _ProjectNotFoundScreen(),
    );
  }
}

class _ProjectNotFoundScreen extends StatelessWidget {
  const _ProjectNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A0F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, color: AppTheme.accentColor, size: 64),
            const SizedBox(height: 24),
            Text(
              'المشروع غير موجود حالياً',
              style: GoogleFonts.tajawal(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'يبدو أن هذا الرابط غير صحيح أو تم نقل المحتوى.',
              style: GoogleFonts.tajawal(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.home_rounded),
              label: const Text('العودة للرئيسية'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsScreen extends ConsumerWidget {
  final NewsPost project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final lang = isAr ? 'ar' : 'fr';
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Premium Header ───────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                  onPressed: () => context.pop(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      project.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) => Container(
                        color: const Color(0xFF0F1A0F),
                        child: const Icon(Icons.apartment_rounded, color: Colors.white24, size: 64),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _getCategoryLabel(project.category, isAr),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            project.getTitle(lang),
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.apartment_outlined, color: AppTheme.accentColor, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr ? 'الشريك الاستراتيجي' : 'Partenaire Stratégique',
                              style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 11),
                            ),
                            Text(
                              project.partnerName ?? (isAr ? 'وزارة المجاهدين' : 'Min. Moudjahidines'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Progress Section
                    Text(
                      isAr ? 'حالة الإنجاز' : 'État d\'avancement',
                      style: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isAr ? 'نسبة التقدم الكلية' : 'Progression globale',
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                              Text(
                                '${(project.progressPercentage * 100).toInt()}%',
                                style: GoogleFonts.playfairDisplay(color: AppTheme.accentColor, fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: project.progressPercentage,
                            backgroundColor: Colors.white10,
                            color: AppTheme.accentColor,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Timeline Section
                    Text(
                      isAr ? 'المراحل والمحطات' : 'Timeline du projet',
                      style: GoogleFonts.tajawal(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                    ),
                    const SizedBox(height: 20),
                    EbzimProjectTimeline(
                      milestones: project.milestones,
                      lang: lang,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Body
                    Text(
                      project.getBody(lang),
                      style: GoogleFonts.tajawal(
                        fontSize: 15,
                        height: 1.8,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryLabel(String category, bool isAr) {
    switch (category.toUpperCase()) {
      case 'HERITAGE': return isAr ? 'تراثي' : 'Patrimonial';
      case 'SCIENTIFIC': return isAr ? 'بحث علمي' : 'Scientifique';
      case 'CULTURAL': return isAr ? 'ثقافي' : 'Culturel';
      case 'ARTISTIC': return isAr ? 'فني' : 'Artistique';
      case 'RESTORATION': return isAr ? 'ترميم' : 'Restauration';
      case 'PARTNERSHIP': return isAr ? 'شراكة' : 'Partenariat';
      case 'EVENT_REPORT': return isAr ? 'تقرير ميداني' : 'Rapport';
      case 'ASSOCIATIVE': return isAr ? 'جمعوي' : 'Associatif';
      case 'SOCIAL': return isAr ? 'اجتماعي' : 'Social';
      case 'PROJECT': return isAr ? 'مؤسساتي' : 'Institutionnel';
      case 'TOURISM': return isAr ? 'سياحة ثقافية' : 'Tourisme';
      default: return isAr ? 'مشروع عام' : 'Général';
    }
  }
}
