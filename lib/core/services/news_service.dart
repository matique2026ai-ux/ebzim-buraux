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
      final List data = response.data;
      return data.map((e) => NewsPost.fromJson(e)).toList();
    } catch (e) {
      print('DEBUG: NewsService error: $e');
      return [];
    }
  }

  Future<List<NewsPost>> getAdminNews() async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('posts');
      final List data = response.data;
      // In admin we might want to see all posts including drafts if the backend supports it
      return data.map((e) => NewsPost.fromJson(e)).toList();
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
        'fr': titleFr ?? '',
        'en': titleEn ?? '',
      },
      'summary': {
        'ar': summary,
        'fr': summaryFr ?? '',
        'en': summaryEn ?? '',
      },
      'content': {
        'ar': content,
        'fr': contentFr ?? '',
        'en': contentEn ?? '',
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

    print('DEBUG: Sending createPost data: $data');

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
