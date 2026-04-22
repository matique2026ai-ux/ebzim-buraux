import 'package:flutter/material.dart';

class ProjectMilestone {
  final String titleAr;
  final String titleEn;
  final String titleFr;
  final DateTime date;
  final bool isCompleted;

  ProjectMilestone({
    required this.titleAr,
    required this.titleEn,
    this.titleFr = '',
    required this.date,
    required this.isCompleted,
  });

  factory ProjectMilestone.fromJson(Map<String, dynamic> json) {
    return ProjectMilestone(
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleFr: json['titleFr'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titleAr': titleAr,
      'titleEn': titleEn,
      'titleFr': titleFr,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  ProjectMilestone copyWith({
    String? titleAr,
    String? titleEn,
    String? titleFr,
    DateTime? date,
    bool? isCompleted,
  }) {
    return ProjectMilestone(
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      titleFr: titleFr ?? this.titleFr,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  String getLabel(String lang) {
    if (lang == 'ar') return titleAr;
    if (lang == 'fr' && titleFr.isNotEmpty) return titleFr;
    return titleEn;
  }
}

class NewsPost {
  final String id;
  final String titleAr;
  final String titleEn;
  final String titleFr;
  final String summaryAr;
  final String summaryEn;
  final String summaryFr;
  final String bodyAr;
  final String bodyEn;
  final String bodyFr;
  final String imageUrl;
  final String category;
  final String projectStatus;
  final double progressPercentage;
  final bool isPinned;
  final bool isFeatured;
  final DateTime publishedAt;
  final List<ProjectMilestone> milestones;
  final String? partnerName;

  NewsPost({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.titleFr,
    required this.summaryAr,
    required this.summaryEn,
    required this.summaryFr,
    required this.bodyAr,
    required this.bodyEn,
    required this.bodyFr,
    required this.imageUrl,
    required this.category,
    this.projectStatus = 'GENERAL',
    this.progressPercentage = 0.0,
    this.isPinned = false,
    this.isFeatured = false,
    required this.publishedAt,
    this.milestones = const [],
    this.partnerName,
  });

  factory NewsPost.fromJson(Map<String, dynamic> json) {
    final title = json['title'] is Map ? json['title'] : {};
    final summary = json['summary'] is Map ? json['summary'] : {};
    final content = json['content'] is Map ? json['content'] : {};
    final metadata = json['metadata'] is Map ? json['metadata'] : {};
    
    // Parse media
    String img = '';
    if (json['media'] is List && (json['media'] as List).isNotEmpty) {
      img = json['media'][0]['cloudinaryUrl'] ?? '';
    }

    // Parse milestones
    List<ProjectMilestone> miles = [];
    if (metadata['milestones'] is List) {
      miles = (metadata['milestones'] as List)
          .map((m) => ProjectMilestone.fromJson(m))
          .toList();
    }

    return NewsPost(
      id: json['_id'] ?? json['id'] ?? '',
      titleAr: title['ar'] ?? '',
      titleEn: title['en'] ?? '',
      titleFr: title['fr'] ?? '',
      summaryAr: summary['ar'] ?? '',
      summaryEn: summary['en'] ?? '',
      summaryFr: summary['fr'] ?? '',
      bodyAr: content['ar'] ?? '',
      bodyEn: content['en'] ?? '',
      bodyFr: content['fr'] ?? '',
      imageUrl: img,
      category: json['category'] ?? metadata['category'] ?? 'ANNOUNCEMENT',
      projectStatus: json['projectStatus'] ?? metadata['projectStatus'] ?? 'GENERAL',
      progressPercentage: (metadata['progressPercentage'] != null) 
          ? double.tryParse(metadata['progressPercentage'].toString()) ?? 0.0 
          : 0.0,
      isPinned: json['isPinned'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      publishedAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      milestones: miles,
      partnerName: metadata['partnerName'],
    );
  }

  bool get isFieldProject {
    const fieldCategories = {
      'HERITAGE',
      'PROJECT',
      'RESTORATION',
      'CULTURAL',
      'SCIENTIFIC',
      'ARTISTIC',
      'MEMORY',
      'TOURISM',
      'CHILD',
    };
    return fieldCategories.contains(category.toUpperCase());
  }

  bool get isInstitutionalNews {
    const institutionalCategories = {
      'ANNOUNCEMENT',
      'PARTNERSHIP',
      'PRESS_RELEASE',
      'EVENT_REPORT',
    };
    return institutionalCategories.contains(category.toUpperCase());
  }

  String getTitle(String lang) {
    if (lang == 'ar') return titleAr;
    if (lang == 'fr' && titleFr.isNotEmpty) return titleFr;
    return titleEn;
  }

  String getSummary(String lang) {
    if (lang == 'ar') return summaryAr;
    if (lang == 'fr' && summaryFr.isNotEmpty) return summaryFr;
    return summaryEn;
  }

  String getBody(String lang) {
    if (lang == 'ar') return bodyAr;
    if (lang == 'fr' && bodyFr.isNotEmpty) return bodyFr;
    return bodyEn;
  }
}
