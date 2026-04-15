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
          
          if (options.method != 'GET' && options.method != 'HEAD' && options.contentType == null) {
            options.contentType = 'application/json';
          }
          
          print('[API REQUEST] ${options.method} ${options.baseUrl}${options.path}');
          if (options.data != null) print('[API DATA] ${options.data}');
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('[API RESPONSE] ${response.statusCode} from ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('[API ERROR] ${e.response?.statusCode} for ${e.requestOptions.path}');
          print('[API ERROR DATA] ${e.response?.data}');
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
    connectTimeout: const Duration(seconds: 90),
    receiveTimeout: const Duration(seconds: 90),
  ));

  return ApiClient(dio: dio, storageService: storageService);
});

