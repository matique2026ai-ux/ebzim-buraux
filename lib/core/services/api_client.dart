import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/storage_service.dart';
import 'package:ebzim_app/core/services/api_client_platform.dart';


class ApiClient {
  final Dio dio;
  final StorageService storageService;

  ApiClient({required this.dio, required this.storageService}) {
    _initInterceptors();
    _initProxy();
  }

  void _initProxy() {
    // Delegates to the platform-specific implementation.
    configurePlatformProxy(dio);
  }

  void _initInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          if (options.method != 'GET' && options.method != 'HEAD') {
            options.contentType = 'application/json';
          }
          
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            storageService.deleteToken();
          }
          return handler.next(e);
        },
      ),
    );
    
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
  }
}

final apiClientProvider = Provider((ref) {
  final storageService = ref.watch(storageServiceProvider);
  
  // Use the platform-safe helper to detect tests and base URLs.
  final isTest = isPlatformTest;
  final baseUrl = getPlatformBaseUrl(isTest);
  if (kDebugMode) {
    print('[DEBUG API] Initializing ApiClient with baseUrl: $baseUrl');
  }

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  return ApiClient(dio: dio, storageService: storageService);
});

