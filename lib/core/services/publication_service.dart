import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/models/publication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicationService {
  final ApiClient _api;
  PublicationService(this._api);

  Future<List<Publication>> getPublications() async {
    try {
      final response = await _api.dio.get('/publications');
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
      final response = await _api.dio.get('/publications/$id');
      return Publication.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> createPublication(Map<String, dynamic> data) async {
    try {
      await _api.dio.post('/publications', data: data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePublication(String id, Map<String, dynamic> data) async {
    try {
      await _api.dio.patch('/publications/$id', data: data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePublication(String id) async {
    try {
      await _api.dio.delete('/publications/$id');
      return true;
    } catch (e) {
      return false;
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
