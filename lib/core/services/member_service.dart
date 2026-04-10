import 'package:flutter_riverpod/flutter_riverpod.dart';

class Member {
  final String id;
  final String nameEn;
  final String nameAr;
  final String nameFr;
  final String roleEn;
  final String roleAr;
  final String roleFr;
  final String bioEn;
  final String bioAr;
  final String bioFr;
  final String imageUrl;
  final String category;
  final bool isExecutive;

  Member({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.nameFr,
    required this.roleEn,
    required this.roleAr,
    required this.roleFr,
    required this.bioEn,
    required this.bioAr,
    required this.bioFr,
    required this.imageUrl,
    required this.category,
    this.isExecutive = false,
  });

  // Helper to get name based on current locale
  String getName(String languageCode) {
    if (languageCode == 'ar') return nameAr;
    if (languageCode == 'fr') return nameFr;
    return nameEn;
  }

  String getRole(String languageCode) {
    if (languageCode == 'ar') return roleAr;
    if (languageCode == 'fr') return roleFr;
    return roleEn;
  }

  String getBio(String languageCode) {
    if (languageCode == 'ar') return bioAr;
    if (languageCode == 'fr') return bioFr;
    return bioEn;
  }
}

class MemberService {
  Future<List<Member>> getLeadership() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      // ── المكتب التنفيذي (Art. 24) ──
      Member(
        id: '1',
        nameEn: 'Souad Osmane',
        nameAr: 'سعاد عصماني',
        nameFr: 'Souad Osmane',
        roleEn: 'President',
        roleAr: 'رئيسة الجمعية',
        roleFr: 'Présidente',
        bioEn: 'President of the Ebzim Association for Culture and Citizenship, elected by the General Assembly in December 2024.',
        bioAr: 'رئيسة جمعية إبزيم للثقافة والمواطنة، منتخبة من طرف الجمعية العامة في ديسمبر 2024.',
        bioFr: 'Présidente de l\'association Ebzim pour la Culture et la Citoyenneté, élue par l\'Assemblée Générale en décembre 2024.',
        imageUrl: 'assets/images/president.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '2',
        nameEn: 'Salaheddine Bouazzem',
        nameAr: 'صلاح الدين بوعظم',
        nameFr: 'Salaheddine Bouazzem',
        roleEn: 'Secretary General',
        roleAr: 'الأمين العام',
        roleFr: 'Secrétaire Général',
        bioEn: 'Secretary General of the Ebzim Association, responsible for administrative coordination and general assembly proceedings.',
        bioAr: 'الأمين العام لجمعية إبزيم، مسؤول عن التنسيق الإداري وسير أعمال الجمعية العامة.',
        bioFr: 'Secrétaire Général de l\'association Ebzim, responsable de la coordination administrative.',
        imageUrl: 'assets/images/sg.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '3',
        nameEn: 'Treasurer',
        nameAr: 'أمين المال',
        nameFr: 'Trésorier',
        roleEn: 'Treasurer',
        roleAr: 'أمين المال',
        roleFr: 'Trésorier',
        bioEn: 'Responsible for financial management and accounting of the association\'s funds in accordance with Article 36.',
        bioAr: 'مسؤول عن الإدارة المالية ومحاسبة أموال الجمعية وفقاً للمادة 36.',
        bioFr: 'Responsable de la gestion financière et comptable des fonds de l\'association conformément à l\'article 36.',
        imageUrl: 'assets/images/committee.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '4',
        nameEn: 'Cultural Committee Lead',
        nameAr: 'رئيس لجنة الثقافة',
        nameFr: 'Responsable Comité Culturel',
        roleEn: 'Cultural Committee',
        roleAr: 'لجنة الثقافة والفنون',
        roleFr: 'Comité Culturel',
        bioEn: 'Leading the Cultural & Arts committee, one of the 9 official committees defined in the association\'s statutes (Art. 23).',
        bioAr: 'يقود لجنة الثقافة والفنون، إحدى اللجان التسع المنصوص عليها في القانون الأساسي (المادة 23).',
        bioFr: 'Dirige le comité Culture & Arts, l\'un des 9 comités officiels définis dans les statuts (Art. 23).',
        imageUrl: 'assets/images/committee.png',
        category: 'اللجان',
      ),
      Member(
        id: '5',
        nameEn: 'Heritage Committee Lead',
        nameAr: 'رئيس لجنة التراث',
        nameFr: 'Responsable Comité Patrimoine',
        roleEn: 'Heritage Committee',
        roleAr: 'لجنة التراث المادي وغير المادي',
        roleFr: 'Comité Patrimoine',
        bioEn: 'Responsible for preserving the material and immaterial heritage of the Setif region, including coordination with the National Museum of Archeology.',
        bioAr: 'مسؤول عن الحفاظ على التراث المادي وغير المادي لولاية سطيف، بما يشمل التنسيق مع المتحف الوطني للآثار.',
        bioFr: 'Responsable de la préservation du patrimoine matériel et immatériel de la région de Sétif.',
        imageUrl: 'assets/images/committee.png',
        category: 'اللجان',
      ),

    ];
  }
}

final memberServiceProvider = Provider((ref) => MemberService());

final leadershipProvider = FutureProvider<List<Member>>((ref) {
  return ref.read(memberServiceProvider).getLeadership();
});
