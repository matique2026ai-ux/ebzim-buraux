import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data Models
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

class HeritageProjectsScreen extends StatelessWidget {
  const HeritageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

            // ── Project Cards ──────────────────────────────────────────────
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final project = _projects[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: _ProjectCard(project: project, isAr: isAr, isDark: isDark),
                  ).animate().fadeIn(delay: (500 + index * 150).ms).slideY(begin: 0.08);
                },
                childCount: _projects.length,
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
// Project Card
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  final _RestorationProject project;
  final bool isAr;
  final bool isDark;
  const _ProjectCard({required this.project, required this.isAr, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final title = isAr ? project.titleAr : project.titleFr;
    final description = isAr ? project.descriptionAr : project.descriptionFr;
    final partner = isAr ? project.partnerAr : project.partnerFr;

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
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    width: double.infinity,
                    color: const Color(0xFF081C10),
                    child: Icon(project.icon, color: AppTheme.accentColor.withValues(alpha: 0.3), size: 60),
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
                          color: _statusColor(project.status).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          project.status,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.place_outlined, color: Colors.white60, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              project.location,
                              style: const TextStyle(color: Colors.white70, fontSize: 10),
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
                    Icon(project.icon, color: AppTheme.accentColor, size: 16),
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
                      project.yearStarted,
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

                // Progress (only if < 100%)
                if (project.progressPercent < 1.0) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? 'نسبة الإنجاز' : 'Avancement',
                        style: TextStyle(
                          color: isDark ? Colors.white40 : Colors.black38,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(project.progressPercent * 100).toInt()}%',
                        style: TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: project.progressPercent,
                      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                      minHeight: 6,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Milestones
                Text(
                  isAr ? 'محطات المشروع' : 'Étapes du Projet',
                  style: GoogleFonts.tajawal(
                    color: isDark ? Colors.white40 : Colors.black38,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...project.milestones.map((m) => _MilestoneTile(
                  label: isAr ? m.labelAr : m.labelFr,
                  done: m.done,
                  isDark: isDark,
                )),
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
                color: done ? AppTheme.accentColor : (isDark ? Colors.white20 : Colors.black12),
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
                    ? (isDark ? Colors.white87 : Colors.black87)
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
