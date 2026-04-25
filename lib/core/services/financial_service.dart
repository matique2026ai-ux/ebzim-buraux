import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';

class FinancialService {
  final ApiClient _apiClient;

  FinancialService(this._apiClient);

  /// Fetches global system settings (including membership fee)
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await _apiClient.dio.get('settings');
      return response.data;
    } catch (e) {
      // Default fallback
      return {'annualMembershipFee': 2000, 'currency': 'DZD'};
    }
  }

  /// Admin updates the annual membership fee
  Future<void> updateMembershipFee(int newFee) async {
    try {
      await _apiClient.dio.patch(
        'settings/membership-fee',
        data: {'fee': newFee},
      );
    } catch (e) {
      throw 'Failed to update fee';
    }
  }

  /// Submits a contribution (membership or donation)
  Future<void> submitContribution({
    required String type,
    required double amount,
    String currency = 'DZD',
    String? projectId,
    String? proofUrl,
    String? notes,
  }) async {
    try {
      await _apiClient.dio.post(
        'contributions',
        data: {
          'type': type,
          'amount': amount,
          'currency': currency,
          'projectId': projectId,
          'proofUrl': proofUrl,
          'notes': notes,
        },
      );
    } on DioException catch (e) {
      throw e.response?.data?['message'] ?? 'Failed to submit contribution';
    }
  }

  /// Fetches user's contribution history
  Future<List<dynamic>> getMyContributions() async {
    try {
      final response = await _apiClient.dio.get('contributions/my');
      return response.data ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Admin fetches all global contributions
  Future<List<dynamic>> getAllContributions() async {
    try {
      final response = await _apiClient.dio.get('contributions/admin');
      return response.data ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Admin verifies or rejects a contribution
  Future<void> reviewContribution(
    String id,
    String status, {
    String? notes,
  }) async {
    try {
      await _apiClient.dio.patch(
        'contributions/$id/verify',
        data: {'status': status, 'notes': notes},
      );
    } catch (e) {
      throw 'Failed to review contribution';
    }
  }
}

final financialServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FinancialService(apiClient);
});

final adminContributionsProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.watch(financialServiceProvider).getAllContributions();
});
