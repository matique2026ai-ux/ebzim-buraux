import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));

  print('--- FETCHING LAST 10 POSTS WITH METADATA ---');
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
      print('❌ NO POSTS FOUND');
    } else {
      for (var p in posts.take(5)) {
        print('-------------------------------------------');
        print('ID: ${p['_id']}');
        print('Title: ${p['title']?['ar']}');
        print('Category (Top): ${p['category']}');
        print('Metadata: ${p['metadata']}');
      }
    }
  } catch (e) {
    print('❌ ERROR: $e');
  }
}
