import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const EbzimSliverAppBar(),

            // --- HEADER / INTRO ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 140, 24, 24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.support_agent_rounded,
                      color: AppTheme.accentColor,
                      size: 56,
                    ).animate().fadeIn().scale(delay: 200.ms),
                    const SizedBox(height: 16),
                    Text(
                      loc.settingsHelp,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.supportSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- QUICK CONTACT CHANNELS ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _ContactCard(
                        icon: Icons.alternate_email_rounded,
                        label: loc.supportEmailLabel,
                        value: "contact@ebzim.dz",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ContactCard(
                        icon: Icons.location_on_outlined,
                        label: loc.supportLocationLabel,
                        value: loc.supportHqValue,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // --- FAQs SECTION ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: loc.supportFaqTitle),
                    const SizedBox(height: 16),
                    _FaqTile(
                      question: "كيف يمكنني الانضمام كعضو رسمي؟",
                      answer:
                          "يمكنك تقديم طلب العضوية عبر الانتقال إلى قسم 'أعضاء الجمعية' وتعبئة بياناتك. سيقوم مجلس الأمناء بمراجعة طلبك والرد خلال 48 ساعة.",
                    ),
                    _FaqTile(
                      question: "ماهي فوائد العضوية الرقمية؟",
                      answer:
                          "تتيح لك العضوية الرقمية الوصول الحصري للفعاليات، الحصول على شهادات المشاركة، والمساهمة في لجان الجمعية الفنية والثقافية.",
                    ),
                    _FaqTile(
                      question: "كيف أقوم بتحديث بياناتي الشخصية؟",
                      answer:
                          "يمكنك تحديث بياناتك من خلال شاشة 'الملف الشخصي' > 'تعديل'، وسيتم مزامنة التغييرات فوراً مع النظام المركزي.",
                    ),
                  ],
                ).animate(delay: 600.ms).fadeIn(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.tajawal(
        color: AppTheme.accentColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.accentColor, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question, answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(16),
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.accentColor,
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),
                  Text(
                    widget.answer,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
