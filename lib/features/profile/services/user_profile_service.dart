import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/services/auth_service.dart';

class UserProfile {
  final String id;
  final String name;
  final String nameAr;
  final String email;
  final String phone;
  final String imageUrl;
  final String membershipLevel; 
  final String membershipStatus; 
  final DateTime membershipExpiry;
  final int profileCompletionPercentage;

  UserProfile({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.membershipLevel,
    required this.membershipStatus,
    required this.membershipExpiry,
    required this.profileCompletionPercentage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};
    return UserProfile(
      id: json['id'] ?? json['_id'] ?? '',
      name: '${profile['firstName'] ?? ''} ${profile['lastName'] ?? ''}'.trim(),
      nameAr: profile['firstNameAr'] ?? profile['firstName'] ?? '',
      email: json['email'] ?? '',
      phone: profile['phone'] ?? '',
      imageUrl: profile['avatarUrl'] ?? 'https://via.placeholder.com/150',
      membershipLevel: json['role'] ?? 'MEMBER',
      membershipStatus: json['status'] ?? 'ACTIVE',
      membershipExpiry: DateTime.now().add(const Duration(days: 365)),
      profileCompletionPercentage: 100,
    );
  }

  String getName(String languageCode) {
    if (languageCode == 'ar') return nameAr;
    return name;
  }
}

// This now watches the auth state instead of a mock call
final currentUserProvider = Provider<AsyncValue<UserProfile>>((ref) {
  final authState = ref.watch(authProvider);
  
  if (authState.user != null) {
    return AsyncValue.data(authState.user!);
  }
  
  if (authState.isLoading) {
    return const AsyncValue.loading();
  }
  
  return AsyncValue.error('Not authenticated', StackTrace.current);
});
