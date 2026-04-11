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
    final monthFormat = DateFormat('MMM', Localizations.localeOf(context).languageCode);
    final dayFormat = DateFormat('dd');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 24.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Box
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Stack(
                children: [
                  // Date Badge
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 16,
                    start: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayFormat.format(event.date),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
                          ),
                          Text(
                            monthFormat.format(event.date).toUpperCase(),
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.6)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              event.getTitle(Localizations.localeOf(context).languageCode),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF032211),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.getLocation(Localizations.localeOf(context).languageCode).toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withValues(alpha: 0.5) 
                    : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
