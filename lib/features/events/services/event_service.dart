import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../../main.dart';

class ActivityEvent {
  final String id;
  final String titleEn;
  final String titleAr;
  final String titleFr;
  final String descriptionEn;
  final String descriptionAr;
  final String descriptionFr;
  final DateTime date;
  final String locationEn;
  final String locationAr;
  final String locationFr;
  final String imageUrl;
  final String categoryEn;
  final String categoryAr;
  final String categoryFr;
  final bool isFeatured;

  ActivityEvent({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.titleFr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.date,
    required this.locationEn,
    required this.locationAr,
    required this.locationFr,
    required this.imageUrl,
    required this.categoryEn,
    required this.categoryAr,
    required this.categoryFr,
    this.isFeatured = false,
  });

  factory ActivityEvent.fromJson(Map<String, dynamic> json) {
    final title = json['title'] ?? {};
    final desc = json['description'] ?? {};
    final location = json['location']?['formattedAddress'] ?? 'N/A';
    
    return ActivityEvent(
      id: json['_id'] ?? '',
      titleEn: title['en'] ?? '',
      titleAr: title['ar'] ?? '',
      titleFr: title['fr'] ?? '',
      descriptionEn: desc['en'] ?? '',
      descriptionAr: desc['ar'] ?? '',
      descriptionFr: desc['fr'] ?? '',
      date: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      locationEn: location,
      locationAr: location,
      locationFr: location,
      imageUrl: json['coverImage']?['url'] ?? 'https://via.placeholder.com/400',
      categoryEn: 'General', // Simplified for now as category details might need another fetch
      categoryAr: 'عام',
      categoryFr: 'Général',
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  String getTitle(String languageCode) {
    if (languageCode == 'ar') return titleAr;
    if (languageCode == 'fr') return titleFr;
    return titleEn;
  }

  String getDescription(String languageCode) {
    if (languageCode == 'ar') return descriptionAr;
    if (languageCode == 'fr') return descriptionFr;
    return descriptionEn;
  }

  String getLocation(String languageCode) {
    if (languageCode == 'ar') return locationAr;
    if (languageCode == 'fr') return locationFr;
    return locationEn;
  }

  String getCategory(String languageCode) {
    if (languageCode == 'ar') return categoryAr;
    if (languageCode == 'fr') return categoryFr;
    return categoryEn;
  }
}

class EventService {
  final Ref _ref;

  EventService(this._ref);

  Future<List<ActivityEvent>> getUpcomingEvents() async {
    try {
      final lang = _ref.read(localeProvider).languageCode;
      final response = await _ref.read(apiClientProvider).dio.get(
        'events',
        options: Options(headers: {'Accept-Language': lang}),
      );

      final List data = response.data['data'] ?? [];
      return data.map((e) => ActivityEvent.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) print('Error fetching events: $e');
      return [];
    }
  }

  Future<ActivityEvent> getEventDetails(String id) async {
    final lang = _ref.read(localeProvider).languageCode;
    final response = await _ref.read(apiClientProvider).dio.get(
      '/events/$id',
      options: Options(headers: {'Accept-Language': lang}),
    );
    return ActivityEvent.fromJson(response.data);
  }
}

final eventServiceProvider = Provider((ref) => EventService(ref));

final upcomingEventsProvider = FutureProvider<List<ActivityEvent>>((ref) {
  return ref.watch(eventServiceProvider).getUpcomingEvents();
});

final eventDetailsProvider = FutureProvider.family<ActivityEvent, String>((ref, id) {
  return ref.watch(eventServiceProvider).getEventDetails(id);
});
