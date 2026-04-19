import 'package:flutter/material.dart';
import 'package:ebzim_app/core/models/news_post.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class EbzimProjectTimeline extends StatelessWidget {
  final List<ProjectMilestone> milestones;

  const EbzimProjectTimeline({super.key, required this.milestones});

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) return const SizedBox.shrink();

    return Column(
      children: milestones.asMap().entries.map((entry) {
        final idx = entry.key;
        final milestone = entry.value;
        final isLast = idx == milestones.length - 1;

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
                      color: milestone.isCompleted ? AppTheme.accentColor : Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: milestone.isCompleted ? AppTheme.accentColor : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: milestone.isCompleted ? [
                        BoxShadow(
                          color: AppTheme.accentColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ] : null,
                    ),
                    child: milestone.isCompleted 
                      ? const Icon(Icons.check, size: 12, color: Colors.black) 
                      : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: milestone.isCompleted 
                          ? AppTheme.accentColor.withOpacity(0.5) 
                          : Colors.white.withOpacity(0.1),
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
                        milestone.titleAr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          decoration: milestone.isCompleted ? TextDecoration.none : null,
                        ),
                      ),
                      if (milestone.descriptionAr != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          milestone.descriptionAr!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
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
}
