import 'package:dio/dio.dart';

/// Web-specific implementation of platform helpers for [ApiClient].
bool get isPlatformTest => false;

void configurePlatformProxy(Dio dio) {
  // Browser handles proxies automatically.
  // No-op for Web, as we don't use IOHttpClientAdapter.
}

String getPlatformBaseUrl(bool isTest) {
  // Use the local backend for development and admin panel verification
  return 'http://localhost:3000/api/v1/';
}
