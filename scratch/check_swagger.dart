import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/',
    validateStatus: (status) => true,
  ));
  
  try {
    // Usually NestJS swagger is at /api/docs-json or similar if configured
    // Let's try to find it
    final response = await dio.get('api/docs-json'); // Try common path
    if (response.statusCode == 200) {
      print('SWAGGER FOUND!');
      final paths = (response.data['paths'] as Map).keys.toList();
      print('PATHS:');
      for (var path in paths) {
        print(path);
      }
    } else {
      print('SWAGGER NOT FOUND (Status: ${response.statusCode})');
    }
  } catch (e) {
    print('ERROR: $e');
  }
}
