import 'package:dio/dio.dart';

/// Web-specific implementation of platform helpers for [ApiClient].
bool get isPlatformTest => false;

void configurePlatformProxy(Dio dio) {
  // Browser handles proxies automatically.
  // No-op for Web, as we don't use IOHttpClientAdapter.
}

String getPlatformBaseUrl(bool isTest) {
  // Use the production Render URL for all platforms to stay in sync
  return 'https://ebzim-api.onrender.com/api/v1/';
}
