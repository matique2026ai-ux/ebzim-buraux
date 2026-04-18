import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/services/api_client.dart';

class LocationModel {
  final String id;
  final String code;
  final String nameEn;
  final String nameAr;
  final String nameFr;

  LocationModel(this.id, this.code, this.nameEn, this.nameAr, this.nameFr);
}

// Mocks representing a swappable data layer
class WilayaService {
  List<LocationModel> getWilayas() {
    return [
      LocationModel('1', '01', 'Adrar', 'أدرار', 'Adrar'),
      LocationModel('16', '16', 'Algiers', 'الجزائر العاصمة', 'Alger'),
      LocationModel('19', '19', 'Setif', 'سطيف', 'Sétif'),
      LocationModel('31', '31', 'Oran', 'وهران', 'Oran'),
    ];
  }

  List<LocationModel> getCommunes(String wilayaId) {
    if (wilayaId == '19') {
      return [
        LocationModel('1901', '1901', 'Setif City', 'مدينة سطيف', 'Ville de Sétif'),
        LocationModel('1902', '1902', 'El Eulma', 'العلمة', 'El Eulma'),
        LocationModel('1903', '1903', 'Bougaa', 'بوقاعة', 'Bougaa'),
      ];
    }
    return [
      LocationModel('xx', 'xx', 'Main City', 'المدينة الرئيسية', 'Ville principale'),
    ];
  }
}

final wilayaServiceProvider = Provider((ref) => WilayaService());


class MembershipFormState {
  // Step 1: Identity
  final String fullName;
  final DateTime? dob;
  final String gender;
  
  // Step 2: Contact
  final String wilayaId;
  final String communeId;
  final String phone;
  final String email;
  
  // Step 3: Credentials
  final List<String> interests;
  final List<String> skills;
  final String motivation;
  
  // Step 4: Review
  final String notes;
  final bool hasConsented;
  final List<Map<String, String>> attachments; // { 'url': ..., 'type': 'ID_CARD' }

  const MembershipFormState({
    this.fullName = '',
    this.dob,
    this.gender = '',
    this.wilayaId = '',
    this.communeId = '',
    this.phone = '',
    this.email = '',
    this.interests = const [],
    this.skills = const [],
    this.motivation = '',
    this.notes = '',
    this.hasConsented = false,
    this.attachments = const [],
  });

  MembershipFormState copyWith({
    String? fullName,
    DateTime? dob,
    String? gender,
    String? wilayaId,
    String? communeId,
    String? phone,
    String? email,
    List<String>? interests,
    List<String>? skills,
    String? motivation,
    String? notes,
    bool? hasConsented,
    List<Map<String, String>>? attachments,
  }) {
    return MembershipFormState(
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      wilayaId: wilayaId ?? this.wilayaId,
      communeId: communeId ?? this.communeId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      interests: interests ?? this.interests,
      skills: skills ?? this.skills,
      motivation: motivation ?? this.motivation,
      notes: notes ?? this.notes,
      hasConsented: hasConsented ?? this.hasConsented,
      attachments: attachments ?? this.attachments,
    );
  }
}

class MembershipNotifier extends StateNotifier<MembershipFormState> {
  final Ref ref;
  MembershipNotifier(this.ref) : super(const MembershipFormState());

  void updateField<T>(String field, T value) {
    if (field == 'fullName') state = state.copyWith(fullName: value as String);
    if (field == 'dob') state = state.copyWith(dob: value as DateTime);
    if (field == 'gender') state = state.copyWith(gender: value as String);
    if (field == 'wilayaId') state = state.copyWith(wilayaId: value as String);
    if (field == 'communeId') state = state.copyWith(communeId: value as String);
    if (field == 'phone') state = state.copyWith(phone: value as String);
    if (field == 'email') state = state.copyWith(email: value as String);
    if (field == 'motivation') state = state.copyWith(motivation: value as String);
    if (field == 'notes') state = state.copyWith(notes: value as String);
    if (field == 'hasConsented') state = state.copyWith(hasConsented: value as bool);
    if (field == 'attachments') state = state.copyWith(attachments: value as List<Map<String, String>>);
  }
  
  void toggleList(String field, String item) {
    if (field == 'interests') {
      final list = List<String>.from(state.interests);
      list.contains(item) ? list.remove(item) : list.add(item);
      state = state.copyWith(interests: list);
    }
    if (field == 'skills') {
      final list = List<String>.from(state.skills);
      list.contains(item) ? list.remove(item) : list.add(item);
      state = state.copyWith(skills: list);
    }
  }

  Future<void> submitApplication() async {
    final dio = ref.read(apiClientProvider).dio;
    final payload = {
      'fullName': state.fullName,
      'dob': state.dob?.toIso8601String(),
      'gender': state.gender,
      'wilayaId': state.wilayaId,
      'communeId': state.communeId,
      'phone': state.phone,
      'email': state.email,
      'interests': state.interests,
      'skills': state.skills,
      'motivation': state.motivation,
      'attachments': state.attachments,
    };
    
    await dio.post('/memberships', data: payload);
    state = const MembershipFormState();
  }
}

final membershipProvider = StateNotifierProvider<MembershipNotifier, MembershipFormState>((ref) {
  return MembershipNotifier(ref);
});

final membershipStatusProvider = FutureProvider<String>((ref) async {
  final dio = ref.read(apiClientProvider).dio;
  try {
    final response = await dio.get('/memberships/my-status');
    return response.data['status'] ?? 'NONE';
  } catch (e) {
    return 'NONE';
  }
});

class MembershipRequest {
  final String id;
  final String fullName;
  final String status;
  final DateTime submissionDate;
  final Map<String, dynamic> data;

  MembershipRequest({
    required this.id,
    required this.fullName,
    required this.status,
    required this.submissionDate,
    required this.data,
  });

  factory MembershipRequest.fromJson(Map<String, dynamic> json) {
    final applicationData = json['applicationData'] ?? {};
    return MembershipRequest(
      id: json['_id'] ?? '',
      fullName: applicationData['fullName'] ?? 'Unknown',
      status: json['status'] ?? 'SUBMITTED',
      submissionDate: DateTime.parse(json['submissionDate'] ?? DateTime.now().toIso8601String()),
      data: applicationData,
    );
  }
}

final pendingMembershipsProvider = FutureProvider<List<MembershipRequest>>((ref) async {
  final dio = ref.read(apiClientProvider).dio;
  // Note: /memberships/admin returns a paginated response { data: [], meta: {} }
  final response = await dio.get('/memberships/admin');
  final list = (response.data['data'] as List).map((e) => MembershipRequest.fromJson(e)).toList();
  return list;
});

final membershipAdminProvider = Provider((ref) => MembershipAdminService(ref));

class MembershipAdminService {
  final Ref ref;
  MembershipAdminService(this.ref);

  Future<void> reviewRequest(String id, String status, {String? notes}) async {
    final dio = ref.read(apiClientProvider).dio;
    await dio.patch('/memberships/$id/review', data: {
      'status': status,
      'internalReviewNotes': notes,
    });
    ref.invalidate(pendingMembershipsProvider);
  }
}
