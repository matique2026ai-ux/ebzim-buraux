import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/public_stats_service.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsStrip extends ConsumerWidget {
  final EdgeInsetsGeometry padding;
  final bool showDivider;

  const StatsStrip({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(publicStatsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F1A0F), const Color(0xFF081C10)]
                : [Colors.white, const Color(0xFFF8FAF9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(isDark ? 0.05 : 0.0),
              blurRadius: 20,
              spreadRadius: -10,
            ),
          ],
          border: Border.all(
            color: isDark
                ? AppTheme.accentColor.withOpacity(0.15)
                : AppTheme.primaryColor.withOpacity(0.08),
            width: 1.5,
          ),
        ),
        child: statsAsync.when(
          data: (stats) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(
                  value: '${stats.totalUsersCount}',
                  label: lang == 'ar' ? 'مستخدم مسجل' : 'Utilisateurs',
                ),
                if (showDivider) _StatDivider(),
                _StatChip(
                  value: '${stats.membersCount}',
                  label: lang == 'ar' ? 'عضو معتمد' : 'Membres',
                ),
                if (showDivider) _StatDivider(),
                _StatChip(
                  value: '${stats.activeEventsCount}',
                  label: lang == 'ar' ? 'نشاط قادم' : 'Événements',
                ),
                if (showDivider) _StatDivider(),
                _StatChip(
                  value: '${stats.totalPostsCount}',
                  label: lang == 'ar' ? 'مشروع وتقرير' : 'Projets',
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppTheme.accentColor,
              strokeWidth: 2,
            ),
          ),
          error: (_, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip(
                value: '2024',
                label: lang == 'ar' ? 'تأسست سنة' : 'Fondée en',
              ),
              if (showDivider) _StatDivider(),
              _StatChip(
                value: '15+',
                label: lang == 'ar' ? 'عضو مؤسس' : 'Fondateurs',
              ),
              if (showDivider) _StatDivider(),
              _StatChip(
                value: '9',
                label: lang == 'ar' ? 'لجان متخصصة' : 'Comités',
              ),
              if (showDivider) _StatDivider(),
              _StatChip(
                value: '2',
                label: lang == 'ar' ? 'شراكة رسمية' : 'Partenariats',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              color: isDark ? AppTheme.accentColor : AppTheme.primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white70 : Colors.black54,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(context).dividerTheme.color?.withOpacity(0.1) ??
          Colors.grey.withOpacity(0.1),
    );
  }
}
