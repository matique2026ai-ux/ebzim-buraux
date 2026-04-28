import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_sliver_app_bar.dart';

import 'package:ebzim_app/core/services/news_service.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;
  final dynamic initialEvent; // Can be ActivityEvent or NewsPost

  const EventDetailsScreen({
    super.key, 
    required this.eventId,
    this.initialEvent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final eventAsync = ref.watch(eventDetailsProvider(eventId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Local helper to extract data regardless of model type
    Widget _buildContent(dynamic event) {
      final locale = Localizations.localeOf(context);
      final lang = locale.languageCode;
      final fullLocale = locale.toString();
      final dateFormat = DateFormat('MMMM dd, yyyy', fullLocale);

      String title = '';
      String description = '';
      String location = '';
      String category = '';
      String imageUrl = '';
      DateTime date = DateTime.now();

      if (event is ActivityEvent) {
        title = event.getTitle(lang);
        description = event.getDescription(lang);
        location = event.getLocation(lang);
        category = event.getCategory(lang);
        imageUrl = event.imageUrl;
        date = event.date;
      } else if (event is NewsPost) {
        title = event.getTitle(lang);
        description = event.getSummary(lang);
        location = 'Ebzim'; // NewsPost doesn't have metadata/location field in current model
        category = event.category;
        imageUrl = event.imageUrl;
        date = event.publishedAt;
      }

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
                CachedNetworkImage(
                  imageUrl: imageUrl, 
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      category.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.accentColor),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.primaryColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: [
                      _buildIconLabel(Icons.calendar_today, dateFormat.format(date)),
                      _buildIconLabel(Icons.schedule, DateFormat('HH:mm', fullLocale).format(date)),
                      _buildIconLabel(Icons.location_on_outlined, location),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    loc.eventAboutGathering,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.8, color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black87),
                  ),
                  const SizedBox(height: 40),
                  _buildVenueBox(location, isDark, theme, loc),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: initialEvent != null 
          ? _buildContent(initialEvent)
          : eventAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentColor)),
              error: (e, _) => Center(child: Text(e.toString(), style: const TextStyle(color: Colors.white))),
              data: (event) => _buildContent(event),
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (initialEvent != null || eventAsync.hasValue) ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ElevatedButton.icon(
          onPressed: () => _showRegisterDialog(context, loc),
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

  Widget _buildVenueBox(String location, bool isDark, ThemeData theme, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 40, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.eventVenue.toUpperCase(), style: TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold, color: AppTheme.accentColor.withValues(alpha: 0.8))),
          const SizedBox(height: 16),
          Text(location, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.map_outlined, size: 16, color: AppTheme.accentColor),
            label: Text(loc.eventOpenMaps.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1, color: AppTheme.accentColor)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          )
        ],
      ),
    );
  }

  void _showRegisterDialog(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.backgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('تسجيل في الفعالية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('للتسجيل في هذه الفعالية، يرجى التواصل مع الجمعية عبر صفحة المساهمات أو الاتصال المباشر.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); context.push('/contributions'); },
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
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
      ],
    );
  }
}
