import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(validateStatus: (s) => true));
  final res = await dio.get('https://ebzim-api.onrender.com/api/v1/posts/admin');
  print('ADMIN POSTS STATUS: ${res.statusCode}');
}
