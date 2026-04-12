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
      Member(
        id: '1',
        nameAr: 'عصماني سعاد',
        nameEn: 'Osmâni Souad',
        nameFr: 'Osmâne Souad',
        roleAr: 'رئيسة الجمعية',
        roleEn: 'President',
        roleFr: 'Présidente',
        bioAr: 'رئيسة جمعية إبزيم للثقافة والمواطنة، منتخبة من طرف الجمعية العامة في 14 ديسمبر 2024.',
        bioEn: 'President of the Ebzim Association, elected by the General Assembly on December 14, 2024.',
        bioFr: 'Présidente de l\'association Ebzim, élue par l\'Assemblée Générale le 14 décembre 2024.',
        imageUrl: 'assets/images/president.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '2',
        nameAr: 'ادريس قديح',
        nameEn: 'Driss Guédih',
        nameFr: 'Driss Guédih',
        roleAr: 'نائب أول للرئيس',
        roleEn: 'First Vice President',
        roleFr: '1er Vice-Président',
        bioAr: 'مكلف بتمثيل الجمعية والإشراف على اللجان الولائية في غياب الرئيسة.',
        bioEn: 'Responsible for representing the association and overseeing provincial committees.',
        bioFr: 'Responsable de la représentation de l\'association et de la supervision des commissions.',
        imageUrl: 'assets/images/committee.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '3',
        nameAr: 'دباش جمال الدين',
        nameEn: 'Debache Djamel Eddine',
        nameFr: 'Debache Djamel Eddine',
        roleAr: 'نائب ثاني للرئيس',
        roleEn: 'Second Vice President',
        roleFr: '2ème Vice-Président',
        bioAr: 'مكلف ببرمجة النشاطات الفنية والثقافية الكبرى للجمعية.',
        bioEn: 'In charge of programming the association\'s major artistic and cultural activities.',
        bioFr: 'Chargé de la programmation des activités artistiques et culturelles majeures.',
        imageUrl: 'assets/images/committee.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '4',
        nameAr: 'بوعظم صلاح الدين',
        nameEn: 'Bouâzam Salah Eddine',
        nameFr: 'Bouâzam Salaheddine',
        roleAr: 'الكاتب العام',
        roleEn: 'General Secretary',
        roleFr: 'Secrétaire Général',
        bioAr: 'المسؤول الأول عن الإدارة، التنسيق، ومتابعة تنفيذ قرارات المكتب التنفيذي.',
        bioEn: 'Chief administrator responsible for coordination and implementation of board decisions.',
        bioFr: 'Responsable de l\'administration et de l\'exécution des décisions du bureau.',
        imageUrl: 'assets/images/sg.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '5',
        nameAr: 'سويسي خليصة',
        nameEn: 'Souici Khelissa',
        nameFr: 'Souici Khelissa',
        roleAr: 'مساعدة الكاتب العام',
        roleEn: 'Assistant General Secretary',
        roleFr: 'Secrétaire Général Adjoint',
        bioAr: 'مساعدة الكاتب العام في المهام الإدارية وحفظ الأرشيف والمحاضر.',
        bioEn: 'Assists the General Secretary in administrative tasks and archive management.',
        bioFr: 'Aide le Secrétaire Général dans les tâches administratives et la gestion des archives.',
        imageUrl: 'assets/images/committee.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '6',
        nameAr: 'بوعظم ياسين',
        nameEn: 'Bouâzam Yacine',
        nameFr: 'Bouâzam Yacine',
        roleAr: 'أمين المال',
        roleEn: 'Treasurer',
        roleFr: 'Trésorier',
        bioAr: 'المسؤول عن مالية الجمعية، التقارير المالية، وتحصيل الاشتراكات.',
        bioEn: 'Responsible for the association\'s finances, financial reporting, and subscriptions.',
        bioFr: 'Responsable des finances, des rapports financiers et de la collecte des cotisations.',
        imageUrl: 'assets/images/committee.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '7',
        nameAr: 'بن سديرة علي',
        nameEn: 'Ben Sedira Ali',
        nameFr: 'Ben Sedira Ali',
        roleAr: 'مساعد أمين المال',
        roleEn: 'Assistant Treasurer',
        roleFr: 'Trésorier Adjoint',
        bioAr: 'مساعد في الإدارة المحاسبية ومتابعة الميزانيات المخصصة للمشاريع.',
        bioEn: 'Assists in accounting management and project budget monitoring.',
        bioFr: 'Aide à la gestion comptable et au suivi des budgets de projets.',
        imageUrl: 'assets/images/committee.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '8',
        nameAr: 'سعادنة نعيمة',
        nameEn: 'Saâdena Naïma',
        nameFr: 'Saâdena Naïma',
        roleAr: 'عضو مساعد',
        roleEn: 'Executive Member',
        roleFr: 'Membre du Bureau',
        bioAr: 'عضو في المكتب التنفيذي مكلفة بملف المرأة والطفولة داخل الجمعية.',
        bioEn: 'Executive board member in charge of the women and children committee.',
        bioFr: 'Membre du bureau chargée du comité des femmes et des enfants.',
        imageUrl: 'assets/images/committee.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
      Member(
        id: '9',
        nameAr: 'نشادي أحمد',
        nameEn: 'Nechadi Ahmed',
        nameFr: 'Nechadi Ahmed',
        roleAr: 'عضو مساعد',
        roleEn: 'Executive Member',
        roleFr: 'Membre du Bureau',
        bioAr: 'عضو في المكتب التنفيذي مكلف بالتنسيق مع المجتمع المدني والجمعيات الشريكة.',
        bioEn: 'Executive board member in charge of civil society and partner coordination.',
        bioFr: 'Membre du bureau chargé de la coordination avec la société civile.',
        imageUrl: 'assets/images/committee.png',
        category: 'المكتب التنفيذي',
        isExecutive: true,
      ),
    ];
  }
}

final memberServiceProvider = Provider((ref) => MemberService());

final leadershipProvider = FutureProvider<List<Member>>((ref) {
  return ref.read(memberServiceProvider).getLeadership();
});
