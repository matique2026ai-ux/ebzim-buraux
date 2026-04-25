import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/models/publication.dart';

class PublicationService {
  List<Publication> getPublications() {
    return [
      Publication(
        id: '1',
        titleAr: 'دليل المواقع الأثرية في سطيف',
        titleEn: 'Archaeological Sites Guide in Setif',
        titleFr: 'Guide des sites archéologiques de Sétif',
        authorAr: 'د. جمال الدين دباش',
        authorEn: 'Dr. Djamel Eddine Debache',
        authorFr: 'Dr. Djamel Eddine Debache',
        summaryAr:
            'دراسة شاملة للمواقع الرومانية والبيزنطية في ولاية سطيف مع خرائط تفصيلية.',
        summaryEn:
            'A comprehensive study of Roman and Byzantine sites in Setif with detailed maps.',
        summaryFr:
            'Une étude complète des sites romains et byzantins à Sétif avec des cartes détaillées.',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1544006659-f0b21f04cb1d?q=80&w=800',
        pdfUrl:
            'https://www.unesco.org/en/articles/algeria-heritage-guide-example.pdf',
        category: PublicationCategory.heritage,
        publishedDate: DateTime(2023, 5, 20),
      ),
      Publication(
        id: '2',
        titleAr: 'المواطنة الرقمية والمجتمع المدني',
        titleEn: 'Digital Citizenship & Civil Society',
        titleFr: 'Citoyenneté numérique et société civile',
        authorAr: 'عصماني سعاد',
        authorEn: 'Souad Osmane',
        authorFr: 'Souad Osmane',
        summaryAr:
            'بحث حول آليات تفعيل دور المجتمع المدني في الرقابة الرقمية والمواطنة الفاعلة.',
        summaryEn:
            'Research on mechanisms to activate the role of civil society in digital monitoring.',
        summaryFr:
            'Recherche sur les mécanismes d\'activation du rôle de la société civile.',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?q=80&w=800',
        pdfUrl: 'https://www.example.com/research/digital-citizenship.pdf',
        category: PublicationCategory.research,
        publishedDate: DateTime(2024, 1, 15),
      ),
      Publication(
        id: '3',
        titleAr: 'التقرير السنوي لإبزيم 2024',
        titleEn: 'Ebzim Annual Report 2024',
        titleFr: 'Rapport Annuel Ebzim 2024',
        authorAr: 'المكتب التنفيذي',
        authorEn: 'Executive Board',
        authorFr: 'Bureau Exécutif',
        summaryAr:
            'حصيلة نشاطات جمعية إبزيم للسنة المالية 2024 والمشاريع المنجزة.',
        summaryEn:
            'Summary of Ebzim Association activities for 2024 and completed projects.',
        summaryFr:
            'Bilan des activités de l\'association Ebzim pour l\'année 2024.',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=800',
        pdfUrl: 'https://www.example.com/reports/2024-annual.pdf',
        category: PublicationCategory.reports,
        publishedDate: DateTime(2024, 12, 30),
      ),
      Publication(
        id: '4',
        titleAr: 'تاريخ الثكنة العسكرية بالحامة',
        titleEn: 'History of El Hamman Military Barracks',
        titleFr: 'Histoire de la Caserne d\'El Hamman',
        authorAr: 'بن سديرة علي',
        authorEn: 'Ben Sedira Ali',
        authorFr: 'Ben Sedira Ali',
        summaryAr:
            'دراسة تاريخية معمارية للثكنة العسكرية القديمة في الحامة وأهميتها التراثية.',
        summaryEn:
            'Historical and architectural study of the old military barracks in El Hamman.',
        summaryFr:
            'Étude historique et architecturale de l\'ancienne caserne d\'El Hamman.',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1516455590571-182363198889?q=80&w=800',
        pdfUrl: 'https://www.example.com/history/hamman-barracks.pdf',
        category: PublicationCategory.history,
        publishedDate: DateTime(2022, 11, 10),
      ),
    ];
  }
}

final publicationServiceProvider = Provider((ref) => PublicationService());
