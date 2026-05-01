import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/models/market_book.dart';
import 'package:ebzim_app/core/services/api_client.dart';

final marketplaceServiceProvider = Provider<MarketplaceService>((ref) {
  return MarketplaceService(ref.read(apiClientProvider));
});

final allMarketBooksProvider = FutureProvider<List<MarketBook>>((ref) async {
  return ref.read(marketplaceServiceProvider).getBooks();
});

class MarketplaceService {
  final ApiClient _api;

  MarketplaceService(this._api);

  Future<List<MarketBook>> getBooks({bool availableOnly = false}) async {
    try {
      final response = await _api.dio.get(
        'marketplace',
        queryParameters: {'availableOnly': availableOnly.toString()},
      );
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => MarketBook.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createBook(Map<String, dynamic> data) async {
    try {
      final response = await _api.dio.post('marketplace', data: data);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateBook(String id, Map<String, dynamic> data) async {
    try {
      final response = await _api.dio.patch('marketplace/$id', data: data);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteBook(String id) async {
    try {
      final response = await _api.dio.delete('marketplace/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
