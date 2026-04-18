import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));
  
  print('--- VERIFYING LIVE API STATUS ---');
  
  // Test POST for Auth
  try {
    final authRes = await dio.post('auth/login', data: {'email': 'test@test.com', 'password': 'test'});
    print('AUTH LOGIN (POST): Status ${authRes.statusCode} (401/400 is GOOD, 404 is BAD)');
  } catch (e) {
    print('AUTH LOGIN ERROR: $e');
  }

  final getEndpoints = ['posts', 'events', 'hero-slides', 'partners', 'leadership'];
  for (var ep in getEndpoints) {
    try {
      final res = await dio.get(ep);
      print('GET $ep: Status ${res.statusCode}');
    } catch (e) {
      print('GET $ep ERROR: $e');
    }
  }
}
