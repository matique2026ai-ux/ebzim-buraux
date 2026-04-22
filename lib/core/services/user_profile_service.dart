import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/media_service.dart';

import 'package:ebzim_app/core/models/user_profile.dart';
export 'package:ebzim_app/core/models/user_profile.dart';

/// Service class for fetching user profile from backend
class UserProfileService {
  final ApiClient _apiClient;
  UserProfileService(this._apiClient);

  Future<UserProfile> fetchUserProfile() async {
    final response = await _apiClient.dio.get('auth/me');
    return UserProfile.fromJson(response.data);
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> profileData) async {
    // Backend expects 'profile' object with firstName, lastName, phone, etc.
    final response = await _apiClient.dio.patch('users/profile', data: {
      'profile': profileData,
    });
    return UserProfile.fromJson(response.data);
  }

  Future<UserProfile> uploadAvatar(List<int> bytes, String fileName, Ref ref) async {
    // 1. Upload the image to the media service
    final imageUrl = await ref.read(mediaServiceProvider).uploadMedia(
      Uint8List.fromList(bytes),
      fileName,
    );

    // 2. Update the user's imageUrl in their profile
    final response = await _apiClient.dio.patch('users/profile', data: {
      'profile': {
        'imageUrl': imageUrl,
      },
    });
    return UserProfile.fromJson(response.data);
  }
}

/// Provider for UserProfileService
final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService(ref.read(apiClientProvider));
});

/// Provider that reads from auth state (no extra API call needed)
final currentUserProvider = Provider<AsyncValue<UserProfile?>>((ref) {
  final authState = ref.watch(authProvider);

  if (authState.isInitializing || authState.isLoading) {
    return const AsyncValue.loading();
  }

  if (authState.user != null) {
    return AsyncValue.data(authState.user!);
  }

  // Return data(null) instead of error to allow screens to handle guest state gracefully
  return const AsyncValue.data(null);
});
