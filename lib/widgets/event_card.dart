import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/event_service.dart';

class EventCard extends StatelessWidget {
  final ActivityEvent event;
  final VoidCallback onTap;
  final double? width;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.width = 280,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final monthFormat = DateFormat('MMM', lang);
    final dayFormat = DateFormat('dd');
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsetsDirectional.only(end: 24.0, bottom: 12.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Box with Glass Date
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    image: DecorationImage(
                      image: NetworkImage(event.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Glass Date Badge
                Positioned(
                  top: 16,
                  right: lang == 'ar' ? 16 : null,
                  left: lang != 'ar' ? 16 : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dayFormat.format(event.date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppTheme.accentColor,
                              ),
                            ),
                            Text(
                              monthFormat.format(event.date).toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.getTitle(lang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: theme.brightness == Brightness.dark ? Colors.white : AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.accentColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.getLocation(lang).toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            color: theme.brightness == Brightness.dark 
                                ? Colors.white.withOpacity(0.6) 
                                : AppTheme.primaryColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
