import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

final mediaServiceProvider = Provider<MediaService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MediaService(apiClient.dio);
});

class MediaService {
  final Dio _dio;

  MediaService(this._dio);

  Future<String> uploadMedia(Uint8List fileBytes, String fileName, {String? filePath}) async {
    try {
      print('[MEDIA] Starting upload for $fileName (Path: $filePath, Bytes: ${fileBytes.length})');
      
      List<int> finalBytes = List<int>.from(fileBytes);
      
      // If bytes are empty/null and we have a path (Android case), read from storage
      if ((finalBytes.isEmpty) && filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          finalBytes = await file.readAsBytes();
          print('[MEDIA] Read ${finalBytes.length} bytes from path');
        } else {
          print('[MEDIA] ERROR: File does not exist at path: $filePath');
        }
      }

      if (finalBytes.isEmpty) {
        throw Exception('Cannot upload empty file. Try picking the image again.');
      }

      String mimeType = 'image';
      String subType = 'jpeg';
      final lowerName = fileName.toLowerCase();
      if (lowerName.endsWith('.png')) subType = 'png';
      else if (lowerName.endsWith('.mp4')) { mimeType = 'video'; subType = 'mp4'; }
      else if (lowerName.endsWith('.webp')) subType = 'webp';
      else if (lowerName.endsWith('.gif')) subType = 'gif';

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          finalBytes, 
          filename: fileName,
          contentType: MediaType(mimeType, subType),
        ),
      });

      print('[MEDIA] Sending POST to media/upload...');
      final response = await _dio.post(
        'media/upload', 
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final url = response.data['url'] as String;
        print('[MEDIA] Upload Success: $url');
        return url;
      } else {
        throw Exception('Failed to upload media (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      print('[MEDIA] Dio Error: ${e.message}');
      print('[MEDIA] Response Data: ${e.response?.data}');
      throw Exception('Server Media Error: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('[MEDIA] Unknown Error: $e');
      throw Exception('Exception uploading media: $e');
    }
  }
}
