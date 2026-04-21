class HeroSlide {
  final String id;
  final String titleAr;
  final String titleEn;
  final String titleFr;
  final String subtitleAr;
  final String subtitleEn;
  final String subtitleFr;
  final String imageUrl;
  final String? videoUrl;
  final String? glassColor;
  final double overlayOpacity;
  final String? buttonText;
  final String? buttonLink;
  final int order;
  final String location;
  final bool isActive;

  HeroSlide({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.titleFr,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.subtitleFr,
    required this.imageUrl,
    this.videoUrl,
    this.glassColor,
    this.overlayOpacity = 0.1,
    this.buttonText,
    this.buttonLink,
    this.order = 0,
    this.location = 'HOME',
    this.isActive = true,
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
      videoUrl: json['videoUrl']?.toString(),
      glassColor: json['glassColor']?.toString(),
      overlayOpacity: json['overlayOpacity'] != null ? double.tryParse(json['overlayOpacity'].toString()) ?? 0.1 : 0.1,
      buttonText: json['buttonText']?.toString(),
      buttonLink: json['buttonLink']?.toString(),
      order: json['order'] is int ? json['order'] : 0,
      location: json['location']?.toString() ?? 'HOME',
      isActive: json['isActive'] ?? true,
    );
  }

  bool _isJunk(String? text) {
    if (text == null || text.trim().isEmpty) return true;
    final t = text.trim();
    // Only detect as junk if a single character is repeated more than 10 times
    // This allows short tests like "ببب" while filtering out long "ببببببببببببب"
    if (t.length > 10 && t.split('').every((char) => char == t[0])) return true;
    return false;
  }

  String getTitle(String lang) {
    String val = titleEn;
    if (lang == 'ar' && !_isJunk(titleAr)) val = titleAr;
    else if (lang == 'fr' && !_isJunk(titleFr)) val = titleFr;
    else if (!_isJunk(titleEn)) val = titleEn;
    else val = lang == 'ar' ? 'إرث سطيف، هوية وطن' : 'L\'héritage de Sétif';
    return val;
  }

  String getSubtitle(String lang) {
    String val = subtitleEn;
    if (lang == 'ar' && !_isJunk(subtitleAr)) val = subtitleAr;
    else if (lang == 'fr' && !_isJunk(subtitleFr)) val = subtitleFr;
    else if (!_isJunk(subtitleEn)) val = subtitleEn;
    else val = lang == 'ar' ? 'جمعية إبزيم هي المساحة الولائية لتسخير المعارف والوسائل في سبيل حماية الهوية الجزائرية.' : 'L\'association Ebzim est l\'espace pour la protection de l\'identité algérienne.';
    return val;
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
  final bool isActive;

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
    this.color = '#0F172A',
    this.order = 0,
    this.isActive = true,
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
      color: json['color']?.toString() ?? '#0F172A',
      order: json['order'] is int ? json['order'] : 0,
      isActive: json['isActive'] ?? true,
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
  final bool isActive;

  EbzimLeader({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.roleAr,
    required this.roleEn,
    required this.roleFr,
    this.photoUrl,
    this.order = 0,
    this.isActive = true,
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
      isActive: json['isActive'] ?? true,
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
