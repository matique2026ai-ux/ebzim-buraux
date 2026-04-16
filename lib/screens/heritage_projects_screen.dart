import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Models (Unused but kept for reference)
// ─────────────────────────────────────────────────────────────────────────────

class _RestorationProject {
  final String id;
  final String titleAr;
  final String titleFr;
  final String partnerAr;
  final String partnerFr;
  final String descriptionAr;
  final String descriptionFr;
  final String imageUrl;
  final String status;
  final String yearStarted;
  final String location;
  final double progressPercent;
  final IconData icon;
  final List<_ProjectMilestone> milestones;

  const _RestorationProject({
    required this.id,
    required this.titleAr,
    required this.titleFr,
    required this.partnerAr,
    required this.partnerFr,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.imageUrl,
    required this.status,
    required this.yearStarted,
    required this.location,
    required this.progressPercent,
    required this.icon,
    required this.milestones,
  });
}

class _ProjectMilestone {
  final String labelAr;
  final String labelFr;
  final bool done;
  const _ProjectMilestone({required this.labelAr, required this.labelFr, required this.done});
}

// ─────────────────────────────────────────────────────────────────────────────
// Static Data
// ─────────────────────────────────────────────────────────────────────────────

final _projects = [
  _RestorationProject(
    id: 'caserne',
    titleAr: 'ترميم الثكنة العسكرية — الحامة',
    titleFr: 'Restauration de la Caserne — El Hamman',
    partnerAr: 'وزارة المجاهدين وذوي الحقوق',
    partnerFr: 'Ministère des Moudjahidines',
    descriptionAr:
        'مشروع ترميم وصون تاريخي لإحدى الشواهد المعمارية التي تحمل ذاكرة الثورة التحريرية الجزائرية في ولاية سطيف. يجري تنفيذ المشروع بموجب عقد رسمي مع وزارة المجاهدين وذوي الحقوق، في إطار الحفاظ على تراث الذاكرة الوطنية وإعادة الاعتبار للمواقع التاريخية.',
    descriptionFr:
        'Projet de restauration et de conservation d\'un site architectural portant la mémoire de la Révolution algérienne à Sétif. Réalisé dans le cadre d\'un contrat officiel avec le Ministère des Moudjahidines, pour la préservation du patrimoine mémoriel national.',
    imageUrl: 'https://placehold.co/800x400/081C10/D4AF37?text=Caserne+El+Hamman+Setif',
    status: 'جارٍ التنفيذ',
    yearStarted: '2024',
    location: 'الحامة، ولاية سطيف',
    progressPercent: 0.45,
    icon: Icons.apartment_outlined,
    milestones: [
      _ProjectMilestone(labelAr: 'توقيع عقد الترميم', labelFr: 'Signature du contrat', done: true),
      _ProjectMilestone(labelAr: 'الدراسة الهندسية والتقنية', labelFr: 'Étude technique', done: true),
      _ProjectMilestone(labelAr: 'أشغال الهيكل الحامل', labelFr: 'Travaux de structure', done: true),
      _ProjectMilestone(labelAr: 'ترميم الواجهات التاريخية', labelFr: 'Restauration des façades', done: false),
      _ProjectMilestone(labelAr: 'التهيئة الداخلية', labelFr: 'Aménagement intérieur', done: false),
      _ProjectMilestone(labelAr: 'الافتتاح الرسمي', labelFr: 'Inauguration officielle', done: false),
    ],
  ),
  _RestorationProject(
    id: 'museum',
    titleAr: 'شراكة المتحف الوطني للآثار',
    titleFr: 'Partenariat — Musée National des Antiquités',
    partnerAr: 'المتحف الوطني للآثار — سطيف',
    partnerFr: 'Musée National des Antiquités de Sétif',
    descriptionAr:
        'اتفاقية شراكة استراتيجية بين جمعية إبزيم والمتحف الوطني للآثار بسطيف، بهدف تنظيم أيام ثقافية مشتركة، ودعم البحث الأثري، والتعريف بالتراث الحضاري لمنطقة سطيف ذات العمق التاريخي الروماني والبيزنطي والإسلامي.',
    descriptionFr:
        'Convention de partenariat stratégique entre l\'association Ebzim et le Musée National des Antiquités de Sétif pour l\'organisation de journées culturelles, le soutien à la recherche archéologique et la valorisation du patrimoine civilisationnel de la région.',
    imageUrl: 'https://placehold.co/800x400/081C10/D4AF37?text=Musee+National+Setif',
    status: 'نشط',
    yearStarted: '2023',
    location: 'سطيف، الجزائر',
    progressPercent: 1.0,
    icon: Icons.account_balance_outlined,
    milestones: [
      _ProjectMilestone(labelAr: 'إمضاء اتفاقية الشراكة', labelFr: 'Signature de la convention', done: true),
      _ProjectMilestone(labelAr: 'الأيام التراثية المشتركة الأولى', labelFr: 'Premières journées patrimoniales', done: true),
      _ProjectMilestone(labelAr: 'برنامج التوعية المدرسية', labelFr: 'Programme scolaire', done: true),
      _ProjectMilestone(labelAr: 'المعرض الأثري المتنقل', labelFr: 'Exposition itinérante', done: false),
    ],
  ),
  _RestorationProject(
    id: 'unesco',
    titleAr: 'عضوية شبكة اليونسكو',
    titleFr: 'Réseau UNESCO Algérie',
    partnerAr: 'منظمة اليونسكو — الجزائر',
    partnerFr: 'UNESCO Algérie',
    descriptionAr:
        'عضوية جمعية إبزيم في شبكة اليونسكو بالجزائر يُرسّخ دورها كفاعل مجتمعي معتمد دولياً في صون التراث الإنساني. هذه العضوية تُلزم الجمعية بمعايير الحوكمة الثقافية الدولية وتفتح أمامها أبواب الشراكات العالمية.',
    descriptionFr:
        'L\'adhésion d\'Ebzim au réseau UNESCO en Algérie consacre son rôle d\'acteur sociétal reconnu internationalement dans la sauvegarde du patrimoine humain, l\'engageant dans les standards de gouvernance culturelle internationale.',
    imageUrl: 'https://placehold.co/800x400/081C10/D4AF37?text=UNESCO+Network+Algeria',
    status: 'عضو فاعل',
    yearStarted: '2022',
    location: 'الجزائر العاصمة',
    progressPercent: 1.0,
    icon: Icons.public_outlined,
    milestones: [
      _ProjectMilestone(labelAr: 'قبول طلب العضوية', labelFr: 'Adhésion acceptée', done: true),
      _ProjectMilestone(labelAr: 'التكوين على معايير اليونسكو', labelFr: 'Formation aux standards', done: true),
      _ProjectMilestone(labelAr: 'المشاركة في الملتقيات الوطنية', labelFr: 'Participation nationale', done: true),
      _ProjectMilestone(labelAr: 'المشاركة في المؤتمرات الدولية', labelFr: 'Conférences internationales', done: false),
    ],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');
final projectFilterProvider = StateProvider<String>((ref) => 'all');

class HeritageProjectsScreen extends ConsumerWidget {
  const HeritageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/heritage-map'),
        backgroundColor: AppTheme.accentColor,
        icon: const Icon(Icons.map_rounded, color: Colors.white),
        label: Text(
          isAr ? 'عرض الخريطة' : 'Voir la carte',
          style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ).animate().fadeIn(delay: 500.ms).slideY(begin: 1.0, curve: Curves.easeOutBack),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded, color: AppTheme.accentColor, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            isAr ? 'شريك الذاكرة الوطنية' : 'Partenaire de la Mémoire Nationale',
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
                      isAr ? 'مشاريع الذاكرة\nوصون التراث' : 'Projets Mémoriels\net Patrimoniaux',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 36,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    const SizedBox(height: 12),
                    Text(
                      isAr
                          ? 'التزام مؤسساتي راسخ بصون الهوية الحضارية الجزائرية'
                          : 'Un engagement institutionnel fort pour la sauvegarde de l\'identité civilisationnelle algérienne',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 350.ms),
                  ],
                ),
              ),
            ),

            // ── Partnership Banner ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _PartnershipBanner(isAr: isAr, isDark: isDark),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── Search & Filter ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _SearchAndFilterBar(isAr: isAr, isDark: isDark),
              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.05),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Project Cards ──────────────────────────────────────────────
            ref.watch(heritageProjectsProvider).when(
              data: (projects) {
                final query = ref.watch(searchQueryProvider).toLowerCase();
                final filter = ref.watch(projectFilterProvider);

                final filteredProjects = projects.where((p) {
                  final matchesQuery = p.titleAr.toLowerCase().contains(query) ||
                                       p.titleFr.toLowerCase().contains(query) ||
                                       p.titleEn.toLowerCase().contains(query) ||
                                       p.summaryAr.toLowerCase().contains(query);
                  final matchesFilter = filter == 'all' || p.category.toLowerCase() == filter;
                  return matchesQuery && matchesFilter;
                }).toList();

                if (filteredProjects.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          isAr ? 'لا توجد مشاريع تطابق بحثك.' : 'Aucun projet ne correspond à votre recherche.',
                          style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final project = filteredProjects[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: _ProjectCard(project: project, isAr: isAr, isDark: isDark),
                      ).animate(key: ValueKey(project.id)).fadeIn(delay: (100 + index * 50).ms).slideY(begin: 0.08);
                    },
                    childCount: filteredProjects.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Padding(padding: EdgeInsets.only(top: 40), child: Center(child: CircularProgressIndicator())),
              ),
              error: (_, __) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(child: Text(isAr ? 'خطأ في جلب البيانات' : 'Erreur de chargement')),
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
// Partnership Banner — 3 logos
// ─────────────────────────────────────────────────────────────────────────────

class _PartnershipBanner extends StatelessWidget {
  final bool isAr;
  final bool isDark;
  const _PartnershipBanner({required this.isAr, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final partners = [
      _PartnerChip(
        icon: Icons.public_rounded,
        label: isAr ? 'اليونسكو' : 'UNESCO',
        sub: isAr ? 'الجزائر' : 'Algérie',
        color: const Color(0xFF009FDA),
      ),
      _PartnerChip(
        icon: Icons.account_balance_rounded,
        label: isAr ? 'متحف الآثار' : 'Musée des Antiquités',
        sub: isAr ? 'سطيف' : 'Sétif',
        color: AppTheme.accentColor,
      ),
      _PartnerChip(
        icon: Icons.military_tech_rounded,
        label: isAr ? 'وز. المجاهدين' : 'Min. Moudjahidines',
        sub: isAr ? 'عقد ترميم' : 'Contrat restauration',
        color: const Color(0xFF22C55E),
      ),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : AppTheme.accentColor.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAr ? 'شراكاتنا الاستراتيجية' : 'Nos Partenariats Stratégiques',
                style: GoogleFonts.tajawal(
                  color: AppTheme.accentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: partners.map((p) => Expanded(child: p)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartnerChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  const _PartnerChip({required this.icon, required this.label, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          sub,
          style: TextStyle(
            color: color.withValues(alpha: 0.7),
            fontSize: 9,
          ),
        ),
      ],
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
        // Search Bar
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: isDark ? Colors.white10 : AppTheme.accentColor.withValues(alpha: 0.1)),
          ),
          child: TextField(
            onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: isAr ? 'ابحث عن مشروع، معلم، أو شراكة...' : 'Rechercher un projet, un monument...',
              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
              prefixIcon: Icon(Icons.search_rounded, color: AppTheme.accentColor.withValues(alpha: 0.7)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterChip(context, ref, 'all', isAr ? 'الكل' : 'Tous', filter == 'all'),
              const SizedBox(width: 8),
              _buildFilterChip(context, ref, 'heritage', isAr ? 'معالم تراثية' : 'Monuments', filter == 'heritage'),
              const SizedBox(width: 8),
              _buildFilterChip(context, ref, 'project', isAr ? 'مشاريع حفظ' : 'Projets', filter == 'project'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, WidgetRef ref, String value, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => ref.read(projectFilterProvider.notifier).state = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.accentColor : (isDark ? Colors.white10 : AppTheme.accentColor.withValues(alpha: 0.2))),
        ),
        child: Text(
          label,
          style: GoogleFonts.tajawal(
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
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
  const _ProjectCard({required this.project, required this.isAr, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final lang = isAr ? 'ar' : 'fr';
    final title = project.getTitle(lang);
    final description = project.getSummary(lang);
    final partner = project.partnerName ?? (isAr ? 'شراكة' : 'Partenariat');

    return GlassCard(
      padding: EdgeInsets.zero,
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.07) : AppTheme.accentColor.withValues(alpha: 0.1),
        width: 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                    child: Icon(Icons.apartment_outlined, color: AppTheme.accentColor.withValues(alpha: 0.3), size: 60),
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                      ),
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _statusColor('نشط').withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isAr ? 'نشط' : 'Actif',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Partner chip
                Row(
                  children: [
                    const Icon(Icons.apartment_outlined, color: AppTheme.accentColor, size: 16),
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
                    Text(
                      project.publishedAt.year.toString(),
                      style: TextStyle(
                        color: isDark ? Colors.white30 : Colors.black38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Description
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    if (status.contains('جارٍ') || status.contains('cours')) return const Color(0xFFF59E0B);
    if (status.contains('نشط') || status.contains('actif')) return const Color(0xFF22C55E);
    if (status.contains('عضو') || status.contains('membre')) return const Color(0xFF009FDA);
    return AppTheme.accentColor;
  }
}

class _MilestoneTile extends StatelessWidget {
  final String label;
  final bool done;
  final bool isDark;
  const _MilestoneTile({required this.label, required this.done, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done
                  ? AppTheme.accentColor.withValues(alpha: 0.15)
                  : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04)),
              border: Border.all(
                color: done ? AppTheme.accentColor : (isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black12),
                width: 1.5,
              ),
            ),
            child: done
                ? const Icon(Icons.check_rounded, color: AppTheme.accentColor, size: 12)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: done
                    ? (isDark ? Colors.white.withValues(alpha: 0.87) : Colors.black87)
                    : (isDark ? Colors.white38 : Colors.black38),
                fontSize: 13,
                decoration: done ? null : null,
                fontWeight: done ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          if (!done)
            const Icon(Icons.schedule_rounded, size: 14, color: Colors.orange),
        ],
      ),
    );
  }
}
