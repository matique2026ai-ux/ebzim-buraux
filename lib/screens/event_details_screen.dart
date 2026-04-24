import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final eventAsync = ref.watch(eventDetailsProvider(eventId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: eventAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentColor)),
          error: (e, s) => Center(child: Text(e.toString(), style: const TextStyle(color: Colors.white))),
          data: (event) {
            final lang = Localizations.localeOf(context).languageCode;
            final dateFormat = DateFormat('MMMM dd, yyyy', lang);
            final title = event.getTitle(lang);
            final description = event.getDescription(lang);
            final location = event.getLocation(lang);
            final category = event.getCategory(lang);

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                EbzimSliverAppBar(
                  expandedHeight: 400,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(event.imageUrl, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.1),
                              AppTheme.backgroundDark.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            category.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10, 
                              fontWeight: FontWeight.bold, 
                              letterSpacing: 2, 
                              color: AppTheme.accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Title
                        Text(
                          title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.primaryColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Quick Info
                        Wrap(
                          spacing: 24,
                          runSpacing: 16,
                          children: [
                            _buildIconLabel(Icons.calendar_today, dateFormat.format(event.date)),
                            _buildIconLabel(Icons.schedule, DateFormat('HH:mm').format(event.date)),
                            _buildIconLabel(Icons.location_on_outlined, location),
                          ],
                        ),
                        const SizedBox(height: 40),
                        
                        // Description Section
                        Text(
                          loc.eventAboutGathering,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.8,
                            color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Venue Glass Box
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1), 
                                blurRadius: 40, 
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.eventVenue.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10, 
                                  letterSpacing: 2, 
                                  fontWeight: FontWeight.bold, 
                                  color: AppTheme.accentColor.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                location, 
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.map_outlined, size: 16, color: AppTheme.accentColor),
                                label: Text(
                                  loc.eventOpenMaps.toUpperCase(), 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1, color: AppTheme.accentColor),
                                ),
                                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 120), // Spacer for FAB
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: eventAsync.hasValue ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ElevatedButton.icon(
          onPressed: () => _showRegisterDialog(context),
          icon: const Icon(Icons.how_to_reg_rounded),
          label: Text(loc.eventRegister.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
          ),
        ),
      ) : null,
    );
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.backgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('تسجيل في الفعالية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'للتسجيل في هذه الفعالية، يرجى التواصل مع الجمعية عبر صفحة المساهمات أو الاتصال المباشر.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/contributions');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
            child: const Text('المساهمات'),
          ),
        ],
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppTheme.accentColor, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.w600, 
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
