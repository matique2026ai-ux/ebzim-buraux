import 'package:dio/dio.dart';
import 'dart:html' as html;

/// Web-specific implementation of platform helpers for [ApiClient].
bool get isPlatformTest => false;

void configurePlatformProxy(Dio dio) {
  // Browser handles proxies automatically.
}

String getPlatformBaseUrl(bool isTest) {
  final hostname = html.window.location.hostname;
  if (hostname == 'localhost' || hostname == '127.0.0.1') {
    return 'http://localhost:3000/api/v1/';
  }
  return 'https://ebzim-api.onrender.com/api/v1/';
}
