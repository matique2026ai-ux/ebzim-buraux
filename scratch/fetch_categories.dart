import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final res = await dio.get('https://ebzim-api.onrender.com/api/v1/categories');
  print('CATEGORIES: ${res.data}');
}
