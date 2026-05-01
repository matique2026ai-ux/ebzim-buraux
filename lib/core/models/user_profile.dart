import 'package:flutter/material.dart';

enum EbzimRole {
  superAdmin,
  admin,
  authority,
  member,
  public;

  String get apiValue {
    switch (this) {
      case superAdmin:
        return 'SUPER_ADMIN';
      case admin:
        return 'ADMIN';
      case authority:
        return 'AUTHORITY';
      case member:
        return 'MEMBER';
      case public:
        return 'PUBLIC';
    }
  }

  static EbzimRole fromString(String role) {
    switch (role.toUpperCase()) {
      case 'SUPER_ADMIN': return EbzimRole.superAdmin;
      case 'ADMIN': return EbzimRole.admin;
      case 'AUTHORITY': return EbzimRole.authority;
      case 'MEMBER': return EbzimRole.member;
      default: return EbzimRole.public;
    }
  }

  String getLabel(String lang) {
    if (lang == 'ar') {
      switch (this) {
        case superAdmin: return 'رئيس الجمعية';
        case admin: return 'عضو المكتب التنفيذي';
        case authority: return 'شريك مؤسساتي';
        case member: return 'عضو عامل';
        case public: return 'زائر المنصة';
      }
    } else {
      switch (this) {
        case superAdmin: return 'President of Association';
        case admin: return 'Executive Board Member';
        case authority: return 'Institutional Partner';
        case member: return 'Active Member';
        case public: return 'Platform Guest';
      }
    }
  }

  Color getBadgeColor() {
    switch (this) {
      case superAdmin: return const Color(0xFFD4AF37); // Gold
      case admin: return const Color(0xFF052011); // Ebzim Emerald
      case authority: return const Color(0xFFB91C1C); // Deep Red
      case member: return const Color(0xFF0369A1); // Deep Blue
      case public: return Colors.grey;
    }
  }
}

class UserProfile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? firstNameAr;
  final String? lastNameAr;
  final String? phone;
  final String? imageUrl;
  final EbzimRole role;
  final String? membershipBadge;
  final String status;
  final DateTime? membershipExpiry;
  final DateTime? createdAt;
  final String? bio;

  UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.firstNameAr,
    this.lastNameAr,
    this.phone,
    this.imageUrl,
    required this.role,
    this.membershipBadge,
    this.status = 'ACTIVE',
    this.membershipExpiry,
    this.createdAt,
    this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};
    return UserProfile(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: profile['firstName'] ?? '',
      lastName: profile['lastName'] ?? '',
      firstNameAr: profile['firstNameAr'],
      lastNameAr: profile['lastNameAr'],
      phone: profile['phone'],
      imageUrl: profile['avatarUrl'] ?? profile['imageUrl'],
      role: EbzimRole.fromString(json['role'] ?? 'PUBLIC'),
      membershipBadge: json['membershipBadge'],
      status: json['status'] ?? 'ACTIVE',
      membershipExpiry: json['membershipExpiry'] != null ? DateTime.tryParse(json['membershipExpiry'].toString()) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      bio: profile['bio'],
    );
  }

  String getName(String lang) {
    if (lang == 'ar' && firstNameAr != null && lastNameAr != null) {
      return '$firstNameAr $lastNameAr'.trim();
    }
    return '$firstName $lastName'.trim();
  }

  String getInstitutionalTitle(String lang) {
    if (lang == 'ar') {
      if (role == EbzimRole.superAdmin) return 'رئيس الجمعية';
      if (role == EbzimRole.admin) return 'عضو المكتب التنفيذي';
      if (role == EbzimRole.authority) return 'شريك مؤسساتي';
      if (role == EbzimRole.member) return 'عضو عامل';
      return 'زائر المنصة';
    } else {
      if (role == EbzimRole.superAdmin) return 'President of Association';
      if (role == EbzimRole.admin) return 'Executive Board Member';
      if (role == EbzimRole.authority) return 'Institutional Partner';
      if (role == EbzimRole.member) return 'Active Member';
      return 'Platform Guest';
    }
  }

  double get profileCompletionPercentage {
    int total = 5; // firstName, lastName, phone, imageUrl, bio
    int filled = 0;
    if (firstName.isNotEmpty) filled++;
    if (lastName.isNotEmpty) filled++;
    if (phone != null && phone!.isNotEmpty) filled++;
    if (imageUrl != null && imageUrl!.isNotEmpty) filled++;
    if (bio != null && bio!.isNotEmpty) filled++;
    return filled / total;
  }

  String getFormattedExpiry(String lang) {
    if (membershipExpiry == null) return '—';
    final date = membershipExpiry!;
    if (lang == 'ar') {
      return '${date.year}/${date.month}/${date.day}';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? firstNameAr,
    String? lastNameAr,
    String? phone,
    String? imageUrl,
    EbzimRole? role,
    String? membershipBadge,
    String? status,
    DateTime? membershipExpiry,
    DateTime? createdAt,
    String? bio,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      firstNameAr: firstNameAr ?? this.firstNameAr,
      lastNameAr: lastNameAr ?? this.lastNameAr,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      membershipBadge: membershipBadge ?? this.membershipBadge,
      status: status ?? this.status,
      membershipExpiry: membershipExpiry ?? this.membershipExpiry,
      createdAt: createdAt ?? this.createdAt,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.apiValue,
      'status': status,
      'membershipBadge': membershipBadge,
      'membershipExpiry': membershipExpiry?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'profile': {
        'firstName': firstName,
        'lastName': lastName,
        'firstNameAr': firstNameAr,
        'lastNameAr': lastNameAr,
        'phone': phone,
        'avatarUrl': imageUrl,
        'bio': bio,
      },
    };
  }
}
