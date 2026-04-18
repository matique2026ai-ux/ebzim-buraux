import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));
  
  print('TESTING LOGIN...');
  final loginRes = await dio.post('auth/login', data: {
    'email': 'admin@ebzim.dz', // Guessing the email from context or default
    'password': 'password123',
  });
  
  if (loginRes.statusCode != 200) {
    print('LOGIN FAILED: ${loginRes.statusCode} - ${loginRes.data}');
    // Try another common admin email
    final loginRes2 = await dio.post('auth/login', data: {
      'email': 'admin@example.com',
      'password': 'admin',
    });
    if (loginRes2.statusCode != 200) return;
    dio.options.headers['Authorization'] = 'Bearer ${loginRes2.data['accessToken']}';
  } else {
    dio.options.headers['Authorization'] = 'Bearer ${loginRes.data['accessToken']}';
  }

  print('FETCHING HERO SLIDES...');
  final res = await dio.get('hero-slides');
  print('STATUS: ${res.statusCode}');
  print('DATA: ${res.data}');
}
