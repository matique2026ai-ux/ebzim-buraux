import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ebzim-api-prod.onrender.com/api/v1/',
    validateStatus: (status) => true,
  ));
  
  print('--- VERIFYING NEW PRODUCTION SERVER ---');
  final epList = ['posts', 'events', 'hero-slides', 'partners', 'leadership'];
  
  for (var ep in epList) {
    try {
      final res = await dio.get(ep);
      print('GET $ep -> STATUS: ${res.statusCode}');
      if (res.statusCode == 200) {
        print('   ✅ SUCCESS');
      } else {
        print('   ❌ FAILED (Status: ${res.statusCode})');
      }
    } catch (e) {
      print('   ⚠️ ERROR: $e');
    }
  }
}
