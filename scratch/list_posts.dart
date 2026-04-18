import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));

  print('--- FETCHING LAST 10 POSTS FROM SERVER ---');
  try {
    final response = await dio.get('posts');
    final data = response.data;
    List posts = [];
    if (data is List) {
      posts = data;
    } else if (data is Map && data['data'] is List) {
      posts = data['data'];
    }

    if (posts.isEmpty) {
      print('❌ NO POSTS FOUND ON SERVER');
    } else {
      print('✅ FOUND ${posts.length} POSTS:');
      for (var p in posts.take(10)) {
        print('ID: ${p['_id']} | Title: ${p['title']?['ar']} | Category: ${p['category']} | Status: ${p['projectStatus']}');
      }
    }
  } catch (e) {
    print('❌ ERROR: $e');
  }
}
