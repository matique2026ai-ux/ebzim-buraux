import 'package:ebzim_app/core/common_widgets/ebzim_project_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/news_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State Providers
// ─────────────────────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');
final projectFilterProvider = StateProvider<String>((ref) => 'all');

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class HeritageProjectsScreen extends ConsumerWidget {
  const HeritageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const EbzimSliverAppBar(),

            // ── Hero Header ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 140, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppTheme.accentColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            color: AppTheme.accentColor,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isAr
                                ? 'شريك الذاكرة الوطنية'
                                : 'Partenaire de la Mémoire Nationale',
                            style: GoogleFonts.cairo(
                              color: AppTheme.accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 16),
                    Text(
                      isAr
                          ? 'المشاريع المؤسساتية\nوالتطويرية'
                          : 'Projets Institutionnels\net de Développement',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 36,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    const SizedBox(height: 12),
                    Text(
                      isAr
                          ? 'نواكب العصر برؤية استراتيجية في مختلف المجالات'
                          : 'Nous suivons l\'époque avec une vision stratégique dans divers domaines',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 350.ms),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── Search & Filter ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _SearchAndFilterBar(isAr: isAr, isDark: isDark),
              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.05),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Project Cards ──────────────────────────────────────────────
            ref
                .watch(heritageProjectsProvider)
                .when(
                  data: (List<NewsPost> projects) {
                    final query = ref.watch(searchQueryProvider).toLowerCase();
                    final filter = ref.watch(projectFilterProvider);

                    final filteredProjects = projects.where((NewsPost p) {
                      final matchesQuery =
                          p.titleAr.toLowerCase().contains(query) ||
                          p.titleFr.toLowerCase().contains(query) ||
                          p.titleEn.toLowerCase().contains(query) ||
                          p.summaryAr.toLowerCase().contains(query);
                      final matchesFilter =
                          filter == 'all' || p.category.toLowerCase() == filter;
                      return matchesQuery && matchesFilter;
                    }).toList();

                    if (filteredProjects.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(
                            child: Text(
                              isAr
                                  ? 'لا توجد مشاريع تطابق بحثك.'
                                  : 'Aucun projet ne correspond à votre recherche.',
                              style: TextStyle(
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final project = filteredProjects[index];
                        return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: GestureDetector(
                                onTap: () => context.push(
                                  '/project/${project.id}',
                                  extra: project,
                                ),
                                child: _ProjectCard(
                                  project: project,
                                  isAr: isAr,
                                  isDark: isDark,
                                ),
                              ),
                            )
                            .animate(key: ValueKey(project.id))
                            .fadeIn(delay: (100 + index * 50).ms)
                            .slideY(begin: 0.08);
                      }, childCount: filteredProjects.length),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (_, _) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          isAr ? 'خطأ في جلب البيانات' : 'Erreur de chargement',
                        ),
                      ),
                    ),
                  ),
                ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search and Filter Bar
// ─────────────────────────────────────────────────────────────────────────────

class _SearchAndFilterBar extends ConsumerWidget {
  final bool isAr;
  final bool isDark;
  const _SearchAndFilterBar({required this.isAr, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(projectFilterProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppTheme.accentColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) =>
                      ref.read(searchQueryProvider.notifier).state = val,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: isAr
                        ? 'ابحث عن مشروع، معلم، أو شراكة...'
                        : 'Rechercher un projet, un monument...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppTheme.accentColor.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: InkWell(
                  onTap: () => context.push('/heritage-map'),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.map_rounded,
                          color: AppTheme.accentColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAr ? 'الخريطة' : 'Carte',
                          style: GoogleFonts.tajawal(
                            color: AppTheme.accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterChip(
                context,
                ref,
                'all',
                isAr ? 'الكل' : 'Tous',
                filter == 'all',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'heritage',
                isAr ? 'تراثي' : 'Patrimonial',
                filter == 'heritage',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'scientific',
                isAr ? 'علمي' : 'Scientifique',
                filter == 'scientific',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'cultural',
                isAr ? 'ثقافي' : 'Culturel',
                filter == 'cultural',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'artistic',
                isAr ? 'فني' : 'Artistique',
                filter == 'artistic',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'restoration',
                isAr ? 'ترميم' : 'Restauration',
                filter == 'restoration',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'partnership',
                isAr ? 'شراكة' : 'Partenariat',
                filter == 'partnership',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'event_report',
                isAr ? 'تقارير' : 'Rapports',
                filter == 'event_report',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'associative',
                isAr ? 'جمعوي' : 'Associatif',
                filter == 'associative',
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                ref,
                'social',
                isAr ? 'اجتماعي' : 'Social',
                filter == 'social',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref,
    String value,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => ref.read(projectFilterProvider.notifier).state = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor
              : (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white.withValues(alpha: 0.8)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentColor
                : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppTheme.accentColor.withValues(alpha: 0.2)),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.tajawal(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Project Card
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  final NewsPost project;
  final bool isAr;
  final bool isDark;
  const _ProjectCard({
    required this.project,
    required this.isAr,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final lang = isAr ? 'ar' : 'fr';
    final title = project.getTitle(lang);
    final description = project.getSummary(lang);
    final partner =
        project.partnerName ??
        (isAr ? 'شراكة إستراتيجية' : 'Partenariat Stratégique');

    return GestureDetector(
      onTap: () => context.push('/project/${project.id}', extra: project),
      child: GlassCard(
        padding: EdgeInsets.zero,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppTheme.accentColor.withValues(alpha: 0.05),
          width: 1.5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Image.network(
                    project.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      width: double.infinity,
                      color: const Color(0xFF081C10),
                      child: Icon(
                        Icons.apartment_outlined,
                        color: AppTheme.accentColor.withValues(alpha: 0.3),
                        size: 60,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          project.category,
                        ).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isAr ? 'مشروع ميداني' : 'Projet Terrain',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    left: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: project.progressPercentage,
                          backgroundColor: Colors.white24,
                          color: AppTheme.accentColor,
                          minHeight: 3,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isAr
                              ? 'نسبة الإنجاز: ${(project.progressPercentage * 100).toInt()}%'
                              : 'Avancement: ${(project.progressPercentage * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (project.projectStatus != 'GENERAL')
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(
                            project.projectStatus,
                          ).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _statusLabel(project.projectStatus, isAr),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
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
                  Row(
                    children: [
                      const Icon(
                        Icons.apartment_outlined,
                        color: AppTheme.accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          partner,
                          style: GoogleFonts.cairo(
                            color: AppTheme.accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.open_in_full_rounded,
                        color: Colors.white30,
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'PREPARING') return Colors.blue;
    if (status == 'ACTIVE') return Colors.green;
    if (status == 'ON_HOLD') return Colors.orange;
    if (status == 'COMPLETED') return const Color(0xFFC5A059);

    if (status.contains('PROJECT')) return const Color(0xFFF59E0B);
    if (status.contains('HERITAGE')) return const Color(0xFF22C55E);
    return AppTheme.accentColor;
  }

  String _statusLabel(String status, bool isAr) {
    switch (status) {
      case 'PREPARING':
        return isAr ? 'قيد التحضير' : 'En préparation';
      case 'ACTIVE':
        return isAr ? 'نشط' : 'Actif';
      case 'ON_HOLD':
        return isAr ? 'متوقف' : 'En pause';
      case 'COMPLETED':
        return isAr ? 'مكتمل' : 'Terminé';
      default:
        return '';
    }
  }
}

class _ProjectDetailsSheet extends StatelessWidget {
  final NewsPost project;
  final bool isAr;
  final bool isDark;

  const _ProjectDetailsSheet({
    required this.project,
    required this.isAr,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final lang = isAr ? 'ar' : 'fr';
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1A0F) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 40,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              // Image Header
              Stack(
                children: [
                  Image.network(
                    project.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black38,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            isDark ? const Color(0xFF0F1A0F) : Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.getTitle(lang),
                      style: GoogleFonts.tajawal(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            project.partnerName ??
                                (isAr
                                    ? 'وزارة المجاهدين'
                                    : 'Min. Moudjahidines'),
                            style: const TextStyle(
                              color: AppTheme.accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${project.publishedAt.year}',
                          style: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black38,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Progress Section
                    Text(
                      isAr ? 'تقرير حالة الإنجاز' : 'Rapport d\'avancement',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.03)
                            : Colors.black.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isAr
                                    ? 'نسبة التقدم الكلية'
                                    : 'Progression globale',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${(project.progressPercentage * 100).toInt()}%',
                                style: GoogleFonts.playfairDisplay(
                                  color: AppTheme.accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
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
                      isAr ? 'المراحل الميدانية' : 'Étapes du projet',
                      style: GoogleFonts.tajawal(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    EbzimProjectTimeline(
                      milestones: project.milestones,
                      lang: lang,
                    ),

                    const SizedBox(height: 32),

                    // Body / Details
                    Text(
                      project.getBody(lang),
                      style: GoogleFonts.tajawal(
                        fontSize: 15,
                        height: 1.8,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
