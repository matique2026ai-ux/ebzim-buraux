import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));
  
  print('PINGING DEBUG ENDPOINT...');
  final res = await dio.get('debug/test');
  print('STATUS: ${res.statusCode}');
  print('DATA: ${res.data}');
}
