import 'package:dio/dio.dart';
import 'dart:convert';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/',
    validateStatus: (status) => true,
  ));
  
  final res = await dio.get('api/docs-json');
  if (res.statusCode == 200) {
    print(jsonEncode(res.data));
  } else {
    print('FAILED: ${res.statusCode}');
  }
}
