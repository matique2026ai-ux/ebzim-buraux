import 'package:flutter/material.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:google_fonts/google_fonts.dart';

class EbzimProjectTimeline extends StatelessWidget {
  final List<ProjectMilestone> milestones;
  final String lang;

  const EbzimProjectTimeline({
    super.key,
    required this.milestones,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            lang == 'ar' ? 'لا توجد مراحل مسجلة حالياً' : 'Aucune étape enregistrée',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(milestones.length, (index) {
        final milestone = milestones[index];
        final isLast = index == milestones.length - 1;
        final isAr = lang == 'ar';

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line and indicator
              Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: milestone.isCompleted ? AppTheme.accentColor : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: milestone.isCompleted ? AppTheme.accentColor : AppTheme.accentColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: milestone.isCompleted ? [
                        BoxShadow(
                          color: AppTheme.accentColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ] : null,
                    ),
                    child: milestone.isCompleted 
                      ? const Icon(Icons.check, size: 8, color: Colors.white)
                      : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: AppTheme.accentColor.withValues(alpha: 0.2),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Milestone Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.getLabel(lang),
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: milestone.isCompleted 
                            ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                            : (Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${milestone.date.day}/${milestone.date.month}/${milestone.date.year}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.accentColor.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
