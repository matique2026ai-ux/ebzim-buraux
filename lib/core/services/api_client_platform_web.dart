import 'package:dio/dio.dart';

void configurePlatformProxy(Dio dio) {
  // No-op for web platform as CORS is handled by the browser
}

bool get isPlatformTest => false;

String getPlatformBaseUrl(bool isTest) {
  // Local Development Environment
  return 'http://localhost:3000/api/v1/';
}
