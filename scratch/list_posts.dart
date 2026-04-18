import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api-prod.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  print('--- FETCHING WITH CACHE BUSTER ($timestamp) ---');
  try {
    final response = await dio.get('posts?t=$timestamp&limit=50');
    final data = response.data;
    List posts = data['data'] ?? [];

    for (var p in posts) {
      print('ID: ${p['_id']} | Title: ${p['title']?['ar']} | Category: ${p['category']} | Metadata: ${p['metadata']}');
    }
  } catch (e) {
    print('❌ ERROR: $e');
  }
}
