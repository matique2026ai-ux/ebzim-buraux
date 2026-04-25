enum PublicationCategory {
  heritage,
  research,
  reports,
  history,
  other;

  String getLabel(String lang) {
    if (lang == 'ar') {
      switch (this) {
        case heritage:
          return 'التراث والآثار';
        case research:
          return 'البحوث العلمية';
        case reports:
          return 'التقارير السنوية';
        case history:
          return 'تاريخ سطيف';
        default:
          return 'أخرى';
      }
    } else if (lang == 'fr') {
      switch (this) {
        case heritage:
          return 'Patrimoine';
        case research:
          return 'Recherche';
        case reports:
          return 'Rapports';
        case history:
          return 'Histoire locale';
        default:
          return 'Autre';
      }
    } else {
      switch (this) {
        case heritage:
          return 'Heritage';
        case research:
          return 'Research';
        case reports:
          return 'Annual Reports';
        case history:
          return 'Local History';
        default:
          return 'Other';
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

  String getTitle(String lang) => lang == 'ar'
      ? titleAr
      : lang == 'fr'
      ? titleFr
      : titleEn;
  String getAuthor(String lang) => lang == 'ar'
      ? authorAr
      : lang == 'fr'
      ? authorFr
      : authorEn;
  String getSummary(String lang) => lang == 'ar'
      ? summaryAr
      : lang == 'fr'
      ? summaryFr
      : summaryEn;
}
