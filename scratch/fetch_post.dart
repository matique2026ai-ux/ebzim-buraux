import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://ebzim-api.onrender.com/api/v1/', validateStatus: (s) => true));
  final res = await dio.get('posts?limit=1');
  print('POST DATA: ${res.data}');
}
