import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/models/publication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:http_parser/http_parser.dart';

class PublicationService {
  final ApiClient _api;
  PublicationService(this._api);

  Future<List<Publication>> getPublications() async {
    try {
      final response = await _api.dio.get('publications');
      if (response.data is List) {
        return (response.data as List)
            .map((json) => Publication.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      return []; 
    }
  }

  Future<Publication?> getPublication(String id) async {
    try {
      final response = await _api.dio.get('publications/$id');
      return Publication.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> createPublication(Map<String, dynamic> data) async {
    try {
      await _api.dio.post('publications', data: data);
      return true;
    } on DioException catch (e) {
      print('CreatePublication DioError: ${e.message}');
      print('Response Data: ${e.response?.data}');
      return false;
    } catch (e) {
      print('CreatePublication Error: $e');
      return false;
    }
  }

  Future<bool> updatePublication(String id, Map<String, dynamic> data) async {
    try {
      await _api.dio.patch('publications/$id', data: data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePublication(String id) async {
    try {
      await _api.dio.delete('publications/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadFile(List<int> bytes, String filename) async {
    try {
      String mimeType = 'image';
      String subType = 'jpeg';
      final lowerName = filename.toLowerCase();
      if (lowerName.endsWith('.png')) subType = 'png';
      else if (lowerName.endsWith('.webp')) subType = 'webp';
      else if (lowerName.endsWith('.gif')) subType = 'gif';
      else if (lowerName.endsWith('.pdf')) { mimeType = 'application'; subType = 'pdf'; }

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes, 
          filename: filename,
          contentType: MediaType(mimeType, subType),
        ),
      });
      final response = await _api.dio.post('media/upload', data: formData);
      return response.data['url'] as String;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception('فشل في الرفع: $msg');
    } catch (e) {
      throw Exception('فشل في الرفع: $e');
    }
  }
}

final publicationServiceProvider = Provider((ref) {
  final api = ref.watch(apiClientProvider);
  return PublicationService(api);
});

// FutureProvider for easy consumption in UI
final allPublicationsProvider = FutureProvider<List<Publication>>((ref) {
  return ref.watch(publicationServiceProvider).getPublications();
});
