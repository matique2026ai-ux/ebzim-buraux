import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:ebzim_app/core/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:ebzim_app/core/services/api_client_platform.dart';
import 'package:http_parser/http_parser.dart';

final mediaServiceProvider = Provider<MediaService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MediaService(apiClient.dio);
});

class MediaService {
  final Dio _dio;

  MediaService(this._dio);

  Future<String> uploadMedia(Uint8List fileBytes, String fileName) async {
    try {
      String mimeType = 'image';
      String subType = 'jpeg';
      final lowerName = fileName.toLowerCase();
      if (lowerName.endsWith('.png')) subType = 'png';
      else if (lowerName.endsWith('.mp4')) { mimeType = 'video'; subType = 'mp4'; }
      else if (lowerName.endsWith('.webp')) subType = 'webp';
      else if (lowerName.endsWith('.gif')) subType = 'gif';

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes, 
          filename: fileName,
          contentType: MediaType(mimeType, subType),
        ),
      });

      final response = await _dio.post('media/upload', data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data['url'] as String; // Cloudinary URL returned
      } else {
        throw Exception('Failed to upload media');
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      throw Exception('Server Error: $errorData');
    } catch (e) {
      throw Exception('Exception uploading media: $e');
    }
  }
}
