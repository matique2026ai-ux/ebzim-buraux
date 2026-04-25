import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';

class PublicStats {
  final int membersCount;
  final int activeEventsCount;
  final int totalPostsCount;
  final int totalUsersCount;

  PublicStats({
    required this.membersCount,
    required this.activeEventsCount,
    required this.totalPostsCount,
    required this.totalUsersCount,
  });

  factory PublicStats.fromJson(Map<String, dynamic> json) {
    return PublicStats(
      membersCount: json['membersCount'] ?? 0,
      activeEventsCount: json['activeEventsCount'] ?? 0,
      totalPostsCount: json['totalPostsCount'] ?? 0,
      totalUsersCount: json['totalUsersCount'] ?? 0,
    );
  }

  factory PublicStats.empty() {
    return PublicStats(
      membersCount: 0,
      activeEventsCount: 0,
      totalPostsCount: 0,
      totalUsersCount: 0,
    );
  }
}

class PublicStatsService {
  final Ref _ref;

  PublicStatsService(this._ref);

  Future<PublicStats> getPublicStats() async {
    try {
      final response = await _ref
          .read(apiClientProvider)
          .dio
          .get('public/stats');
      final dynamic responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          return PublicStats.fromJson(
            responseData['data'] as Map<String, dynamic>,
          );
        }
        return PublicStats.fromJson(responseData);
      }
      return PublicStats.empty();
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching public stats: $e');
      return PublicStats.empty();
    }
  }
}

final publicStatsServiceProvider = Provider((ref) => PublicStatsService(ref));

final publicStatsProvider = FutureProvider<PublicStats>((ref) {
  return ref.watch(publicStatsServiceProvider).getPublicStats();
});
