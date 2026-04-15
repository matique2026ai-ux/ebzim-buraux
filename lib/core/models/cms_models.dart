class HeroSlide {
  final String id;
  final String titleAr;
  final String titleEn;
  final String titleFr;
  final String subtitleAr;
  final String subtitleEn;
  final String subtitleFr;
  final String imageUrl;
  final String? buttonText;
  final String? buttonLink;
  final int order;

  HeroSlide({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.titleFr,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.subtitleFr,
    required this.imageUrl,
    this.buttonText,
    this.buttonLink,
    this.order = 0,
  });

  factory HeroSlide.fromJson(Map<String, dynamic> json) {
    final title = json['title'] is Map ? json['title'] : {};
    final subtitle = json['subtitle'] is Map ? json['subtitle'] : {};
    return HeroSlide(
      id: json['_id']?.toString() ?? '',
      titleAr: title['ar']?.toString() ?? '',
      titleEn: title['en']?.toString() ?? '',
      titleFr: title['fr']?.toString() ?? '',
      subtitleAr: subtitle['ar']?.toString() ?? '',
      subtitleEn: subtitle['en']?.toString() ?? '',
      subtitleFr: subtitle['fr']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      buttonText: json['buttonText']?.toString(),
      buttonLink: json['buttonLink']?.toString(),
      order: json['order'] is int ? json['order'] : 0,
    );
  }

  String getTitle(String lang) {
    if (lang == 'ar') return titleAr;
    if (lang == 'fr') return titleFr;
    return titleEn;
  }

  String getSubtitle(String lang) {
    if (lang == 'ar') return subtitleAr;
    if (lang == 'fr') return subtitleFr;
    return subtitleEn;
  }
}

class Partner {
  final String id;
  final String nameAr;
  final String nameEn;
  final String nameFr;
  final String logoUrl;
  final String goalsSummaryAr;
  final String goalsSummaryEn;
  final String goalsSummaryFr;
  final String? websiteUrl;
  final String color;
  final int order;

  Partner({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.nameFr,
    required this.logoUrl,
    required this.goalsSummaryAr,
    required this.goalsSummaryEn,
    required this.goalsSummaryFr,
    this.websiteUrl,
    this.color = '#052011',
    this.order = 0,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    final name = json['name'] is Map ? json['name'] : {};
    final goals = json['goalsSummary'] is Map ? json['goalsSummary'] : {};
    return Partner(
      id: json['_id']?.toString() ?? '',
      nameAr: name['ar']?.toString() ?? '',
      nameEn: name['en']?.toString() ?? '',
      nameFr: name['fr']?.toString() ?? '',
      logoUrl: json['logoUrl']?.toString() ?? '',
      goalsSummaryAr: goals['ar']?.toString() ?? '',
      goalsSummaryEn: goals['en']?.toString() ?? '',
      goalsSummaryFr: goals['fr']?.toString() ?? '',
      websiteUrl: json['websiteUrl']?.toString(),
      color: json['color']?.toString() ?? '#052011',
      order: json['order'] is int ? json['order'] : 0,
    );
  }

  String getName(String lang) {
    if (lang == 'ar') return nameAr;
    if (lang == 'fr') return nameFr;
    return nameEn;
  }

  String getGoals(String lang) {
    if (lang == 'ar') return goalsSummaryAr;
    if (lang == 'fr') return goalsSummaryFr;
    return goalsSummaryEn;
  }
}

class EbzimLeader {
  final String id;
  final String nameAr;
  final String nameEn;
  final String roleAr;
  final String roleEn;
  final String roleFr;
  final String? photoUrl;
  final int order;

  EbzimLeader({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.roleAr,
    required this.roleEn,
    required this.roleFr,
    this.photoUrl,
    this.order = 0,
  });

  factory EbzimLeader.fromJson(Map<String, dynamic> json) {
    final name = json['name'] is Map ? json['name'] : {};
    final role = json['role'] is Map ? json['role'] : {};
    return EbzimLeader(
      id: json['_id']?.toString() ?? '',
      nameAr: name['ar']?.toString() ?? '',
      nameEn: name['en']?.toString() ?? '',
      roleAr: role['ar']?.toString() ?? '',
      roleEn: role['en']?.toString() ?? '',
      roleFr: role['fr']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString(),
      order: json['order'] is int ? json['order'] : 0,
    );
  }

  String getName(String lang) {
    if (lang == 'ar') return nameAr;
    return nameEn;
  }

  String getRole(String lang) {
    if (lang == 'ar') return roleAr;
    if (lang == 'fr') return roleFr;
    return roleEn;
  }
}
