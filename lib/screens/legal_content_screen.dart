import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

class LegalContentScreen extends ConsumerWidget {
  final String type; // 'privacy' or 'terms'

  const LegalContentScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider).languageCode;
    final isRtl = currentLocale == 'ar';
    
    final title = type == 'privacy' ? loc.authPrivacyTitle : loc.authTermsTitle;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: EbzimBackground(
        child: Column(
          children: [
            // Premium Header with Glass/Editorial look
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                        color: Colors.white70,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text(
                      'EBZIM | إبزيم',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 12,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                        fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balancing the back button
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Editorial Headline
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                        fontSize: 42,
                        height: 1.1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: isRtl ? FontStyle.normal : FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0E0C8).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Content Body following "The Cultural Curator" tone
                    _buildContent(context, type, currentLocale, loc, isRtl),
                    
                    const SizedBox(height: 80),
                    Center(
                      child: Text(
                        '© 2026 ASSOCIATION EBZIM',
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        isRtl ? 'آخر تحديث: أبريل 2026' : (currentLocale == 'fr' ? 'Dernière mise à jour : Avril 2026' : 'Last updated: April 2026'),
                        style: TextStyle(
                          fontFamily: isRtl ? 'Aref Ruqaa' : null,
                          color: Colors.white24,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, String type, String locale, AppLocalizations loc, bool isRtl) {
    // We utilize the "Archival/Educational" tone. 
    // Content is stylized with editorial subsections.
    
    final List<Map<String, String>> sections = type == 'privacy' 
      ? _getPrivacySections(locale) 
      : _getTermsSections(locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) => Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['title']!,
              style: TextStyle(
                color: const Color(0xFFF0E0C8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              section['body']!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 15,
                height: 1.8,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  List<Map<String, String>> _getPrivacySections(String locale) {
    if (locale == 'ar') {
      return [
        {'title': '1. مقدمة', 'body': 'نحن، جمعية إبزيم للثقافة والمواطنة (سطيف)، نلتزم بحماية خصوصيتك بشفافية، لتوفير بيئة رقمية آمنة تخدم أهدافنا الأرشيفية والثقافية بحتة.'},
        {'title': '2. نطاق التطبيق والخدمة', 'body': 'تسري هذه السياسة على كافة استخداماتك لمنصة إبزيم الرقمية. خدماتنا مخصصة للتفاعل الثقافي والأرشفة الرقمية ولا نهدف إلى أي استغلال تجاري للبيانات.'},
        {'title': '3. البيانات التي نجمعها', 'body': 'نقوم بجمع معلوماتك الأساسية بما في ذلك الاسم، البريد الإلكتروني، رقم الهاتف، وبيانات الاستخدام داخل المنصة والمساهمات الثقافية الخاصة بك.'},
        {'title': '4. كيفية استخدام البيانات', 'body': 'نستعمل بياناتك لإدارة الحساب الخاص بك، التواصل المباشر معك لحضور الفعاليات، تحسين خدمات التطبيق، وضمان التزامنا بالمتطلبات القانونية للجمعيات.'},
        {'title': '5. الأساس القانوني لتسجيل الموافقة', 'body': 'نستند في عملنا على موافقتك الصريحة عند التسجيل والتفاعل. تتماشى سياساتنا مع قانون حماية البيانات وقوانين الأرشيف الوطني.'},
        {'title': '6. مشاركة البيانات والإفصاح', 'body': 'نحن لا نقوم بأية مشاركة تجارية لبياناتك. تتم المشاركة فقط مع الأطراف التي يقتضيها القانون للحفاظ على المصلحة العامة، أو لضباط إنفاذ القانون بموجب استدعاء رسمي.'},
        {'title': '7. مدة الاحتفاظ بالبيانات', 'body': 'تبقى بياناتك المرجعية محفوظة طالما كان حسابك نشطاً لخدمة أهداف الجمعية. وتتم عملية الحذف وفقاً لمعايير صارمة ومتوافقة مع التشريعات المنظمة.'},
        {'title': '8. أمان المعلومات', 'body': 'نعتمد تقنيات التشفير المتقدمة لحماية بياناتك من الوصول غير المصرح به، ونراقب إجراءات الحماية بشكل دوري لضمان سلامة المنصة.'},
        {'title': '9. حقوق المستخدم', 'body': 'يُحفظ حقك الكامل في طلب الوصول إلى بياناتك الشخصية، تعديلها، تصحيحها، أو طلب الحذف وسحب الموافقة في أي وقت ومن دون شروط معقدة.'},
        {'title': '10. خصوصية القاصرين', 'body': 'لا يتم تصميم خدمات التطبيق لجمع بيانات القاصرين دون سن 18 عاماً دون إشراف وتفويض. ونقوم بحذف أية بيانات متعلقة بهم فور الإبلاغ أو العلم المستقل بذلك.'},
        {'title': '11. التحديثات على السياسة', 'body': 'ستتلقى إشعاراً واضحاً عبر المنصة أو البريد الإلكتروني عند اتخاذ أي تغيير جوهري على سياسة الخصوصية الخاصة بنا لضمان الشفافية المطلقة.'},
        {'title': '12. معلومات التواصل', 'body': 'لأي استفسار يخص هذه السياسة أو ممارسة حقوقك، يمكنك مراسلتنا دائماً عبر البريد الإلكتروني الرسمي: contact@ebzim.org أو زيارة مقر الجمعية.'},
      ];
    } else if (locale == 'fr') {
       return [
        {'title': '1. Introduction', 'body': 'Nous, Association Ebzim pour la Culture et la Citoyenneté (Sétif), nous engageons à protéger votre vie privée en toute transparence.'},
        {'title': '2. Portée de l\'Application', 'body': 'Cette politique s\'applique à toutes vos utilisations de la plateforme numérique Ebzim. Nos services sont dédiés à l\'interaction culturelle.'},
        {'title': '3. Données Collectées', 'body': 'Nous collectons uniquement les informations essentielles, y compris le nom, l\'e-mail, et les données d\'utilisation de la plateforme.'},
        {'title': '4. Utilisation des Données', 'body': 'Vos données sont utilisées pour gérer votre compte, communiquer directement avec vous et améliorer le service.'},
        {'title': '5. Base Juridique et Consentement', 'body': 'Nos opérations reposent sur votre consentement explicite. Nos politiques sont conformes à la législation nationale.'},
        {'title': '6. Partage des Données', 'body': 'Nous ne procédons à aucun partage commercial. Les données ne sont partagées que si la loi l\'exige.'},
        {'title': '7. Durée de Conservation', 'body': 'Vos données sont conservées tant que votre compte est actif et sert les objectifs de l\'association.'},
        {'title': '8. Sécurité des Informations', 'body': 'Nous utilisons des technologies de cryptage avancées pour protéger vos données contre tout accès non autorisé.'},
        {'title': '9. Droits des Utilisateurs', 'body': 'Vous avez le droit d\'accéder à vos informations, de les rectifier ou de demander leur suppression à tout moment.'},
        {'title': '10. Confidentialité des Mineurs', 'body': 'L\'application ne vise pas à collecter les données de mineurs de moins de 18 ans sans une supervision appropriée.'},
        {'title': '11. Mises à Jour de la Politique', 'body': 'Vous recevrez une notification explicite en cas de changement substantiel de cette politique.'},
        {'title': '12. Informations de Contact', 'body': 'Pour toute demande, vous pouvez toujours nous écrire à : contact@ebzim.org.'},
       ];
    } else {
       return [
        {'title': '1. Introduction', 'body': 'We, Association Ebzim for Culture and Citizenship (Setif), are committed to transparently protecting your privacy.'},
        {'title': '2. Scope and Service', 'body': 'This policy applies to all your interactions with the Ebzim digital platform, which is dedicated strictly to cultural interaction.'},
        {'title': '3. Data Collected', 'body': 'We collect only essential information, including name, email, and basic platform usage data.'},
        {'title': '4. How Data is Used', 'body': 'Your data is utilized to manage your account, communicate with you directly, and legally improve the service.'},
        {'title': '5. Legal Basis and Consent', 'body': 'We operate based on your explicit consent, and our policies align seamlessly with national archival and data protection laws.'},
        {'title': '6. Data Sharing and Disclosure', 'body': 'We strictly do not share data commercially. Disclosure is solely reserved for legally mandated circumstances.'},
        {'title': '7. Data Retention', 'body': 'Your reference data remains stored as long as your account is active and fulfills the association\'s cultural targets.'},
        {'title': '8. Information Security', 'body': 'We rely on advanced encryption techniques to safeguard your personal data from completely unauthorized access.'},
        {'title': '9. User Rights', 'body': 'You retain full rights to request access, rectification, or final deletion of your personal data at any given time.'},
        {'title': '10. Minors Privacy', 'body': 'The app services are not intended to collect data from minors under 18 without appropriate parental authorization.'},
        {'title': '11. Policy Updates', 'body': 'You will receive an immediate notification should we implement any substantial changes to our current privacy guidelines.'},
        {'title': '12. Contact Info', 'body': 'For any technical or operational inquiries, you can always reach out to us at: contact@ebzim.org.'},
       ];
    }
  }

  List<Map<String, String>> _getTermsSections(String locale) {
    if (locale == 'ar') {
      return [
        {'title': '1. مقدمة', 'body': 'مرحباً بكم في منصة إبزيم. تُدار هذه المنصة من قبل جمعية إبزيم للثقافة والمواطنة لولاية سطيف، وتهدف لتقديم محتوى ثقافي وأرشيفي رقمي تفاعلي.'},
        {'title': '2. قبول الشروط', 'body': 'بمجرد تسجيل الدخول واستخدامك لخدمات منصة إبزيم، فإنك توافق صراحة على الالتزام الكامل بجميع الشروط والأحكام الموضحة في هذه الوثيقة.'},
        {'title': '3. طبيعة المنصة ونطاق الاستخدام', 'body': 'هذه المنصة هي مساحة رقمية ثقافية وغير ربحية. تُستخدم لتعزيز التواصل الثقافي والأرشفة، ولا يُسمح باستخدامها لأي أغراض تجارية أو ربحية غير مصرح بها.'},
        {'title': '4. أهلية المستخدم', 'body': 'يجب أن يكون عمرك 18 عاماً أو أكثر لاستخدام المنصة بشكل مستقل. استخدام القاصرين يجب أن يكون تحت إشراف وتفويض مباشر من أولياء الأمور.'},
        {'title': '5. مسؤوليات الحساب', 'body': 'أنت مسؤول مسؤولية كاملة عن الحفاظ على سرية بياناتك. إن إنشاء الحساب يتيح لك التفاعل الرقمي، ولكنه لا يمنحك بأي شكل من الأشكال صفة "عضو رسمي" في الجمعية، حيث تخضع العضوية لقانوننا الأساسي بشكل مستقل.'},
        {'title': '6. الاستخدام المقبول', 'body': 'يُحظر تماماً استخدام المنصة لنشر محتوى مسيء، خطابات الكراهية، أو المساس بالثوابت الثقافية والرموز الوطنية، أو محاولة اختراق وإلحاق الضرر بالبنية التحتية للمنصة.'},
        {'title': '7. المحتوى والملكية الفكرية', 'body': 'كافة المواد الأرشيفية والتاريخية المعروضة هي ملكية فكرية حصرية لجمعية إبزيم أو المساهمين. يمنع نسخها أو توزيعها دون تصريح كتابي مسبق وإشارة للمصدر.'},
        {'title': '8. توفر الخدمة والتحديثات', 'body': 'نعمل جاهدين لضمان عمل المنصة، لكننا نحتفظ بالحق في إجراء صيانة قد تؤدي لتوقف الخدمة. لا توفر المنصة أي وظائف لتسجيل الدخول البيومتري أو عبر البصمة.'},
        {'title': '9. علاقة الخصوصية والشروط', 'body': 'تخضع طريقة جمعنا واستخدامنا لبياناتك لسياسة الخصوصية الخاصة بنا. استخدامك للمنصة يعني موافقتك على ممارسات الخصوصية المعتمدة لدينا لحماية بياناتك.'},
        {'title': '10. حدود المسؤولية', 'body': 'جمعية إبزيم غير مسؤولة عن أي أضرار مباشرة أو غير مباشرة تنتج عن عدم قدرتك على استخدام المنصة المتوقفة، أو عن استخدام غير مصرح به لحسابك.'},
        {'title': '11. تعليق أو إنهاء الخدمة', 'body': 'نحتفظ بالحق الكامل في تعليق أو حذف أي حساب يتبين انتهاكه لهذه الشروط والأحكام، أو يخالف القواعد السلوكية، دون أي تعويض.'},
        {'title': '12. القانون المنظم والامتثال', 'body': 'تخضع هذه الشروط والأحكام للقوانين والتشريعات الوطنية المعمول بها، وتُفسر أي نزاعات محتملة ضمن سياق الأطر القانونية للجمعيات.'},
        {'title': '13. معلومات التواصل', 'body': 'لأية استفسارات حول هذه الشروط وحقوقك كمستخدم، نرجو التواصل مع الإدارة الفنية أو مكتب الجمعية عبر البريد الإلكتروني: contact@ebzim.org.'},
      ];
    } else if (locale == 'fr') {
      return [
        {'title': '1. Introduction', 'body': 'Bienvenue sur la plateforme Ebzim. Gérée par l\'Association Ebzim pour la Culture et la Citoyenneté (Sétif), elle offre un contenu culturel et archivistique.'},
        {'title': '2. Acceptation des Conditions', 'body': 'En vous connectant et en utilisant nos services, vous acceptez d\'être pleinement lié par les conditions énoncées dans ce document.'},
        {'title': '3. Nature de la Plateforme', 'body': 'Cet espace est numérique, culturel et à but non lucratif. Toute utilisation à des fins commerciales non autorisées est strictement interdite.'},
        {'title': '4. Éligibilité', 'body': 'Vous devez avoir 18 ans ou plus. L\'utilisation par des mineurs requiert la supervision directe et l\'autorisation des parents.'},
        {'title': '5. Responsabilités du Compte', 'body': 'La création d\'un compte utilisateur ne signifie PAS que vous êtes un "Membre Officiel" de l\'association. L\'adhésion est régie par notre statut indépendant.'},
        {'title': '6. Utilisation Acceptable', 'body': 'Il est interdit de publier des contenus offensants, incitant à la haine, ou de porter atteinte aux symboles nationaux et aux valeurs culturelles.'},
        {'title': '7. Propriété Intellectuelle', 'body': 'Tous les documents historiques restent la propriété de l\'Association Ebzim. La reproduction est interdite sans consentement écrit.'},
        {'title': '8. Disponibilité et Modifications', 'body': 'Nous assurons la maintenance de la plateforme. La connexion biométrique n\'est pas une fonctionnalité approuvée ou active sur notre système.'},
        {'title': '9. Clause de Confidentialité', 'body': 'Notre utilisation de vos données est régie par notre Politique de Confidentialité. L\'utilisation de nos services implique votre consentement.'},
        {'title': '10. Limitation de Responsabilité', 'body': 'L\'association n\'est pas responsable des dommages directs ou indirects résultant de pannes de système ou d\'un accès non autorisé à votre compte.'},
        {'title': '11. Suspension et Résiliation', 'body': 'Nous nous réservons le droit de suspendre ou de supprimer tout compte violant ces conditions ou perturbant la plateforme, sans compensation.'},
        {'title': '12. Lois Applicables', 'body': 'Ces conditions sont régies par les lois nationales en vigueur pour les associations à but non lucratif.'},
        {'title': '13. Contact', 'body': 'Pour les questions relatives à ces conditions, veuillez nous contacter à l\'adresse suivante : contact@ebzim.org.'},
      ];
    } else {
      return [
        {'title': '1. Introduction', 'body': 'Welcome to the Ebzim platform. Managed by the Association Ebzim for Culture and Citizenship (Setif), it provides interactive digital cultural content.'},
        {'title': '2. Acceptance of Terms', 'body': 'By logging in and using our services, you explicitly agree to be fully bound by the terms and conditions outlined in this document.'},
        {'title': '3. Scope and Nature of Platform', 'body': 'This platform is a cultural, non-profit digital space. Any use for unauthorized commercial or profit-driven purposes is strictly prohibited.'},
        {'title': '4. User Eligibility', 'body': 'You must be 18 or older to use the platform independently. Minor usage requires direct parental authorization and supervision.'},
        {'title': '5. Account Responsibilities', 'body': 'Creating a user account does NOT mean official membership in the association. Official membership follows independent administrative procedures.'},
        {'title': '6. Acceptable Use', 'body': 'It is strictly forbidden to post offensive content, hate speech, attack national symbols, or compromise the technical infrastructure.'},
        {'title': '7. Intellectual Property', 'body': 'All historical and archival materials are the exclusive property of the Association Ebzim. Copying is forbidden without prior written consent.'},
        {'title': '8. Service Availability', 'body': 'We strive for continuous operation but may halt services for maintenance. Biometric login is not an approved functionality nor active on this app.'},
        {'title': '9. Privacy Relationship Clause', 'body': 'Our data practices are governed by our Privacy Policy. Your continued use affirms your agreement to these data protection standards.'},
        {'title': '10. Limitation of Liability', 'body': 'Association Ebzim is not liable for indirect damages resulting from service outages or unauthorized access to your personal account.'},
        {'title': '11. Suspension or Termination', 'body': 'We reserve the absolute right to suspend or terminate any account violating these conditions or behavioral rules without compensation.'},
        {'title': '12. Governing Law', 'body': 'These terms and conditions are governed by and construed in accordance with applicable national laws for non-profit associations.'},
        {'title': '13. Contact Information', 'body': 'For any technical inquiries regarding these terms, please contact the Ebzim office via email at: contact@ebzim.org.'},
      ];
    }
  }
}
