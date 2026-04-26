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

class ProjectDetailsScreen extends ConsumerWidget {
  final NewsPost project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch full details from API to get milestones & progressPercentage
    final fullPostAsync = ref.watch(postDetailsProvider(project.id));
    
    return fullPostAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (p) {
        if (p == null) return const Scaffold(body: Center(child: Text('Project not found')));
        
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
                    decoration: BoxDecoration(
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
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF0A1A0A),
                            child: const Icon(Icons.architecture_rounded, size: 80, color: AppTheme.accentColor),
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black26,
                                Colors.transparent,
                                Colors.black87,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _getCategoryLabel(p.category, isAr),
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (p.projectStatus != 'GENERAL') ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(p.projectStatus).withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white24),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _getStatusLabel(p.projectStatus, isAr),
                                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                              const SizedBox(height: 12),
                              Text(
                                p.getTitle(lang),
                                style: GoogleFonts.tajawal(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2,
                                ),
                              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ── Project Content ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Progress Section ──
                        _buildSectionHeader(isAr ? 'حالة الإنجاز' : 'État d\'avancement'),
                        const SizedBox(height: 16),
                        _buildProgressCard(context, p.progressPercentage),
                        
                        const SizedBox(height: 32),
                        // ── Timeline Section ──
                        if (p.milestones.isNotEmpty) ...[
                          _buildSectionHeader(isAr ? 'مراحل المشروع' : 'Étapes du projet'),
                          const SizedBox(height: 20),
                          EbzimProjectTimeline(
                            milestones: p.milestones,
                            lang: lang,
                          ).animate().fadeIn(delay: 400.ms),
                          const SizedBox(height: 32),
                        ],
                        // ── Description Section ──
                        _buildSectionHeader(isAr ? 'عن المشروع' : 'À propos du projet'),
                        const SizedBox(height: 16),
                        Text(
                          p.getBody(lang),
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            height: 1.8,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        if (p.partnerName != null) ...[
                          const SizedBox(height: 32),
                          _buildPartnerBadge(context, p.partnerName!),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, double progress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white10 : AppTheme.accentColor.withValues(alpha: 0.1)),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نسبة الإنجاز الكلية',
                style: GoogleFonts.tajawal(fontSize: 14, color: Colors.grey),
              ),
              Text(
                '$percentage%',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
            ),
          ).animate().shimmer(duration: 2.seconds),
        ],
      ),
    );
  }

  Widget _buildPartnerBadge(BuildContext context, String partner) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.handshake_rounded, color: AppTheme.accentColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بالشراكة مع', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text(
                  partner,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(String cat, bool isAr) {
    switch (cat) {
      case 'HERITAGE': return isAr ? 'مشروع تراثي' : 'Projet Patrimonial';
      case 'PROJECT': return isAr ? 'مشروع تطويري' : 'Projet de Développement';
      case 'ARTISTIC': return isAr ? 'مشروع فني' : 'Projet Artistique';
      case 'CULTURAL': return isAr ? 'مشروع ثقافي' : 'Projet Culturel';
      case 'SCIENTIFIC': return isAr ? 'مشروع علمي' : 'Projet Scientifique';
      case 'RESTORATION': return isAr ? 'مشروع ترميم' : 'Projet de Restauration';
      default: return isAr ? 'مشروع مؤسساتي' : 'Projet Institutionnel';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PREPARING': return Colors.blue;
      case 'ACTIVE': return Colors.green;
      case 'ON_HOLD': return Colors.orange;
      case 'COMPLETED': return const Color(0xFFC5A059);
      default: return Colors.grey;
    }
  }

  String _getStatusLabel(String status, bool isAr) {
    switch (status) {
      case 'PREPARING': return isAr ? 'قيد التحضير' : 'En préparation';
      case 'ACTIVE': return isAr ? 'نشط' : 'Actif';
      case 'ON_HOLD': return isAr ? 'متوقف' : 'En pause';
      case 'COMPLETED': return isAr ? 'مكتمل' : 'Terminé';
      default: return '';
    }
  }
}
