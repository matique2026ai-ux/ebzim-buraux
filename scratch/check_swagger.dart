import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/',
    validateStatus: (status) => true,
  ));
  
  final paths = [
    'api',
    'api/docs',
    'api-docs',
    'swagger',
    'api/v1/docs',
    'docs'
  ];
  
  print('--- SEARCHING FOR SWAGGER/API INFO ---');
  for (var path in paths) {
    try {
      final response = await dio.get(path);
      print('PATH: $path -> STATUS: ${response.statusCode}');
      if (response.statusCode == 200 && response.data.toString().contains('swagger')) {
        print('SWAGGER LIKELY AT: $path');
      }
    } catch (e) {
      print('PATH: $path -> ERROR: $e');
    }
  }
}
