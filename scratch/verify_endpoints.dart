import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));
  
  final endpoints = [
    'hero-slides', 
    'cms/hero-slides',
    'partners', 
    'cms/partners',
    'leadership',
    'cms/leadership',
    'posts', 
    'events',
    'auth/login'
  ];
  
  print('--- VERIFYING ENDPOINTS ---');
  for (var endpoint in endpoints) {
    try {
      final response = await dio.get(endpoint);
      print('ENDPOINT: $endpoint -> STATUS: ${response.statusCode}');
    } catch (e) {
      print('ENDPOINT: $endpoint -> ERROR: $e');
    }
  }
}
