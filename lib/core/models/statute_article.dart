class StatuteArticle {
  final int number;
  final String titleAr;
  final String titleEn;
  final String titleFr;
  final String contentAr;
  final String contentEn; // Summary in EN
  final String contentFr; // Summary in FR
  final String sectionLabelAr;
  final String sectionLabelEn;
  final String sectionLabelFr;

  const StatuteArticle({
    required this.number,
    required this.titleAr,
    required this.titleEn,
    required this.titleFr,
    required this.contentAr,
    required this.contentEn,
    required this.contentFr,
    required this.sectionLabelAr,
    required this.sectionLabelEn,
    required this.sectionLabelFr,
  });
}
