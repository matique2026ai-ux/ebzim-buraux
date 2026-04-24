import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/storage_service.dart';
import 'package:ebzim_app/core/services/api_client_platform.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:file_picker/file_picker.dart';

class ApiClient {
  final Dio dio;
  final StorageService storageService;
  final Ref _ref;

  ApiClient({required this.dio, required this.storageService, required Ref ref}) : _ref = ref {
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
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            // If unauthorized or forbidden, clear token and trigger global logout
            _ref.read(storageServiceProvider).deleteToken();
            _ref.read(authProvider.notifier).logout();
          }
          return handler.next(e);
        },
      ),
    );
    
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
  }

  /// Platform-agnostic file picker helper
  Future<PlatformFile?> pickFile() async {
    try {
      // Using the working static method found in the project's codebase
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        withData: true,
      );
      return result?.files.first;
    } catch (e) {
      if (kDebugMode) {
        print('[FILE PICKER ERROR] $e');
      }
      return null;
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

  return ApiClient(dio: dio, storageService: storageService, ref: ref);
});
