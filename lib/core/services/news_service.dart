import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/models/news_post.dart';
export 'package:ebzim_app/core/models/news_post.dart';

class NewsService {
  final Ref _ref;

  NewsService(this._ref);

  Future<List<NewsPost>> getNews() async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('posts');
      final dynamic responseData = response.data;
      List rawList = [];
      
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      }
      
      return rawList.map((e) => NewsPost.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) print('DEBUG: NewsService error: $e');
      return [];
    }
  }

  Future<List<NewsPost>> getAdminNews() async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('posts');
      final dynamic responseData = response.data;
      List rawList = [];
      
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      }
      
      return rawList.map((e) => NewsPost.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<NewsPost?> getPost(String id) async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('posts/$id');
      return NewsPost.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  // Category ID for News (hardcoded based on DB check)
  static const String newsCategoryId = '69d97497b964b974fd6ba1f2';

  Future<void> createPost({
    required String title,
    String? titleFr,
    String? titleEn,
    required String summary,
    String? summaryFr,
    String? summaryEn,
    required String content,
    String? contentFr,
    String? contentEn,
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
        'ar': (category != 'ANNOUNCEMENT' && !title.startsWith('[PROJ]')) ? '[PROJ]$title' : title,
        'fr': (titleFr != null && titleFr.isNotEmpty) ? titleFr : title,
        'en': (titleEn != null && titleEn.isNotEmpty) ? titleEn : title,
      },
      'summary': {
        'ar': summary,
        'fr': (summaryFr != null && summaryFr.isNotEmpty) ? summaryFr : summary,
        'en': (summaryEn != null && summaryEn.isNotEmpty) ? summaryEn : summary,
      },
      'content': {
        'ar': content,
        'fr': (contentFr != null && contentFr.isNotEmpty) ? contentFr : content,
        'en': (contentEn != null && contentEn.isNotEmpty) ? contentEn : content,
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

    if (kDebugMode) print('DEBUG: Sending createPost data: $data');

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
  const projectCategories = {
    'HERITAGE', 
    'PROJECT', 
    'RESTORATION', 
    'SCIENTIFIC', 
    'CULTURAL', 
    'ARTISTIC',
    'MEMORY',
    'TOURISM',
    'CHILD',
    'PARTNERSHIP',
    'EVENT_REPORT'
  };
  return news.where((p) => projectCategories.contains(p.category.toUpperCase())).toList();
});

final postDetailsProvider = FutureProvider.family<NewsPost?, String>((ref, id) {
  return ref.watch(newsServiceProvider).getPost(id);
});
