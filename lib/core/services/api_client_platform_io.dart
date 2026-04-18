import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// IO-specific implementation of platform helpers for [ApiClient].
bool get isPlatformTest => Platform.environment.containsKey('FLUTTER_TEST');

void configurePlatformProxy(Dio dio) {
  final adapter = dio.httpClientAdapter;
  if (adapter is IOHttpClientAdapter) {
    adapter.createHttpClient = () {
      final client = HttpClient();
      // Bypass SSL Certificate verification for production stability on older Android devices
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      
      client.findProxy = (uri) {
        // Force DIRECT connection to avoid issues with local network proxies
        return 'DIRECT';
      };
      
      client.connectionTimeout = const Duration(seconds: 30);
      return client;
    };
  }
}

String getPlatformBaseUrl(bool isTest) {
  // Use the production Render URL for all platforms
  return 'https://ebzim-api.onrender.com/api/v1/';
}
