import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/',
    validateStatus: (status) => true,
  ));
  
  final res = await dio.get('api/docs-json');
  if (res.statusCode == 200) {
    final paths = (res.data['paths'] as Map).keys.toList();
    paths.sort();
    for (var p in paths) {
      print('ROUTE: $p');
    }
  } else {
    print('SWAGGER JSON NOT FOUND: ${res.statusCode}');
  }
}
