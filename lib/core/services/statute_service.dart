import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/models/statute_article.dart';

final statuteServiceProvider = Provider<StatuteService>(
  (ref) => StatuteService(),
);

class StatuteService {
  List<StatuteArticle> getStatutes() {
    return [
      // ── SECTION 1: FOUNDATIONS ──────────────────────────────────────────────
      const StatuteArticle(
        number: 1,
        titleAr: 'تأسيس الجمعية',
        titleEn: 'Founding of the Association',
        titleFr: 'Fondation de l\'Association',
        contentAr:
            'يؤلف الموقعون أدناه جمعية تخضع لأحكام القانون رقم 06/12 المؤرخ في سنة 2012، وهذا القانون الأساسي.',
        contentEn:
            'The association is established under Law No. 06/12 of 2012 and these statutes.',
        contentFr:
            'L\'association est établie selon la loi n° 06/12 de 2012 et les présents statuts.',
        sectionLabelAr: 'أحكام عامة',
        sectionLabelEn: 'General Provisions',
        sectionLabelFr: 'Dispositions Générales',
      ),
      const StatuteArticle(
        number: 2,
        titleAr: 'التسمية و الطابع',
        titleEn: 'Name and Character',
        titleFr: 'Dénomination et Caractère',
        contentAr:
            'تسمى الجمعية "جمعية إبزيم للثقافة والمواطنة". وهي جمعية ولائية بسطيف ذات طابع ثقافي واجتماعي غير مربح.',
        contentEn:
            'Named "Ebzim Association for Culture and Citizenship". It is a non-profit cultural association based in Sétif.',
        contentFr:
            'Nommée "Association Ebzim pour la Culture et la Citoyenneté". C\'est une association culturelle à but non lucratif basée à Sétif.',
        sectionLabelAr: 'أحكام عامة',
        sectionLabelEn: 'General Provisions',
        sectionLabelFr: 'Dispositions Générales',
      ),

      // ── SECTION 2: GOALS ──────────────────────────────────────────────────
      const StatuteArticle(
        number: 4,
        titleAr: 'الأهداف الاستراتيجية',
        titleEn: 'Strategic Goals',
        titleFr: 'Objectifs Stratégiques',
        contentAr:
            'تهدف الجمعية إلى حماية الموروث الثقافي المادي واللامادي، تعزيز روح المواطنة، ترميم المعالم التاريخية، وتطوير السياحة الثقافية بالشراكة مع الجامعات واليونسكو.',
        contentEn:
            'Protecting tangible and intangible heritage, fostering citizenship, restoring historical monuments, and developing cultural tourism in partnership with universities and UNESCO.',
        contentFr:
            'Protéger le patrimoine matériel et immatériel, promouvoir la citoyenneté, restaurer les monuments historiques et développer le tourisme culturel en partenariat avec les universités et l\'UNESCO.',
        sectionLabelAr: 'الأهداف',
        sectionLabelEn: 'Strategic Goals',
        sectionLabelFr: 'Objectifs Stratégiques',
      ),

      // ── SECTION 3: MEMBERSHIP ─────────────────────────────────────────────
      const StatuteArticle(
        number: 10,
        titleAr: 'شروط الانخراط',
        titleEn: 'Membership Conditions',
        titleFr: 'Conditions d\'Adhésion',
        contentAr:
            'يجب أن يكون العضو ناشطاً في المجال الاجتماعي، ممارساً أو مهتماً بالفنون، وملتزماً بعدم ممارسة أي نشاط يتعارض مع مصالح الأمة الجزائرية.',
        contentEn:
            'Members must be socially active, involved in arts, and committed to never acting against Algerian national interests.',
        contentFr:
            'Les membres doivent être socialement actifs, impliqués dans les arts et s\'engager à ne jamais agir contre les intérêts nationaux algériens.',
        sectionLabelAr: 'العضوية',
        sectionLabelEn: 'Membership',
        sectionLabelFr: 'Adhésion',
      ),

      // ── SECTION 4: STRUCTURE ──────────────────────────────────────────────
      const StatuteArticle(
        number: 23,
        titleAr: 'اللجان الدائمة',
        titleEn: 'Permanent Committees',
        titleFr: 'Commissions Permanentes',
        contentAr:
            'تضم الجمعية لجاناً متخصصة: لجنة التراث، لجنة الطفل، لجنة السياحة الثقافية، لجنة البحث العلمي، ولجنة الذاكرة والثورة التحريرية.',
        contentEn:
            'Specialized committees for: Heritage, Children, Cultural Tourism, Scientific Research, and National Memory.',
        contentFr:
            'Commissions spécialisées : Patrimoine, Enfance, Tourisme Culturel, Recherche Scientifique et Mémoire Nationale.',
        sectionLabelAr: 'التنظيم',
        sectionLabelEn: 'Organization',
        sectionLabelFr: 'Organisation',
      ),

      // ── SECTION 5: LEADERSHIP ─────────────────────────────────────────────
      const StatuteArticle(
        number: 24,
        titleAr: 'المكتب التنفيذي',
        titleEn: 'Executive Board',
        titleFr: 'Bureau Exécutif',
        contentAr:
            'يقود الجمعية مكتب تنفيذي مكون من 9 أعضاء (رئيس، كاتب عام، أمين مال، ونواب ومساعدون)، يصادق عليهم أعضاء الجمعية العامة.',
        contentEn:
            'Managed by a 9-member executive board (President, Secretary, Treasurer, and assistants), ratified by the General Assembly.',
        contentFr:
            'Gérée par un bureau exécutif de 9 membres (Président, Secrétaire, Trésorier et adjoints), ratifié par l\'Assemblée Générale.',
        sectionLabelAr: 'القيادة',
        sectionLabelEn: 'Leadership',
        sectionLabelFr: 'Direction',
      ),
    ];
  }

  /// Real names data for Leadership and About screens
  List<Map<String, String>> getExecutiveBoardNames() {
    return [
      {
        'nameAr': 'عصماني سعاد',
        'nameEn': 'Osmâni Souad',
        'roleAr': 'رئيس الجمعية',
        'roleEn': 'President',
        'roleFr': 'Président',
      },
      {
        'nameAr': 'ادريس قديح',
        'nameEn': 'Driss Guédih',
        'roleAr': 'نائب أول للرئيس',
        'roleEn': 'First Vice President',
        'roleFr': '1er Vice-Président',
      },
      {
        'nameAr': 'دباش جمال الدين',
        'nameEn': 'Debache Djamel Eddine',
        'roleAr': 'نائب ثاني للرئيس',
        'roleEn': 'Second Vice President',
        'roleFr': '2ème Vice-Président',
      },
      {
        'nameAr': 'بوعظم صلاح الدين',
        'nameEn': 'Bouâzam Salah Eddine',
        'roleAr': 'الكاتب العام',
        'roleEn': 'General Secretary',
        'roleFr': 'Secrétaire Général',
      },
      {
        'nameAr': 'سويسي خليصة',
        'nameEn': 'Souici Khelissa',
        'roleAr': 'مساعد الكاتب العام',
        'roleEn': 'Assistant Secretary',
        'roleFr': 'Secrétaire Adjoint',
      },
      {
        'nameAr': 'بوعظم ياسين',
        'nameEn': 'Bouâzam Yacine',
        'roleAr': 'أمين المال',
        'roleEn': 'Treasurer',
        'roleFr': 'Trésorier',
      },
      {
        'nameAr': 'بن سديرة علي',
        'nameEn': 'Ben Sedira Ali',
        'roleAr': 'مساعد أمين المال',
        'roleEn': 'Assistant Treasurer',
        'roleFr': 'Trésorier Adjoint',
      },
      {
        'nameAr': 'سعادنة نعيمة',
        'nameEn': 'Saâdena Naïma',
        'roleAr': 'عضو مساعد',
        'roleEn': 'Assistant Member',
        'roleFr': 'Membre Adjoint',
      },
      {
        'nameAr': 'نشادي أحمد',
        'nameEn': 'Nechadi Ahmed',
        'roleAr': 'عضو مساعد',
        'roleEn': 'Assistant Member',
        'roleFr': 'Membre Adjoint',
      },
    ];
  }
}
