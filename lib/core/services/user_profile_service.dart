import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/media_service.dart';

class UserProfile {
  final String id;
  final String name;
  final String nameAr;
  final String email;
  final String phone;
  final String imageUrl;
  final String membershipLevel;
  final String membershipStatus;
  final DateTime? membershipExpiry;
  final int profileCompletionPercentage;
  final String? membershipBadge;
  final String status;

  UserProfile({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.membershipLevel,
    required this.membershipStatus,
    this.membershipExpiry,
    required this.profileCompletionPercentage,
    this.membershipBadge,
    this.status = 'ACTIVE',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};
    final role = json['role'] ?? json['membershipLevel'] ?? 'PUBLIC';
    final badge = json['membershipBadge'] ?? json['badge'] ?? profile['badge'] ?? 'NONE';
    
    final firstName = profile['firstName'] ?? '';
    final lastName = profile['lastName'] ?? '';
    final phone = profile['phone'] ?? '';
    final avatar = profile['avatarUrl'] ?? profile['imageUrl'] ?? '';
    
    int completion = 0;
    if (firstName.toString().isNotEmpty) completion += 25;
    if (lastName.toString().isNotEmpty) completion += 25;
    if (phone.toString().isNotEmpty) completion += 25;
    if (avatar.toString().isNotEmpty) completion += 25;

    return UserProfile(
      id: json['id'] ?? json['_id'] ?? '',
      name: '$firstName $lastName'.trim(),
      nameAr: profile['firstNameAr'] ?? firstName,
      email: json['email'] ?? '',
      phone: phone,
      imageUrl: avatar,
      membershipLevel: role,
      membershipStatus: json['status'] ?? 'ACTIVE',
      membershipExpiry: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      profileCompletionPercentage: completion,
      membershipBadge: badge,
      status: json['status'] ?? 'ACTIVE',
    );
  }

  String getName(String languageCode) {
    if (languageCode == 'ar') return nameAr;
    return name;
  }
}

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
