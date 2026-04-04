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
  // On Android emulators, localhost is 10.0.2.2
  const androidBaseUrl = 'http://10.0.2.2:3000/api/v1/';
  const localBaseUrl = 'http://localhost:3000/api/v1/';
  
  if (defaultTargetPlatform == TargetPlatform.android && !isTest) {
    return androidBaseUrl;
  }
  return localBaseUrl;
}
