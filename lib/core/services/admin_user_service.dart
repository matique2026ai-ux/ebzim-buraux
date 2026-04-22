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
      final dynamic responseData = response.data;
      List rawList = [];
      
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      }
      
      final users = rawList.map((json) => UserProfile.fromJson(Map<String, dynamic>.from(json))).toList();
      
      // Defect Fix: Ensure only matique2025@gmail.com is the المشرف العام (Super Admin) 
      // if multiple Super Admins exist, as requested by the owner.
      final primaryEmail = 'matique2025@gmail.com';
      final hasPrimary = users.any((u) => u.email.toLowerCase() == primaryEmail);
      
      if (hasPrimary) {
        return users.map((u) {
          if (u.role == EbzimRole.superAdmin && u.email.toLowerCase() != primaryEmail) {
            // Demote system admin or others to ADMIN role to resolve the "Defect" of multiple supervisors
            return u.copyWith(role: EbzimRole.admin);
          }
          return u;
        }).toList();
      }
      
      return users;
    } catch (e) {
      // ignore: avoid_print
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
