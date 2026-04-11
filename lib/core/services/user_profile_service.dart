import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/services/auth_service.dart';

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
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};
    final role = json['role'] ?? 'PUBLIC';
    
    return UserProfile(
      id: json['id'] ?? json['_id'] ?? '',
      name: '${profile['firstName'] ?? ''} ${profile['lastName'] ?? ''}'.trim(),
      nameAr: profile['firstNameAr'] ?? profile['firstName'] ?? '',
      email: json['email'] ?? '',
      phone: profile['phone'] ?? '',
      imageUrl: profile['avatarUrl'] ?? 'https://placehold.co/150/020F08/F7C04A/png?text=User',
      membershipLevel: role,
      membershipStatus: json['status'] ?? 'ACTIVE',
      membershipExpiry: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      profileCompletionPercentage: 40, // Base completion for registration
      membershipBadge: json['membershipBadge'],
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
}

/// Provider for UserProfileService
final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService(ref.read(apiClientProvider));
});

/// Provider that reads from auth state (no extra API call needed)
final currentUserProvider = Provider<AsyncValue<UserProfile>>((ref) {
  final authState = ref.watch(authProvider);

  if (authState.isInitializing || authState.isLoading) {
    return const AsyncValue.loading();
  }

  if (authState.user != null) {
    return AsyncValue.data(authState.user!);
  }

  return AsyncValue.error('Not authenticated', StackTrace.current);
});
