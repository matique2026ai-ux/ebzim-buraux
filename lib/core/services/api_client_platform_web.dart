import 'package:dio/dio.dart';

void configurePlatformProxy(Dio dio) {
  // No-op for web platform as CORS is handled by the browser
}

bool get isPlatformTest => false;

String getPlatformBaseUrl(bool isTest) {
  // Use the production Render URL for consistency with mobile
  return 'https://ebzim-api-prod.onrender.com/api/v1/';
}
