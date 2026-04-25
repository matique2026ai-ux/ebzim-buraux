import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

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
  final String categorySlug;
  final bool isFeatured;
  final double price;
  final int capacity;

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
    this.categorySlug = 'all',
    this.isFeatured = false,
    this.price = 0.0,
    this.capacity = 0,
  });

  factory ActivityEvent.fromJson(Map<String, dynamic> json) {
    final title = json['title'] is Map ? json['title'] : {};
    final desc = json['description'] is Map ? json['description'] : {};
    final location =
        (json['location'] is Map &&
            json['location']['formattedAddress'] != null)
        ? json['location']['formattedAddress']
        : 'N/A';

    // Defensive numeric parsing
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    final categoryData = json['category'] is Map ? json['category'] : {};
    final catName = categoryData['name'] is Map ? categoryData['name'] : {};

    return ActivityEvent(
      id: json['_id']?.toString() ?? '',
      titleEn: title['en']?.toString() ?? '',
      titleAr: title['ar']?.toString() ?? '',
      titleFr: title['fr']?.toString() ?? '',
      descriptionEn: desc['en']?.toString() ?? '',
      descriptionAr: desc['ar']?.toString() ?? '',
      descriptionFr: desc['fr']?.toString() ?? '',
      date:
          DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      locationEn: location.toString(),
      locationAr: location.toString(),
      locationFr: location.toString(),
      imageUrl: (json['coverImage'] is Map)
          ? (json['coverImage']['url']?.toString() ??
                'https://placehold.co/600x400/020617/F7C04A/png?text=EBZIM')
          : 'https://placehold.co/600x400/020617/F7C04A/png?text=EBZIM',
      categoryEn: catName['en']?.toString() ?? 'General',
      categoryAr: catName['ar']?.toString() ?? 'عام',
      categoryFr: catName['fr']?.toString() ?? 'Général',
      categorySlug: categoryData['slug']?.toString() ?? 'all',
      isFeatured:
          json['isFeatured'] == true ||
          json['isFeatured'] == 1 ||
          json['isFeatured'] == 'true',
      price: parseDouble(json['price']),
      capacity: parseInt(json['capacity']),
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
      final response = await _ref
          .read(apiClientProvider)
          .dio
          .get('activities', options: Options(headers: {'Accept-Language': lang}));

      final dynamic responseData = response.data;
      List rawList = [];

      // Defensive result extraction
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map) {
        final dataField = responseData['data'];
        if (dataField is List) {
          rawList = dataField;
        }
      } else if (responseData is String) {
        try {
          final decoded = jsonDecode(responseData);
          if (decoded is List) {
            rawList = decoded;
          } else if (decoded is Map && decoded['data'] is List) {
            rawList = decoded['data'];
          }
        } catch (_) {}
      }

      return rawList
          .whereType<Map>()
          .map((e) => ActivityEvent.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Error fetching events: $e');
      }
      return [];
    }
  }

  Future<List<ActivityEvent>> getAdminEvents() async {
    try {
      final response = await _ref
          .read(apiClientProvider)
          .dio
          .get('activities/admin');

      final dynamic responseData = response.data;
      List rawList = [];
      if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      } else if (responseData is List) {
        rawList = responseData;
      }

      return rawList
          .whereType<Map>()
          .map((e) => ActivityEvent.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      if (kDebugMode) print('Error fetching admin events: $e');
      return [];
    }
  }

  Future<ActivityEvent> getEventDetails(String id) async {
    final lang = _ref.read(localeProvider).languageCode;
    final response = await _ref
        .read(apiClientProvider)
        .dio
        .get(
          'activities/detail/$id',
          options: Options(headers: {'Accept-Language': lang}),
        );

    final data = response.data;
    if (data is Map) {
      final actualData = data['data'] ?? data;
      if (actualData is Map) {
        return ActivityEvent.fromJson(Map<String, dynamic>.from(actualData));
      }
    }

    // Fallback/Error handle could go here, but using existing pattern
    return ActivityEvent.fromJson(
      Map<String, dynamic>.from(data is Map ? data : {}),
    );
  }

  // Category ID for Events (hardcoded based on DB check)
  static const String eventCategoryId = '69d97497b964b974fd6ba1f3';

  Future<void> createEvent({
    required String title,
    required String description,
    required String startDate,
    required String endDate,
    required String location,
    required bool isOnline,
    String? imageUrl,
  }) async {
    final Map<String, dynamic> data = {
      'categoryId': eventCategoryId,
      'title': {
        'ar': title.trim().isEmpty ? ' ' : title,
        'fr': title.trim().isEmpty ? ' ' : title,
        'en': title.trim().isEmpty ? ' ' : title,
      },
      'description': {
        'ar': description.trim().isEmpty ? ' ' : description,
        'fr': description.trim().isEmpty ? ' ' : description,
        'en': description.trim().isEmpty ? ' ' : description,
      },
      'startDate': startDate,
      'endDate': endDate,
      'location': {
        'formattedAddress': location,
      },
      'isOnline': isOnline,
      'publicationStatus': 'PUBLISHED',
      'eventStatus': 'UPCOMING',
    };

    if (imageUrl != null && imageUrl.isNotEmpty) {
      data['coverImage'] = {
        'url': imageUrl,
        'publicId': imageUrl.split('/').last.split('.').first,
      };
    }

    await _ref.read(apiClientProvider).dio.post('activities', data: data);
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await _ref.read(apiClientProvider).dio.patch('activities/$id', data: data);
  }

  Future<void> deleteEvent(String id) async {
    await _ref.read(apiClientProvider).dio.delete('activities/$id');
  }
}

final eventServiceProvider = Provider((ref) => EventService(ref));

final upcomingEventsProvider = FutureProvider<List<ActivityEvent>>((ref) {
  return ref.watch(eventServiceProvider).getUpcomingEvents();
});

final adminEventsProvider = FutureProvider<List<ActivityEvent>>((ref) {
  return ref.watch(eventServiceProvider).getAdminEvents();
});

final eventDetailsProvider = FutureProvider.family<ActivityEvent, String>((
  ref,
  id,
) {
  return ref.watch(eventServiceProvider).getEventDetails(id);
});
