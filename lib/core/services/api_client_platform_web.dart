import 'package:dio/dio.dart';
import 'dart:html' as html;

/// Web-specific implementation of platform helpers for [ApiClient].
bool get isPlatformTest => false;

void configurePlatformProxy(Dio dio) {
  // Browser handles proxies automatically.
}

String getPlatformBaseUrl(bool isTest) {
  // For local testing, we use the local backend
  return 'http://localhost:3000/api/v1/';
}
