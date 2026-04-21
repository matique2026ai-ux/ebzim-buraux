import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Membership Discover Screen — Premium institutional join page
// Tri-lingual: AR / EN / FR
// ─────────────────────────────────────────────────────────────────────────────

class MembershipDiscoverScreen extends StatelessWidget {
  const MembershipDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isFr = Localizations.localeOf(context).languageCode == 'fr';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
                ),
                child: IconButton(
                  icon: Icon(
                    isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
                    color: AppTheme.accentColor,
                    size: 18,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── HERO ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, size.height * 0.12, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gold pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppTheme.accentColor.withOpacity(0.4), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: AppTheme.accentColor, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            (isAr
                                ? 'العضوية الرسمية'
                                : isFr
                                    ? 'Adhésion Officielle'
                                    : 'Official Membership').toUpperCase(),
                            style: GoogleFonts.playfairDisplay(
                              color: AppTheme.accentColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.9, 0.9)),

                    const SizedBox(height: 18),

                    Text(
                      isAr
                          ? 'كن جزءاً من\nإبزيم'
                          : isFr
                              ? 'Rejoignez\nEbzim'
                              : 'Become Part\nof Ebzim',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                    const SizedBox(height: 14),

                    Text(
                      isAr
                          ? 'انضم إلى جمعية رائدة تجمع الثقافة والمواطنة والتراث في ولاية سطيف'
                          : isFr
                              ? 'Rejoignez une association pionnière qui unit culture, citoyenneté et patrimoine à Sétif'
                              : 'Join a pioneering association uniting culture, citizenship and heritage in Sétif',
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                    ).animate().fadeIn(delay: 350.ms),

                    const SizedBox(height: 36),

                    // Stats row
                    Row(
                      children: [
                        _StatChip(
                          value: '2024',
                          label: isAr ? 'تأسست' : isFr ? 'Fondée' : 'Founded',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          value: '3',
                          label: isAr ? 'شراكات' : isFr ? 'Partenariats' : 'Partnerships',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          value: 'سطيف',
                          label: isAr ? 'الولاية' : isFr ? 'Wilaya' : 'Wilaya',
                          isDark: isDark,
                        ),
                      ],
                    ).animate().fadeIn(delay: 450.ms),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),

            // ── PILLARS ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(
                      label: isAr ? 'لماذا تنخرط؟' : isFr ? 'Pourquoi adhérer ?' : 'Why Join?',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    ..._pillars(isAr, isFr).asMap().entries.map((e) {
                      final i = e.key;
                      final p = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PillarCard(pillar: p, isDark: isDark),
                      ).animate()
                          .fadeIn(delay: Duration(milliseconds: 500 + i * 80))
                          .slideX(begin: 0.04, curve: Curves.easeOutCubic);
                    }),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── CONDITIONS ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(
                      label: isAr ? 'شروط الانخراط' : isFr ? 'Conditions d\'adhésion' : 'Membership Conditions',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.03)
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.accentColor.withOpacity(0.12)),
                          ),
                          child: Column(
                            children: _conditions(isAr, isFr).asMap().entries.map((e) {
                              final isLast = e.key == _conditions(isAr, isFr).length - 1;
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 32, height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.accentColor.withOpacity(isDark ? 0.12 : 0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${e.key + 1}',
                                            style: TextStyle(
                                              color: AppTheme.accentColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            e.value,
                                            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isLast) Divider(
                                    height: 20,
                                    color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 750.ms).slideY(begin: 0.06),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── LEGAL NOTICE ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withOpacity(isDark ? 0.07 : 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.verified_outlined, color: Color(0xFF22C55E), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isAr
                              ? 'الانخراط خاضع لدفع الاشتراك السنوي ومراجعة اللجنة التنفيذية وفقاً للقانون الأساسي المصادق عليه في 14 ديسمبر 2024.'
                              : isFr
                                  ? 'L\'adhésion est soumise au paiement d\'une cotisation annuelle et à l\'examen du bureau exécutif conformément aux statuts ratifiés le 14 décembre 2024.'
                                  : 'Membership requires annual subscription payment and is subject to executive board review per the statutes ratified December 14, 2024.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF22C55E),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 850.ms),
            ),

            // ── STICKY CTA ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
                child: Column(
                  children: [
                    // Primary CTA
                    Container(
                      height: 62,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accentColor,
                            const Color(0xFFB8941E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentColor.withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            context.push('/membership/apply');
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.how_to_reg_rounded, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  isAr
                                      ? 'قدّم طلب الانخراط'
                                      : isFr
                                          ? 'Déposer une adhésion'
                                          : 'Apply for Membership',
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 950.ms)
                        .scale(begin: const Offset(0.96, 0.96), curve: Curves.easeOutBack),

                    const SizedBox(height: 14),

                    // Note
                    Text(
                      isAr
                          ? 'العضوية منفصلة عن حساب التطبيق'
                          : isFr
                              ? 'L\'adhésion est distincte du compte applicatif'
                              : 'Membership is separate from your app account',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        // fontStyle removed for accessibility,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ).animate().fadeIn(delay: 1050.ms),
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

// ─────────────────────────────────────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────────────────────────────────────

class _Pillar {
  final IconData icon;
  final String titleAr;
  final String titleEn;
  final String titleFr;
  final String bodyAr;
  final String bodyEn;
  final String bodyFr;
  final Color color;
  const _Pillar({required this.icon, required this.titleAr, required this.titleEn, required this.titleFr, required this.bodyAr, required this.bodyEn, required this.bodyFr, required this.color});
}

List<_Pillar> _pillars(bool isAr, bool isFr) => [
  const _Pillar(
    icon: Icons.account_balance_outlined,
    titleAr: 'الحوكمة والشفافية',
    titleEn: 'Governance & Transparency',
    titleFr: 'Gouvernance et Transparence',
    bodyAr: 'تسيير رشيد ومؤسسي مع إعلانات دورية في الجريدة الرسمية للجمعيات.',
    bodyEn: 'Institutional and transparent management with periodic publications in the official associations gazette.',
    bodyFr: 'Gestion institutionnelle et transparente, avec publications périodiques au Journal des Associations.',
    color: AppTheme.accentColor,
  ),
  const _Pillar(
    icon: Icons.apartment_outlined,
    titleAr: 'مشاريع وطنية حقيقية',
    titleEn: 'Real National Projects',
    titleFr: 'Projets Nationaux Concrets',
    bodyAr: 'ترميم الثكنة العسكرية، شراكة المتحف الوطني للآثار، وعضوية شبكة اليونسكو.',
    bodyEn: 'Military barracks restoration, National Museum of Antiquities partnership, and UNESCO network membership.',
    bodyFr: 'Restauration de la caserne, partenariat Musée National des Antiquités, adhésion réseau UNESCO.',
    color: Color(0xFF22C55E),
  ),
  const _Pillar(
    icon: Icons.groups_outlined,
    titleAr: 'مجتمع مدني فاعل',
    titleEn: 'Active Civil Society',
    titleFr: 'Société Civile Active',
    bodyAr: 'كن صوتاً فاعلاً في الفعل الثقافي المواطني والرقابة على الموروث العمراني.',
    bodyEn: 'Be an active voice in civic cultural action and oversight of the built heritage.',
    bodyFr: 'Soyez une voix active dans l\'action culturelle civique et la sauvegarde du patrimoine bâti.',
    color: Color(0xFF8B5CF6),
  ),
];

List<String> _conditions(bool isAr, bool isFr) => isAr
    ? [
        'أن تكون ناشطاً في المجال الاجتماعي أو الثقافي أو الفني أو مساهماً في خدمة الصالح العام.',
        'أن تكون من ذوي الأخلاق الحسنة وألا يكون له أي نشاط يتعارض مع المصالح العليا للأمة الجزائرية.',
        'أن يلتزم بالقانون الأساسي والنظام الداخلي للجمعية وقيمها الثوابت (المادة 10).',
        'أن يسدّد الاشتراك السنوي للجمعية كشرط أساسي لتفعيل العضوية والتمتع بكامل الحقوق.',
      ]
    : isFr
        ? [
            'Être actif dans le domaine social, culturel ou artistique, ou contribuer au bien public.',
            'Être de bonne moralité et n\'avoir aucune activité contraire aux intérêts supérieurs de la nation algérienne.',
            'S\'engager à respecter les statuts, le règlement intérieur et les valeurs fondatrices de l\'association (Article 10).',
            'S\'acquitter de la cotisation annuelle de l\'association, condition indispensable à l\'activation de l\'adhésion.',
          ]
        : [
            'Be active in the social, cultural or artistic field, or contribute to public welfare.',
            'Be of good moral standing and have no activity contrary to the supreme interests of the Algerian nation.',
            'Commit to abide by the association\'s statutes, internal regulations, and founding values (Article 10).',
            'Pay the annual membership subscription as a mandatory condition to activate membership rights.',
          ];

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;
  const _StatChip({required this.value, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.65),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.accentColor.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.tajawal(
                color: AppTheme.accentColor,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28, height: 3,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
          margin: const EdgeInsetsDirectional.only(end: 10),
        ),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.playfairDisplay(
            color: AppTheme.accentColor,
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }
}

class _PillarCard extends StatelessWidget {
  final _Pillar pillar;
  final bool isDark;
  const _PillarCard({required this.pillar, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isFr = Localizations.localeOf(context).languageCode == 'fr';
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.03)
                : Colors.white.withOpacity(0.68),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: pillar.color.withOpacity(isDark ? 0.15 : 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: pillar.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(pillar.icon, color: pillar.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? pillar.titleAr : isFr ? pillar.titleFr : pillar.titleEn,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: pillar.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isAr ? pillar.bodyAr : isFr ? pillar.bodyFr : pillar.bodyEn,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.55),
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
}
