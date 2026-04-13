import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// IO-specific implementation of platform helpers for [ApiClient].
bool get isPlatformTest => Platform.environment.containsKey('FLUTTER_TEST');

void configurePlatformProxy(Dio dio) {
  final adapter = dio.httpClientAdapter;
  // Use IOHttpClientAdapter from dio/io.dart
  if (adapter is IOHttpClientAdapter) {
    adapter.createHttpClient = () {
      final client = HttpClient();
      client.findProxy = (uri) {
        if (uri.host == 'localhost' || uri.host == '127.0.0.1' || uri.host == '10.0.2.2') {
          return 'DIRECT';
        }
        return HttpClient.findProxyFromEnvironment(uri);
      };
      return client;
    };
  }
}

String getPlatformBaseUrl(bool isTest) {
  // Use the production Render URL for all platforms
  return 'https://ebzim-api.onrender.com/api/v1/';
}
