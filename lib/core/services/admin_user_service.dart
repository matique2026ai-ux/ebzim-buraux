import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';

class AdminUserService {
  final Ref _ref;

  AdminUserService(this._ref);

  Future<List<UserProfile>> getAllUsers() async {
    try {
      final response = await _ref.read(apiClientProvider).dio.get('admin/users');
      final List data = response.data;
      return data.map((json) => UserProfile.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<void> updateUserStatus(String userId, String status) async {
    await _ref.read(apiClientProvider).dio.patch(
      'admin/users/$userId/status',
      data: {'status': status},
    );
  }

  Future<void> deleteUser(String userId) async {
    await _ref.read(apiClientProvider).dio.delete('admin/users/$userId');
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _ref.read(apiClientProvider).dio.patch('admin/users/$userId', data: data);
  }
}

final adminUserServiceProvider = Provider((ref) => AdminUserService(ref));

final allUsersProvider = FutureProvider<List<UserProfile>>((ref) {
  return ref.watch(adminUserServiceProvider).getAllUsers();
});
