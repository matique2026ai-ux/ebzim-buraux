import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));
  
  print('TESTING POST TO hero-slides...');
  final res = await dio.post('hero-slides', data: {
    'title': {'ar': 'Test', 'en': 'Test', 'fr': 'Test'},
    'subtitle': {'ar': 'Test', 'en': 'Test', 'fr': 'Test'},
    'imageUrl': 'https://example.com/image.jpg',
  });
  
  print('STATUS: ${res.statusCode}');
  print('DATA: ${res.data}');
}
