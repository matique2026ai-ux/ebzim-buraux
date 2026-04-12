import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/services/report_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Report Type model
// ─────────────────────────────────────────────────────────────────────────────

class _ReportType {
  final String id;
  final String labelAr;
  final String labelFr;
  final String descAr;
  final String descFr;
  final IconData icon;
  final Color color;

  const _ReportType({
    required this.id,
    required this.labelAr,
    required this.labelFr,
    required this.descAr,
    required this.descFr,
    required this.icon,
    required this.color,
  });
}

final _reportTypes = [
  const _ReportType(
    id: 'VANDALISM',
    labelAr: 'تشويه عمراني',
    labelFr: 'Dégradation urbaine',
    descAr: 'كتابة على جدران، طلاء أو تلف مبانٍ تاريخية',
    descFr: 'Graffiti, peinture ou dégradation de bâtiments historiques',
    icon: Icons.format_paint_outlined,
    color: Color(0xFFF59E0B),
  ),
  const _ReportType(
    id: 'THEFT',
    labelAr: 'سرقة أثرية',
    labelFr: 'Vol archéologique',
    descAr: 'نهب أو نقل قطع أثرية أو تراثية',
    descFr: 'Pillage ou déplacement de pièces archéologiques',
    icon: Icons.gavel_outlined,
    color: Color(0xFFEF4444),
  ),
  const _ReportType(
    id: 'ILLEGAL_CONSTRUCTION',
    labelAr: 'بناء عشوائي',
    labelFr: 'Construction illicite',
    descAr: 'تعدٍّ على أراضٍ محاذية لمواقع أثرية',
    descFr: 'Empiètement sur des sites archéologiques classés',
    icon: Icons.construction_outlined,
    color: Color(0xFFEF4444),
  ),
  const _ReportType(
    id: 'NEGLECT',
    labelAr: 'إهمال الموقع',
    labelFr: 'Abandon du site',
    descAr: 'ترك مواقع أثرية دون صيانة حتى التحلل',
    descFr: 'Abandon de sites patrimoniaux sans entretien',
    icon: Icons.broken_image_outlined,
    color: Color(0xFF8B5CF6),
  ),
  const _ReportType(
    id: 'PUBLIC_SPACE',
    labelAr: 'إتلاف الفضاء العام',
    labelFr: 'Dégradation espace public',
    descAr: 'تلوث أو أضرار تمس الفضاء المشترك في المدينة',
    descFr: 'Pollution ou dommages dans l\'espace public de la ville',
    icon: Icons.eco_outlined,
    color: Color(0xFF22C55E),
  ),
  const _ReportType(
    id: 'OTHER',
    labelAr: 'أخرى',
    labelFr: 'Autre',
    descAr: 'أي انتهاك آخر يمس المواطنة والحياة المشتركة',
    descFr: 'Toute autre violation affectant la citoyenneté',
    icon: Icons.report_gmailerrorred_outlined,
    color: Color(0xFF6B7280),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class _CivicReportState {
  final String? selectedType;
  final String location;
  final String description;
  final bool isSubmitting;
  final bool isSubmitted;

  const _CivicReportState({
    this.selectedType,
    this.location = '',
    this.description = '',
    this.isSubmitting = false,
    this.isSubmitted = false,
  });

  _CivicReportState copyWith({
    String? selectedType,
    String? location,
    String? description,
    bool? isSubmitting,
    bool? isSubmitted,
  }) {
    return _CivicReportState(
      selectedType: selectedType ?? this.selectedType,
      location: location ?? this.location,
      description: description ?? this.description,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

class _CivicReportNotifier extends StateNotifier<_CivicReportState> {
  final Ref _ref;
  _CivicReportNotifier(this._ref) : super(const _CivicReportState());

  void selectType(String id) => state = state.copyWith(selectedType: id);
  void setLocation(String v) => state = state.copyWith(location: v);
  void setDescription(String v) => state = state.copyWith(description: v);

  Future<void> submit() async {
    if (state.selectedType == null) return;
    
    state = state.copyWith(isSubmitting: true);
    try {
      final reportService = _ref.read(reportServiceProvider);
      await reportService.submitReport(
        category: state.selectedType!,
        location: state.location,
        description: state.description,
      );
      state = state.copyWith(isSubmitting: false, isSubmitted: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false);
      // Let the screen handle error UI if needed, for now we just stop loading
    }
  }
}

final _civicReportProvider = StateNotifierProvider.autoDispose<_CivicReportNotifier, _CivicReportState>(
  (ref) => _CivicReportNotifier(ref),
);

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class CivicReportScreen extends ConsumerStatefulWidget {
  const CivicReportScreen({super.key});

  @override
  ConsumerState<CivicReportScreen> createState() => _CivicReportScreenState();
}

class _CivicReportScreenState extends ConsumerState<CivicReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_civicReportProvider);
    final notifier = ref.read(_civicReportProvider.notifier);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isEn = Localizations.localeOf(context).languageCode == 'en';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // ── Success Screen ─────────────────────────────────────────────────────
    if (state.isSubmitted) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: AppTheme.accentColor, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: EbzimBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentColor.withValues(alpha: 0.1),
                      border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.check_circle_outline_rounded, color: AppTheme.accentColor, size: 52),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  Text(
                    loc.repSuccess,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                  const SizedBox(height: 12),
                  Text(
                    isAr
                        ? 'شكراً على مساهمتك في صون التراث والفضاء المشترك. سيتم مراجعة بلاغك من قِبل فريق جمعية إبزيم في أقرب وقت.'
                        : (isEn ? 'Thank you for your contribution to heritage preservation. Your report will be reviewed by the Ebzim team.' : 'Merci pour votre contribution à la sauvegarde du patrimoine. Votre signalement sera examiné par l\'équipe Ebzim.'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white60 : Colors.black54,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 36),
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.home_outlined),
                    label: Text(isAr ? 'العودة للرئيسية' : 'Retour à l\'accueil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ).animate().fadeIn(delay: 700.ms),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ── Main Form ──────────────────────────────────────────────────────────
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.accentColor,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          loc.repTitle,
          style: GoogleFonts.tajawal(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: EbzimBackground(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 110, 24, 100),
            children: [
              // ── Header ────────────────────────────────────────────────────
              GlassCard(
                padding: const EdgeInsets.all(20),
                border: Border.all(
                  color: AppTheme.accentColor.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accentColor.withValues(alpha: 0.1),
                      ),
                      child: const Icon(Icons.shield_outlined, color: AppTheme.accentColor, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'المواطن البلاغي المدني' : 'Espace de Signalement Civique',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr
                                ? 'بلاغك يُحوَّل لفريق جمعية إبزيم للمتابعة والإحالة'
                                : 'Votre signalement est traité par l\'équipe Ebzim',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.white50 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 28),

              // ── Step 1: Type ──────────────────────────────────────────────
              _StepLabel(number: '1', label: isAr ? 'نوع الانتهاك' : 'Type de violation', isDark: isDark),
              const SizedBox(height: 12),
              ...List.generate(_reportTypes.length, (i) {
                final t = _reportTypes[i];
                final selected = state.selectedType == t.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TypeTile(
                    type: t,
                    selected: selected,
                    isAr: isAr,
                    isDark: isDark,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      notifier.selectType(t.id);
                    },
                  ),
                ).animate().fadeIn(delay: (150 + i * 60).ms).slideX(begin: 0.05);
              }),

              const SizedBox(height: 28),

              // ── Step 2: Location ──────────────────────────────────────────
              _StepLabel(number: '2', label: isAr ? 'الموقع الجغرافي' : 'Localisation', isDark: isDark),
              const SizedBox(height: 12),
              _FieldBox(
                controller: _locationController,
                hint: isAr ? 'مثال: شارع الشهداء، البلدية، الولاية...' : 'Ex: Rue des Martyrs, commune, wilaya...',
                icon: Icons.location_on_outlined,
                isDark: isDark,
                onChanged: notifier.setLocation,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? (isAr ? 'يرجى تحديد الموقع' : 'Veuillez préciser le lieu')
                    : null,
              ).animate().fadeIn(delay: 450.ms),

              const SizedBox(height: 28),

              // ── Step 3: Description ───────────────────────────────────────
              _StepLabel(number: '3', label: isAr ? 'وصف الانتهاك' : 'Description de la violation', isDark: isDark),
              const SizedBox(height: 12),
              _FieldBox(
                controller: _descriptionController,
                hint: isAr
                    ? 'صِف ما شاهدته بأكبر قدر من التفاصيل...'
                    : 'Décrivez ce que vous avez observé avec le maximum de détails...',
                icon: Icons.description_outlined,
                isDark: isDark,
                maxLines: 5,
                onChanged: notifier.setDescription,
                validator: (v) => (v == null || v.trim().length < 10)
                    ? (isAr ? 'يرجى كتابة وصف أوضح' : 'Veuillez fournir une description plus détaillée')
                    : null,
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 28),

              // ── Step 4: Evidence notice ───────────────────────────────────
              _StepLabel(number: '4', label: isAr ? 'إرفاق دليل (قريباً)' : 'Joindre une preuve (bientôt)', isDark: isDark),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt_outlined, color: isDark ? Colors.white30 : Colors.black26, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isAr
                            ? 'ميزة إرفاق الصور والفيديو ستكون متاحة في التحديث القادم'
                            : 'La fonctionnalité de pièces jointes (photos/vidéos) sera disponible prochainement',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white30 : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 550.ms),

              const SizedBox(height: 36),

              // ── Submit Button ─────────────────────────────────────────────
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: state.selectedType != null ? AppTheme.accentColor : Colors.grey.withValues(alpha: 0.3),
                  boxShadow: state.selectedType != null
                      ? [BoxShadow(color: AppTheme.accentColor.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))]
                      : [],
                ),
                child: InkWell(
                  onTap: state.selectedType == null
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            HapticFeedback.heavyImpact();
                            notifier.submit();
                          }
                        },
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            loc.repSubmit,
                            style: GoogleFonts.tajawal(
                              color: state.selectedType != null ? Colors.white : Colors.white38,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.96, 0.96)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _StepLabel extends StatelessWidget {
  final String number;
  final String label;
  final bool isDark;
  const _StepLabel({required this.number, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accentColor.withValues(alpha: 0.15),
            border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(color: AppTheme.accentColor, fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.tajawal(
            color: isDark ? Colors.white70 : Colors.black72,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TypeTile extends StatelessWidget {
  final _ReportType type;
  final bool selected;
  final bool isAr;
  final bool isDark;
  final VoidCallback onTap;
  const _TypeTile({required this.type, required this.selected, required this.isAr, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? type.color.withValues(alpha: 0.1)
              : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white.withValues(alpha: 0.6)),
          border: Border.all(
            color: selected ? type.color.withValues(alpha: 0.5) : (isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06)),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: type.color.withValues(alpha: selected ? 0.2 : 0.08),
              ),
              child: Icon(type.icon, color: type.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? type.labelAr : type.labelFr,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isAr ? type.descAr : type.descFr,
                    style: TextStyle(
                      color: isDark ? Colors.white40 : Colors.black45,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: type.color, size: 20),
          ],
        ),
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isDark;
  final int maxLines;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  const _FieldBox({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.isDark,
    this.maxLines = 1,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.7),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.07)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        validator: validator,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? Colors.white25 : Colors.black26,
            fontSize: 13,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(top: 14, left: 12, right: 12),
            child: Icon(icon, color: AppTheme.accentColor.withValues(alpha: 0.6), size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
