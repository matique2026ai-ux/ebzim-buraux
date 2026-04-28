enum PublicationCategory {
  heritage,
  research,
  reports,
  history,
  legal,
  cultural,
  other;

  String getLabel(String lang) {
    if (lang == 'ar') {
      switch (this) {
        case heritage: return 'التراث والآثار';
        case research: return 'البحوث العلمية';
        case reports: return 'التقارير السنوية';
        case history: return 'تاريخ سطيف';
        case legal: return 'قوانين وتشريعات';
        case cultural: return 'ثقافة وفنون';
        default: return 'أخرى';
      }
    } else if (lang == 'fr') {
      switch (this) {
        case heritage: return 'Patrimoine';
        case research: return 'Recherche';
        case reports: return 'Rapports';
        case history: return 'Histoire locale';
        case legal: return 'Lois et Législation';
        case cultural: return 'Culture et Arts';
        default: return 'Autre';
      }
    } else {
      switch (this) {
        case heritage: return 'Heritage';
        case research: return 'Research';
        case reports: return 'Annual Reports';
        case history: return 'Local History';
        case legal: return 'Laws & Legislation';
        case cultural: return 'Culture & Arts';
        default: return 'Other';
      }
    }
  }
}

class Publication {
  final String id;
  final String titleAr;
  final String titleEn;
  final String titleFr;
  final String authorAr;
  final String authorEn;
  final String authorFr;
  final String summaryAr;
  final String summaryEn;
  final String summaryFr;
  final String thumbnailUrl;
  final String pdfUrl;
  final PublicationCategory category;
  final DateTime publishedDate;

  Publication({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.titleFr,
    required this.authorAr,
    required this.authorEn,
    required this.authorFr,
    required this.summaryAr,
    required this.summaryEn,
    required this.summaryFr,
    required this.thumbnailUrl,
    required this.pdfUrl,
    required this.category,
    required this.publishedDate,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    final title = json['title'] is Map ? json['title'] : {};
    final author = json['author'] is Map ? json['author'] : {};
    final summary = json['summary'] is Map ? json['summary'] : {};

    PublicationCategory cat = PublicationCategory.other;
    final catString = json['category']?.toString().toLowerCase();
    if (catString == 'heritage') cat = PublicationCategory.heritage;
    else if (catString == 'research') cat = PublicationCategory.research;
    else if (catString == 'reports') cat = PublicationCategory.reports;
    else if (catString == 'history') cat = PublicationCategory.history;

    return Publication(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      titleAr: title['ar']?.toString() ?? '',
      titleEn: title['en']?.toString() ?? '',
      titleFr: title['fr']?.toString() ?? '',
      authorAr: author['ar']?.toString() ?? '',
      authorEn: author['en']?.toString() ?? '',
      authorFr: author['fr']?.toString() ?? '',
      summaryAr: summary['ar']?.toString() ?? '',
      summaryEn: summary['en']?.toString() ?? '',
      summaryFr: summary['fr']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
      pdfUrl: json['pdfUrl']?.toString() ?? '',
      category: cat,
      publishedDate: DateTime.tryParse(json['publishedDate']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': {'ar': titleAr, 'en': titleEn, 'fr': titleFr},
      'author': {'ar': authorAr, 'en': authorEn, 'fr': authorFr},
      'summary': {'ar': summaryAr, 'en': summaryEn, 'fr': summaryFr},
      'thumbnailUrl': thumbnailUrl,
      'pdfUrl': pdfUrl,
      'category': category.name.toUpperCase(),
      'publishedDate': publishedDate.toIso8601String(),
    };
  }

  String getTitle(String lang) => lang == 'ar' ? titleAr : lang == 'fr' ? titleFr : titleEn;
  String getAuthor(String lang) => lang == 'ar' ? authorAr : lang == 'fr' ? authorFr : authorEn;
  String getSummary(String lang) => lang == 'ar' ? summaryAr : lang == 'fr' ? summaryFr : summaryEn;
}
