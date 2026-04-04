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
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Member(
        id: '1',
        nameEn: 'Dr. Amin Al-Mansour',
        nameAr: 'د. أمين المنصور',
        nameFr: 'Dr Amin Al-Mansour',
        roleEn: 'Founding President',
        roleAr: 'رئيس مجلس الإدارة',
        roleFr: 'Président Fondateur',
        bioEn: 'The mission of Ebzim is not merely to archive our past, but to synthesize it with the innovations of tomorrow.',
        bioAr: 'مهمة إبزيم ليست مجرد أرشفة ماضينا، بل هي توليفه مع ابتكارات الغد.',
        bioFr: 'La mission d\'Ebzim n\'est pas seulement d\'archiver notre passé, mais de le synthétiser avec les innovations de demain.',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBpkhIP5p1lPL-j7AXej-0zGIAxc43gOv3b4FJgOSz-UlO_ehRUE-7bniRy1FpOw9LuqakfeYsmKQ-6GO4cDXKj2gJoKm_49KeLij3lyjpOVi8nXgdnkbDkmJrhpz1Z4Nd8s4QJM6eXnVBhlScCwFpUST3TxQsW1z6DNL7EVw4PJSvT5gh8Sa9JO172ekDW5VaqM529slh41N5PwVdA_NDPf7WGlsV3OgccFOyAGdHIyX9bd6JU8Su5BHQffOhKMN3qezglCvuzeKpK',
        category: 'Executive Leadership',
        isExecutive: true,
      ),
      Member(
        id: '2',
        nameEn: 'Laila Belkacem',
        nameAr: 'ليلى بلقاسم',
        nameFr: 'Laila Belkacem',
        roleEn: 'Director of Cultural Affairs',
        roleAr: 'مديرة الشؤون الثقافية',
        roleFr: 'Directrice des Affaires Culturelles',
        bioEn: 'Expert in Maghrebi heritage preservation with over 15 years of research.',
        bioAr: 'خبيرة في الحفاظ على التراث المغاربي مع أكثر من 15 عاماً من البحث.',
        bioFr: 'Experte en préservation du patrimoine maghrébin avec plus de 15 ans de recherche.',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA3HHRkVaLb7ZwDpZu-zo7k_xI-9cyogTL08ZF-qeb__9YPli4taf1lPcuvrSPAbwtRhuqlp8w_4g2swnro_dK-rR7Iu98bei85oVgK-HXhq7CeV_Afmr6KAqQ0tbOi-VvoQDyyG6bMCrwzPReYRN85cNWpwPTOAFR_6AFpjVS0wEFq72kZP4eTIu5FbgoiKgg0e4ozGZ7vZg9hUUjRhTbp1z1yCMyaHvTuCyPpAYHio-DHmeZ0rAxEeSxJgjKEGcx7YoG3AgDm2Bfa',
        category: 'Board Members',
      ),
      Member(
        id: '3',
        nameEn: 'Karim Idris',
        nameAr: 'كريم إدريس',
        nameFr: 'Karim Idris',
        roleEn: 'Strategic Operations',
        roleAr: 'العمليات الاستراتيجية',
        roleFr: 'Opérations Stratégiques',
        bioEn: 'Specializes in digital transformation for cultural entities.',
        bioAr: 'متخصص في التحول الرقمي للكيانات الثقافية.',
        bioFr: 'Spécialisé dans la transformation numérique pour les entités culturelles.',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBtAVrqTw9eND9Db33V_KdbNkKQoRM8wBfcyBd5a0OHpIuB6q09zq6XDXEaKpGGBG9Vzbw6f7evfkOA-YtR1JJHh5E-iqfqYP9Apx9YigQGcBGb15UlxgVvPhD5v5_uJ_XoX7MGj4I3CUcW1u4iWRXrrSHbjEM3Qu4pu2rGfO5UdTq_0tmxcEdpfORlsRusc5xqgfmPxyQ5a6qKEvzPlzJw7216bV2X4iW0W7QVpEfqJbM7iyH30rWqLHc-XGPXZQKXGh-oyDo_4wBu',
        category: 'Board Members',
      ),
      Member(
        id: '4',
        nameEn: 'Sarah Chevalier',
        nameAr: 'سارة شوفالييه',
        nameFr: 'Sarah Chevalier',
        roleEn: 'International Liaison',
        roleAr: 'التعاون الدولي',
        roleFr: 'Liaison Internationale',
        bioEn: 'Facilitating partnerships with European museums.',
        bioAr: 'تسهيل الشراكات مع المتاحف الأوروبية.',
        bioFr: 'Faciliter les partenariats avec les musées européens.',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDrtsJcLG1pgNxanWhPotGTvpkSyWP5fsBHuROAex6JCtNMK_gxu0uUPdbbtlzTTXRII17wET8AEz0EfeAP25ukNSuWTHnD_XYbj_hlL96RQoK_3eorU7IeNZir6xS2DfkJNawUxl4hKOS-Bp5Vdwuvw6wpP63YtAktUxD7ld34H2wZFVbUZj7FmeNRS15_ndlb_zN1uGBM_X5Y-aJPkqoFUt_prvBUJEjmyOjIGTvzNeDHXo33nX90VWxU9nBj7HB2Jy8qhMw3robU',
        category: 'Board Members',
      )
    ];
  }
}

final memberServiceProvider = Provider((ref) => MemberService());

final leadershipProvider = FutureProvider<List<Member>>((ref) {
  return ref.read(memberServiceProvider).getLeadership();
});
