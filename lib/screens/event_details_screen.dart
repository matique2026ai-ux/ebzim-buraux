import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/event_service.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final eventAsync = ref.watch(eventDetailsProvider(eventId));

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
        data: (event) {
          final lang = Localizations.localeOf(context).languageCode;
          final dateFormat = DateFormat('MMMM dd, yyyy', lang);
          final title = event.getTitle(lang);
          final description = event.getDescription(lang);
          final location = event.getLocation(lang);
          final category = event.getCategory(lang);

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Immersive Hero
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(event.imageUrl, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryColor.withValues(alpha: 0.2), AppTheme.primaryColor.withValues(alpha: 0.95)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category.toUpperCase(),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 24,
                              runSpacing: 12,
                              children: [
                                _buildIconLabel(Icons.calendar_today, dateFormat.format(event.date)),
                                _buildIconLabel(Icons.schedule, DateFormat('HH:mm').format(event.date)),
                                _buildIconLabel(Icons.location_on, location),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.eventAboutGathering,
                        style: TextStyle(
                          fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Venue Box
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.eventVenue.toUpperCase(),
                              style: const TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor),
                            ),
                            const SizedBox(height: 16),
                            Text(location, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryColor)),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Map feature coming soon'))),
                              icon: const Icon(Icons.arrow_outward, size: 16),
                              label: Text(loc.eventOpenMaps.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5)),
                              style: TextButton.styleFrom(foregroundColor: AppTheme.secondaryColor, padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: eventAsync.hasValue ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ElevatedButton.icon(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('تسجيل في الفعالية'),
              content: const Text('للتسجيل في هذه الفعالية، يرجى التواصل مع الجمعية عبر صفحة المساهمات أو الاتصال المباشر.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/contributions');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white),
                  child: const Text('المساهمات'),
                ),
              ],
            ),
          ),
          icon: const Icon(Icons.check_circle_outline),
          label: Text(loc.eventRegister.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 10,
          ),
        ),
      ) : null,
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppTheme.accentColor, size: 16),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white.withValues(alpha: 0.9)),
        ),
      ],
    );
  }
}
