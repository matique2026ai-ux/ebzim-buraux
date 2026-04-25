import 'package:flutter/material.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

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
    if (milestones.isEmpty) return const SizedBox.shrink();
    final isAr = lang == 'ar';

    return Column(
      children: milestones.asMap().entries.map((entry) {
        final idx = entry.key;
        final milestone = entry.value;
        final isLast = idx == milestones.length - 1;

        String formattedDate = DateFormat.yMMMMd(isAr ? 'ar_DZ' : 'fr').format(milestone.date);
        
        // Forced conversion to Latin numerals to be 100% sure
        if (isAr) {
          final eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
          final western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
          for (int i = 0; i < 10; i++) {
            formattedDate = formattedDate.replaceAll(eastern[i], western[i]);
          }
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: milestone.isCompleted ? AppTheme.accentColor : Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: milestone.isCompleted ? AppTheme.accentColor : Colors.white.withValues(alpha: 0.3),
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
                    child: _buildPremiumIcon(milestone, isAr),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: milestone.isCompleted 
                          ? AppTheme.accentColor.withValues(alpha: 0.5) 
                          : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.getLabel(lang),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPremiumIcon(ProjectMilestone milestone, bool isAr) {
    if (!milestone.isCompleted) return const SizedBox.shrink();

    final label = (isAr ? milestone.titleAr : milestone.titleEn).toLowerCase();
    
    IconData icon = Icons.check_rounded;
    
    // Premium mapping based on keywords
    if (label.contains('دراسة') || label.contains('تصميم') || label.contains('étude') || label.contains('conception')) {
      icon = Icons.architecture_rounded;
    } else if (label.contains('بحث') || label.contains('علمي') || label.contains('recherche') || label.contains('scientifique')) {
      icon = Icons.science_rounded;
    } else if (label.contains('ترميم') || label.contains('تنفيذ') || label.contains('اشغال') || label.contains('restauration') || label.contains('travaux')) {
      icon = Icons.construction_rounded;
    } else if (label.contains('افتتاح') || label.contains('إطلاق') || label.contains('inauguration') || label.contains('lancement')) {
      icon = Icons.rocket_launch_rounded;
    } else if (label.contains('توثيق') || label.contains('أرشفة') || label.contains('documentation') || label.contains('archive')) {
      icon = Icons.auto_stories_rounded;
    } else if (label.contains('ميداني') || label.contains('terrain')) {
      icon = Icons.explore_rounded;
    }

    return Icon(icon, size: 10, color: Colors.black);
  }
}
