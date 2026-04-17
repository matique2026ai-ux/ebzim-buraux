import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';

class ReportService {
  final ApiClient _apiClient;

  ReportService(this._apiClient);

  /// Submits a new civic report to the backend.
  /// Categorizes as VANDALISM, THEFT, ILLEGAL_CONSTRUCTION, NEGLECT, PUBLIC_SPACE, or OTHER.
  Future<Map<String, dynamic>> submitReport({
    required String category,
    required String location,
    required String description,
    bool isAnonymous = false,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/reports',
        data: {
          'title': '${category.toUpperCase()} Report',
          'incidentCategory': category.toUpperCase(),
          'description': description,
          'locationData': {
            'formattedAddress': location,
          },
          'isAnonymous': isAnonymous,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data?['message'] ?? 'Failed to submit report';
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  /// Lists reports for the current user (if they are authority/admin).
  Future<List<dynamic>> getReports({int page = 1}) async {
    try {
      final response = await _apiClient.dio.get('/reports', queryParameters: {'page': page});
      return response.data['data'] ?? [];
    } catch (e) {
      return [];
    }
  }

  /// Updates the status of a civic report (Admin Only).
  /// Statuses: PENDING, INVESTIGATING, RESOLVED, REJECTED.
  Future<void> updateReportStatus(String id, String status, {String? adminComment}) async {
    try {
      await _apiClient.dio.patch(
        '/reports/$id/status',
        data: {
          'status': status,
          if (adminComment != null) 'adminComment': adminComment,
        },
      );
    } on DioException catch (e) {
      throw e.response?.data?['message'] ?? 'Failed to update report status';
    }
  }
}

final reportServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportService(apiClient);
});

final adminReportsProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.watch(reportServiceProvider).getReports();
});
