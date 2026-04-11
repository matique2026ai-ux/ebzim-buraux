import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:ebzim_app/core/services/storage_service.dart';
import 'package:flutter/foundation.dart';

final mediaServiceProvider = Provider<MediaService>((ref) {
  final dioOptions = BaseOptions(
    baseUrl: 'https://ebzim-api-preview.loca.lt/api/v1',
  );
  final dio = Dio(dioOptions);
  dio.options.headers['Bypass-Tunnel-Reminder'] = 'true';

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await ref.read(storageServiceProvider).getToken();
      options.headers['Authorization'] = 'Bearer $token';
      return handler.next(options);
    },
  ));

  return MediaService(dio);
});

class MediaService {
  final Dio _dio;

  MediaService(this._dio);

  Future<String> uploadMedia(Uint8List fileBytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await _dio.post('/media/upload', data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data['url'] as String; // Cloudinary URL returned
      } else {
        throw Exception('Failed to upload media');
      }
    } catch (e) {
      throw Exception('Exception uploading media: $e');
    }
  }
}
