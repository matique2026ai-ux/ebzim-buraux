import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(validateStatus: (s) => true));
  final res = await dio.get('https://ebzim-api.onrender.com/api/v1/hero-slides/admin');
  print('HERO ADMIN STATUS: ${res.statusCode}');
}
