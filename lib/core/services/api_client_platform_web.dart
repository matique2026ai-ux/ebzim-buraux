import 'package:dio/dio.dart';

/// Web-specific implementation of platform helpers for [ApiClient].
bool get isPlatformTest => false;

void configurePlatformProxy(Dio dio) {
  // Browser handles proxies automatically.
  // No-op for Web, as we don't use IOHttpClientAdapter.
}

String getPlatformBaseUrl(bool isTest) {
  // Use localhost for immediate testing if production is still deploying
  // return 'https://ebzim-api.onrender.com/api/v1/'; 
  return 'http://localhost:3000/api/v1/';
}
