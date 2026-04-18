import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final res = await dio.get('https://ebzim-api.onrender.com/');
  print('ROOT RESPONSE: ${res.data}');
}
