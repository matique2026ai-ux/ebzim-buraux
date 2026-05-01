class MarketBook {
  final String id;
  final String titleAr;
  final String titleEn;
  final String titleFr;
  final String author;
  final String descriptionAr;
  final String descriptionEn;
  final String descriptionFr;
  final double price;
  final double deliveryCost;
  final String condition;
  final String coverImage;
  final String contactInfo;
  final bool isAvailable;

  MarketBook({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.titleFr,
    required this.author,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.descriptionFr,
    required this.price,
    required this.deliveryCost,
    required this.condition,
    required this.coverImage,
    required this.contactInfo,
    this.isAvailable = true,
  });

  factory MarketBook.fromJson(Map<String, dynamic> json) {
    final title = json['title'] is Map ? json['title'] : {};
    final description = json['description'] is Map ? json['description'] : {};

    return MarketBook(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      titleAr: title['ar']?.toString() ?? '',
      titleEn: title['en']?.toString() ?? '',
      titleFr: title['fr']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      descriptionAr: description['ar']?.toString() ?? '',
      descriptionEn: description['en']?.toString() ?? '',
      descriptionFr: description['fr']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      deliveryCost: (json['deliveryCost'] as num?)?.toDouble() ?? 0.0,
      condition: json['condition']?.toString() ?? 'NEW',
      coverImage: json['coverImage']?.toString() ?? '',
      contactInfo: json['contactInfo']?.toString() ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': {'ar': titleAr, 'en': titleEn, 'fr': titleFr},
      'author': author,
      'description': {'ar': descriptionAr, 'en': descriptionEn, 'fr': descriptionFr},
      'price': price,
      'deliveryCost': deliveryCost,
      'condition': condition,
      'coverImage': coverImage,
      'contactInfo': contactInfo,
      'isAvailable': isAvailable,
    };
  }

  String getTitle(String lang) => lang == 'ar' ? titleAr : lang == 'fr' ? titleFr : titleEn;
  String getDescription(String lang) => lang == 'ar' ? descriptionAr : lang == 'fr' ? descriptionFr : descriptionEn;
}
