import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final String category;
  final String? partnerName;
  final bool isPinned;
  final double progressPercentage; // 0.0 to 1.0
  final List<ProjectMilestone> milestones;
  final String projectStatus;

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
    this.progressPercentage = 0.0,
    this.milestones = const [],
    this.projectStatus = 'GENERAL',
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
    final content = json['content'] is Map ? json['content'] : {};
    
    // Get image from media array or fallback to imageUrl
    String img = json['imageUrl']?.toString() ?? '';
    if (img.isEmpty && json['media'] is List && (json['media'] as List).isNotEmpty) {
      final firstMedia = (json['media'] as List).first;
      img = firstMedia['cloudinaryUrl']?.toString() ?? '';
    }

    // Parse metadata for project-specific fields
    final metadata = json['metadata'] is Map ? json['metadata'] : {};
    final progress = (metadata['progressPercentage'] != null) 
        ? double.tryParse(metadata['progressPercentage'].toString()) ?? 0.0 
        : 0.0;
    
    final milestonesList = (metadata['milestones'] is List)
        ? (metadata['milestones'] as List)
            .map((m) => ProjectMilestone.fromJson(Map<String, dynamic>.from(m)))
            .toList()
        : <ProjectMilestone>[];

    // Fallback: Read category and status from metadata if top-level fields are missing/null
    final categoryStr = json['category']?.toString() ?? metadata['category']?.toString() ?? 'ANNOUNCEMENT';
    final pStatus = json['projectStatus']?.toString() ?? metadata['projectStatus']?.toString() ?? 'GENERAL';

    return NewsPost(
      id: json['_id']?.toString() ?? '',
      titleAr: title['ar']?.toString() ?? '',
      titleFr: title['fr']?.toString() ?? '',
      titleEn: title['en']?.toString() ?? '',
      summaryAr: summary['ar']?.toString() ?? '',
      summaryFr: summary['fr']?.toString() ?? '',
      summaryEn: summary['en']?.toString() ?? '',
      bodyAr: content['ar']?.toString() ?? '',
      bodyFr: content['fr']?.toString() ?? '',
      bodyEn: content['en']?.toString() ?? '',
      imageUrl: img,
      publishedAt: DateTime.tryParse(json['publishedAt']?.toString() ?? json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      category: categoryStr,
      projectStatus: pStatus,
      partnerName: metadata['partnerName']?.toString() ?? json['partnerName']?.toString(),
      isPinned: json['isPinned'] == true,
      progressPercentage: progress,
      milestones: milestonesList,
    );
  }
}

class ProjectMilestone {
  final String labelAr;
  final String labelFr;
  final DateTime date;
  final bool isCompleted;

  ProjectMilestone({
    required this.labelAr,
    required this.labelFr,
    required this.date,
    this.isCompleted = false,
  });

  String getLabel(String lang) => lang == 'ar' ? labelAr : labelFr;

  factory ProjectMilestone.fromJson(Map<String, dynamic> json) {
    return ProjectMilestone(
      labelAr: json['labelAr']?.toString() ?? '',
      labelFr: json['labelFr']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      isCompleted: json['isCompleted'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'labelAr': labelAr,
    'labelFr': labelFr,
    'date': date.toIso8601String(),
    'isCompleted': isCompleted,
  };
}

class NewsService {
  final Ref _ref;
  NewsService(this._ref);

  Future<List<NewsPost>> getNews() async {
    try {
      final lang = _ref.read(localeProvider).languageCode;
      final response = await _ref.read(apiClientProvider).dio.get(
        'posts',
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
      final response = await _ref.read(apiClientProvider).dio.get('posts/admin');
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

  Future<NewsPost?> getPost(String id) async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('posts/$id');
      final data = response.data;
      if (data != null && (data is Map || data['data'] is Map)) {
        final postData = data['data'] ?? data;
        return NewsPost.fromJson(Map<String, dynamic>.from(postData));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // Category ID for News (hardcoded based on DB check)
  static const String newsCategoryId = '69d97497b964b974fd6ba1f2';

  Future<void> createPost({
    required String title,
    required String summary,
    required String content,
    String? imageUrl,
    bool isPinned = false,
    String category = 'ANNOUNCEMENT',
    String projectStatus = 'GENERAL',
    Map<String, dynamic>? metadata,
  }) async {
    final Map<String, dynamic> data = {
      'categoryId': newsCategoryId,
      'category': category,
      'projectStatus': projectStatus,
      'title': {
        'ar': title,
        'fr': title,
        'en': title,
      },
      'summary': {
        'ar': summary,
        'fr': summary,
        'en': summary,
      },
      'content': {
        'ar': content,
        'fr': content,
        'en': content,
      },
      'status': 'PUBLISHED',
      'isPinned': isPinned,
      'isFeatured': false,
      'metadata': {
        ...?metadata,
        'category': category, // Fallback for stale backend
        'projectStatus': projectStatus, // Fallback for stale backend
      },
    };

    if (imageUrl != null && imageUrl.isNotEmpty) {
      data['media'] = [
        {
          'type': 'IMAGE',
          'cloudinaryUrl': imageUrl,
          'publicId': imageUrl.split('/').last.split('.').first,
        }
      ];
    }

    await _ref.read(apiClientProvider).dio.post('posts', data: data);
  }

  Future<void> updatePost(String id, Map<String, dynamic> data) async {
    await _ref.read(apiClientProvider).dio.patch('posts/$id', data: data);
  }

  Future<void> deletePost(String id) async {
    await _ref.read(apiClientProvider).dio.delete('posts/$id');
  }
}

final newsServiceProvider = Provider((ref) => NewsService(ref));

final newsProvider = FutureProvider<List<NewsPost>>((ref) {
  return ref.watch(newsServiceProvider).getNews();
});

final adminNewsProvider = FutureProvider<List<NewsPost>>((ref) {
  return ref.watch(newsServiceProvider).getAdminNews();
});

final heritageProjectsProvider = FutureProvider<List<NewsPost>>((ref) async {
  final news = await ref.watch(newsServiceProvider).getNews();
  const projectCategories = {'HERITAGE', 'PROJECT', 'RESTORATION', 'SCIENTIFIC', 'CULTURAL', 'ARTISTIC'};
  return news.where((p) => projectCategories.contains(p.category)).toList();
});

final postDetailsProvider = FutureProvider.family<NewsPost?, String>((ref, id) {
  return ref.watch(newsServiceProvider).getPost(id);
});
