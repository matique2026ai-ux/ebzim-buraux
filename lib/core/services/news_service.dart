import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

/// Represents a single news post / announcement from the association.
class NewsPost {
  final String id;
  final String titleAr;
  final String titleFr;
  final String titleEn;
  final String summaryAr;
  final String summaryFr;
  final String summaryEn;
  final String bodyAr;
  final String bodyFr;
  final String bodyEn;
  final String imageUrl;
  final DateTime publishedAt;
  final String category; // 'ANNOUNCEMENT' | 'PARTNERSHIP' | 'EVENT_REPORT' | 'GENERAL'
  final String? partnerName; // e.g. "المتحف الوطني للآثار" or "جامعة سطيف"
  final bool isPinned;

  NewsPost({
    required this.id,
    required this.titleAr,
    required this.titleFr,
    required this.titleEn,
    required this.summaryAr,
    required this.summaryFr,
    required this.summaryEn,
    required this.bodyAr,
    required this.bodyFr,
    required this.bodyEn,
    required this.imageUrl,
    required this.publishedAt,
    required this.category,
    this.partnerName,
    this.isPinned = false,
  });

  String getTitle(String lang) {
    if (lang == 'ar') return titleAr;
    if (lang == 'fr') return titleFr;
    return titleEn;
  }

  String getSummary(String lang) {
    if (lang == 'ar') return summaryAr;
    if (lang == 'fr') return summaryFr;
    return summaryEn;
  }

  String getBody(String lang) {
    if (lang == 'ar') return bodyAr;
    if (lang == 'fr') return bodyFr;
    return bodyEn;
  }

  factory NewsPost.fromJson(Map<String, dynamic> json) {
    final title = json['title'] is Map ? json['title'] : {};
    final summary = json['summary'] is Map ? json['summary'] : {};
    final body = json['body'] is Map ? json['body'] : {};
    return NewsPost(
      id: json['_id']?.toString() ?? '',
      titleAr: title['ar']?.toString() ?? '',
      titleFr: title['fr']?.toString() ?? '',
      titleEn: title['en']?.toString() ?? '',
      summaryAr: summary['ar']?.toString() ?? '',
      summaryFr: summary['fr']?.toString() ?? '',
      summaryEn: summary['en']?.toString() ?? '',
      bodyAr: body['ar']?.toString() ?? '',
      bodyFr: body['fr']?.toString() ?? '',
      bodyEn: body['en']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt']?.toString() ?? '') ?? DateTime.now(),
      category: json['category']?.toString() ?? 'GENERAL',
      partnerName: json['partnerName']?.toString(),
      isPinned: json['isPinned'] == true,
    );
  }
}

class NewsService {
  final Ref _ref;
  NewsService(this._ref);

  Future<List<NewsPost>> getNews() async {
    try {
      final lang = _ref.read(localeProvider).languageCode;
      final response = await _ref.read(apiClientProvider).dio.get(
        '/news',
        queryParameters: {'lang': lang},
      );
      final data = response.data;
      List rawList = [];
      if (data is List) {
        rawList = data;
      } else if (data is Map && data['data'] is List) {
        rawList = data['data'];
      }

      return rawList
          .whereType<Map>()
          .map((e) => NewsPost.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<NewsPost>> getAdminNews() async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('/posts/admin');
      final data = response.data;
      List rawList = [];
      if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else if (data is List) {
        rawList = data;
      }
      return rawList
          .whereType<Map>()
          .map((e) => NewsPost.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // _localFallbackNews removed to fix unused element warning
}

final newsServiceProvider = Provider((ref) => NewsService(ref));

final newsProvider = FutureProvider<List<NewsPost>>((ref) {
  return ref.watch(newsServiceProvider).getNews();
});

final adminNewsProvider = FutureProvider<List<NewsPost>>((ref) {
  return ref.watch(newsServiceProvider).getAdminNews();
});
