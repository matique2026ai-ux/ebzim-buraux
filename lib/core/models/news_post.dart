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
    // Supportive parsing for different backend naming conventions
    final title = json['title'] is Map ? json['title'] : {};
    return ProjectMilestone(
      titleAr: json['titleAr'] ?? title['ar'] ?? '',
      titleEn: json['titleEn'] ?? title['en'] ?? '',
      titleFr: json['titleFr'] ?? title['fr'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date'].toString()) : DateTime.now(),
      isCompleted: json['isCompleted'] ?? json['completed'] ?? false,
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
  final String contentType;
  final String newsType;
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
    this.contentType = 'NEWS',
    this.newsType = 'NORMAL',
    this.projectStatus = 'GENERAL',
    this.progressPercentage = 0.0,
    this.isPinned = false,
    this.isFeatured = false,
    required this.publishedAt,
    this.milestones = const [],
    this.partnerName,
    this.latitude,
    this.longitude,
  });

  final double? latitude;
  final double? longitude;

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
    
    // Fallback for flattened responses
    if (img.isEmpty && json['imageUrl'] != null) {
      img = json['imageUrl'].toString().trim();
    }
    
    img = img.trim();

    // Use the normalized fields from backend (v1.3.0) with robust fallbacks
    final progress = json['progressPercentage'] ?? metadata['progressPercentage'] ?? metadata['progress'] ?? 0.0;
    final milestonesJson = json['milestones'] ?? metadata['milestones'] ?? [];
    
    List<ProjectMilestone> miles = [];
    if (milestonesJson is List) {
      miles = milestonesJson
          .map((m) => ProjectMilestone.fromJson(m as Map<String, dynamic>))
          .toList();
    }

    double finalProgress = 0.0;
    try {
      finalProgress = double.parse(progress.toString());
      // Standardize: If backend sends 85, convert to 0.85 for the UI sliders
      if (finalProgress > 1.0) finalProgress = finalProgress / 100.0;
    } catch (_) {
      finalProgress = 0.0;
    }

    return NewsPost(
      id: json['_id'] ?? json['id'] ?? '',
      titleAr: title['ar'] ?? json['titleAr'] ?? '',
      titleEn: title['en'] ?? json['titleEn'] ?? '',
      titleFr: title['fr'] ?? json['titleFr'] ?? '',
      summaryAr: summary['ar'] ?? json['summaryAr'] ?? '',
      summaryEn: summary['en'] ?? json['summaryEn'] ?? '',
      summaryFr: summary['fr'] ?? json['summaryFr'] ?? '',
      bodyAr: content['ar'] ?? json['bodyAr'] ?? '',
      bodyEn: content['en'] ?? json['bodyEn'] ?? '',
      bodyFr: content['fr'] ?? json['bodyFr'] ?? '',
      imageUrl: img,
      category: json['category'] ?? metadata['category'] ?? 'PROJECT',
      contentType: json['contentType'] ?? 'NEWS',
      newsType: json['newsType'] ?? 'NORMAL',
      projectStatus: json['projectStatus'] ?? metadata['projectStatus'] ?? 'GENERAL',
      progressPercentage: finalProgress,
      isPinned: json['isPinned'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt'].toString()) : 
                  (json['createdAt'] != null ? DateTime.parse(json['createdAt'].toString()) : DateTime.now()),
      milestones: miles,
      partnerName: metadata['partnerName'] ?? json['partnerName'],
      latitude: metadata['latitude'] != null ? double.tryParse(metadata['latitude'].toString()) : null,
      longitude: metadata['longitude'] != null ? double.tryParse(metadata['longitude'].toString()) : null,
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
      'ASSOCIATIVE',
      'SOCIAL',
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
