import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق إبزيم'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك'**
  String get welcome;

  /// No description provided for @splashTitle.
  ///
  /// In ar, this message translates to:
  /// **'جمعية إبزيم للثقافة والمواطنة'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'Association Ebzim pour la Culture et la Citoyenneté'**
  String get splashSubtitle;

  /// No description provided for @splashCaption.
  ///
  /// In ar, this message translates to:
  /// **'سطيف • الجزائر • تأسست من أجل التراث'**
  String get splashCaption;

  /// No description provided for @splashAction.
  ///
  /// In ar, this message translates to:
  /// **'استكشف'**
  String get splashAction;

  /// No description provided for @langSub.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك • Welcome'**
  String get langSub;

  /// No description provided for @langTitle1.
  ///
  /// In ar, this message translates to:
  /// **'اختر اللغة'**
  String get langTitle1;

  /// No description provided for @langTitle2.
  ///
  /// In ar, this message translates to:
  /// **''**
  String get langTitle2;

  /// No description provided for @langDesc.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار لغتك المفضلة للمتابعة.'**
  String get langDesc;

  /// No description provided for @langContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get langContinue;

  /// No description provided for @langSecured.
  ///
  /// In ar, this message translates to:
  /// **'جمعية إبزيم'**
  String get langSecured;

  /// No description provided for @langAr.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get langAr;

  /// No description provided for @langEn.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get langEn;

  /// No description provided for @langFr.
  ///
  /// In ar, this message translates to:
  /// **'Français'**
  String get langFr;

  /// No description provided for @onboardingSkip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي إلى التراث'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get onboardingNext;

  /// No description provided for @onboardingBegin.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الرحلة'**
  String get onboardingBegin;

  /// No description provided for @onboardingDone.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get onboardingDone;

  /// No description provided for @onb1Tag.
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة التراث'**
  String get onb1Tag;

  /// No description provided for @onb1Title1.
  ///
  /// In ar, this message translates to:
  /// **'إرث من'**
  String get onb1Title1;

  /// No description provided for @onb1TitleHighlight.
  ///
  /// In ar, this message translates to:
  /// **'الثقافة'**
  String get onb1TitleHighlight;

  /// No description provided for @onb1Title2.
  ///
  /// In ar, this message translates to:
  /// **'والواجب.'**
  String get onb1Title2;

  /// No description provided for @onb1Desc.
  ///
  /// In ar, this message translates to:
  /// **'انضم إلى تجربة إبزيم لاكتشاف كنوز سطيف، حيث يلتقي الماضي بروح العصر.'**
  String get onb1Desc;

  /// No description provided for @onb2Tag.
  ///
  /// In ar, this message translates to:
  /// **'آفاق المعرفة'**
  String get onb2Tag;

  /// No description provided for @onb2Title.
  ///
  /// In ar, this message translates to:
  /// **'جسر رقمي نحو الحكمة الأصيلة'**
  String get onb2Title;

  /// No description provided for @onb2Desc.
  ///
  /// In ar, this message translates to:
  /// **'تمكين الوصول إلى الأرشيفات واللقاءات التي تشكل هويتنا الجماعية.'**
  String get onb2Desc;

  /// No description provided for @onb3Tag.
  ///
  /// In ar, this message translates to:
  /// **'مستقبل التراث'**
  String get onb3Tag;

  /// No description provided for @onb3Title.
  ///
  /// In ar, this message translates to:
  /// **'كن جزءاً من صون الذاكرة'**
  String get onb3Title;

  /// No description provided for @onb3Desc.
  ///
  /// In ar, this message translates to:
  /// **'مساهمتك اليوم تؤمن بقاء إرثنا الثقافي للأجيال القادمة.'**
  String get onb3Desc;

  /// No description provided for @authWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك'**
  String get authWelcome;

  /// No description provided for @authLocation.
  ///
  /// In ar, this message translates to:
  /// **'سطيف، الجزائر'**
  String get authLocation;

  /// No description provided for @authIdentity.
  ///
  /// In ar, this message translates to:
  /// **'الهوية'**
  String get authIdentity;

  /// No description provided for @authIdentityHint.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف أو البريد'**
  String get authIdentityHint;

  /// No description provided for @authSecret.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get authSecret;

  /// No description provided for @authLostCredentials.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get authLostCredentials;

  /// No description provided for @authPasswordHint.
  ///
  /// In ar, this message translates to:
  /// **'••••••••'**
  String get authPasswordHint;

  /// No description provided for @authAccessButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get authAccessButton;

  /// No description provided for @authErrorInvalid.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الدخول غير صحيحة. يرجى المحاولة مرة أخرى.'**
  String get authErrorInvalid;

  /// No description provided for @authErrorNoConnection.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت.'**
  String get authErrorNoConnection;

  /// No description provided for @authErrorUnknown.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.'**
  String get authErrorUnknown;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordDesc.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني المرتبط بحسابك لتلقي رمز التحقق الذي سيمكنك من تعيين كلمة مرور جديدة آمنة.'**
  String get authForgotPasswordDesc;

  /// No description provided for @authAssocName.
  ///
  /// In ar, this message translates to:
  /// **'جمعية إبزيم'**
  String get authAssocName;

  /// No description provided for @authGuestBrowse.
  ///
  /// In ar, this message translates to:
  /// **'تصفح كزائر ←'**
  String get authGuestBrowse;

  /// No description provided for @authBiometric.
  ///
  /// In ar, this message translates to:
  /// **'دخول آمن بالبصمة'**
  String get authBiometric;

  /// No description provided for @authNewHere.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت جديد في إبزيم؟'**
  String get authNewHere;

  /// No description provided for @authCreateAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب مستخدم'**
  String get authCreateAccount;

  /// No description provided for @authPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية'**
  String get authPrivacy;

  /// No description provided for @authTerms.
  ///
  /// In ar, this message translates to:
  /// **'الشروط'**
  String get authTerms;

  /// No description provided for @authPrivacyTitle.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get authPrivacyTitle;

  /// No description provided for @authTermsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الشروط والأحكام'**
  String get authTermsTitle;

  /// No description provided for @authResetPassword.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get authResetPassword;

  /// No description provided for @authResetPasswordDesc.
  ///
  /// In ar, this message translates to:
  /// **'قم بإدخال بيانات الاعتماد السرية الجديدة.'**
  String get authResetPasswordDesc;

  /// No description provided for @authEmailSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال التعليمات'**
  String get authEmailSent;

  /// No description provided for @authEmailSentDesc.
  ///
  /// In ar, this message translates to:
  /// **'يرجى التحقق من بريدك الإلكتروني لخطوات الاستعادة.'**
  String get authEmailSentDesc;

  /// No description provided for @authOtpTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من الهوية'**
  String get authOtpTitle;

  /// No description provided for @authOtpDesc.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز التحقق المرسل إلى بريدك الإلكتروني.'**
  String get authOtpDesc;

  /// No description provided for @authNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get authNewPassword;

  /// No description provided for @authConfirmNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get authConfirmNewPassword;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت إعادة تعيين كلمة المرور بنجاح'**
  String get authPasswordResetSuccess;

  /// No description provided for @regTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get regTitle;

  /// No description provided for @regSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك للوصول إلى خدمات المنصة ومتابعة أنشطتك بكل سهولة.'**
  String get regSubtitle;

  /// No description provided for @regMembershipNote.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب في المنصة لا يعني اكتساب العضوية الرسمية في الجمعية.'**
  String get regMembershipNote;

  /// No description provided for @regFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get regFullName;

  /// No description provided for @regFullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'عكرور توفيق'**
  String get regFullNameHint;

  /// No description provided for @regPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get regPhone;

  /// No description provided for @regPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'+213 50 XXX XXXX'**
  String get regPhoneHint;

  /// No description provided for @regEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get regEmail;

  /// No description provided for @regEmailHint.
  ///
  /// In ar, this message translates to:
  /// **'salim@example.com'**
  String get regEmailHint;

  /// No description provided for @regPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get regPassword;

  /// No description provided for @regConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get regConfirm;

  /// No description provided for @regLang.
  ///
  /// In ar, this message translates to:
  /// **'اللغة المفضلة'**
  String get regLang;

  /// No description provided for @regAction.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get regAction;

  /// No description provided for @regAlreadyHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك حساب بالفعل؟'**
  String get regAlreadyHaveAccount;

  /// No description provided for @regLogin.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get regLogin;

  /// No description provided for @regMembership.
  ///
  /// In ar, this message translates to:
  /// **'تقديم طلب انضمام خطي'**
  String get regMembership;

  /// No description provided for @valRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get valRequired;

  /// No description provided for @valEmail.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بريد إلكتروني صحيح'**
  String get valEmail;

  /// No description provided for @valPassword.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن لا تقل كلمة المرور عن 8 أحرف'**
  String get valPassword;

  /// No description provided for @valConfirm.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور غير متطابقة'**
  String get valConfirm;

  /// No description provided for @homeNavMain.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get homeNavMain;

  /// No description provided for @homeNavAbout.
  ///
  /// In ar, this message translates to:
  /// **'عن إبزيم'**
  String get homeNavAbout;

  /// No description provided for @homeNavActivities.
  ///
  /// In ar, this message translates to:
  /// **'الأنشطة'**
  String get homeNavActivities;

  /// No description provided for @homeWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحبا بكم في إبزيم'**
  String get homeWelcome;

  /// No description provided for @homeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الحفاظ على روح سطيف من خلال الحرف اليدوية، الحوار التاريخي، وحكمة تراثنا الصامتة.'**
  String get homeSubtitle;

  /// No description provided for @homeActionJoin.
  ///
  /// In ar, this message translates to:
  /// **'انضم إلينا'**
  String get homeActionJoin;

  /// No description provided for @homeActionExplore.
  ///
  /// In ar, this message translates to:
  /// **'استكشف الأرشيف'**
  String get homeActionExplore;

  /// No description provided for @homePillars.
  ///
  /// In ar, this message translates to:
  /// **'ركائزنا'**
  String get homePillars;

  /// No description provided for @homeWorkshopTitle.
  ///
  /// In ar, this message translates to:
  /// **'ورشات الحرف التقليدية'**
  String get homeWorkshopTitle;

  /// No description provided for @homeWorkshopDesc.
  ///
  /// In ar, this message translates to:
  /// **'أتقن حرف أجدادنا من خلال جلسات تطبيقية.'**
  String get homeWorkshopDesc;

  /// No description provided for @homeHistoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'حلقات تاريخ سطيف'**
  String get homeHistoryTitle;

  /// No description provided for @homeHistoryDesc.
  ///
  /// In ar, this message translates to:
  /// **'غوص عميق في التطور العمراني وتاريخ سطيف.'**
  String get homeHistoryDesc;

  /// No description provided for @homeUpcomingEvents.
  ///
  /// In ar, this message translates to:
  /// **'فعاليات قادمة'**
  String get homeUpcomingEvents;

  /// No description provided for @homeLatestHighlights.
  ///
  /// In ar, this message translates to:
  /// **'آخر المستجدات'**
  String get homeLatestHighlights;

  /// No description provided for @navDashboard.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navDashboard;

  /// No description provided for @navDirectory.
  ///
  /// In ar, this message translates to:
  /// **'أعضاء الجمعية'**
  String get navDirectory;

  /// No description provided for @navActivities.
  ///
  /// In ar, this message translates to:
  /// **'الأنشطة'**
  String get navActivities;

  /// No description provided for @navProfile.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navProfile;

  /// No description provided for @navNews.
  ///
  /// In ar, this message translates to:
  /// **'أخبار'**
  String get navNews;

  /// No description provided for @eventFeaturedBadge.
  ///
  /// In ar, this message translates to:
  /// **'فعالية مميزة'**
  String get eventFeaturedBadge;

  /// No description provided for @eventDetailsLink.
  ///
  /// In ar, this message translates to:
  /// **'عرض تفاصيل البرنامج'**
  String get eventDetailsLink;

  /// No description provided for @eventAboutGathering.
  ///
  /// In ar, this message translates to:
  /// **'حول هذا اللقاء'**
  String get eventAboutGathering;

  /// No description provided for @eventCuratedBy.
  ///
  /// In ar, this message translates to:
  /// **'إشراف'**
  String get eventCuratedBy;

  /// No description provided for @eventShare.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة الفعالية'**
  String get eventShare;

  /// No description provided for @eventCalendar.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إلى التقويم'**
  String get eventCalendar;

  /// No description provided for @eventVenue.
  ///
  /// In ar, this message translates to:
  /// **'المكان والموقع'**
  String get eventVenue;

  /// No description provided for @eventOpenMaps.
  ///
  /// In ar, this message translates to:
  /// **'فتح في الخرائط'**
  String get eventOpenMaps;

  /// No description provided for @eventDiscoverMore.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف المزيد'**
  String get eventDiscoverMore;

  /// No description provided for @eventRegister.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الحضور'**
  String get eventRegister;

  /// No description provided for @aboutHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'صون الموروث وتنمية الوعي الثقافي والوطني'**
  String get aboutHeroTitle;

  /// No description provided for @aboutHeroSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'جمعية إبزيم هي المساحة الولائية لتسخير المعارف والوسائل في سبيل حماية الهوية الجزائرية.'**
  String get aboutHeroSubtitle;

  /// No description provided for @aboutStoryBadge.
  ///
  /// In ar, this message translates to:
  /// **'عن الجمعية'**
  String get aboutStoryBadge;

  /// No description provided for @aboutStoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'إرث سطيف، هوية وطن'**
  String get aboutStoryTitle;

  /// No description provided for @aboutStoryText1.
  ///
  /// In ar, this message translates to:
  /// **'تأسست جمعية إبزيم بقرار من الجمعية العامة وحرصاً على حماية الكنوز المادية وغير الملموسة لولاية سطيف، لتعمل كجسر مؤسسي بين الأصالة والحداثة.'**
  String get aboutStoryText1;

  /// No description provided for @aboutStoryQuote.
  ///
  /// In ar, this message translates to:
  /// **'\"إبزيم ليست مجرد هيئة ثقافية، بل ميثاق تطوعي لصون الذاكرة والنهوض بالفعل الثقافي الهادف.\"'**
  String get aboutStoryQuote;

  /// No description provided for @aboutMission.
  ///
  /// In ar, this message translates to:
  /// **'مهمتنا في القانون الأساسي'**
  String get aboutMission;

  /// No description provided for @aboutMissionText.
  ///
  /// In ar, this message translates to:
  /// **'العمل على حماية المعالم التاريخية، توثيق التقنيات التراثية، وإدماج مفاهيم المواطنة من خلال العمل الثقافي الميداني.'**
  String get aboutMissionText;

  /// No description provided for @aboutVision.
  ///
  /// In ar, this message translates to:
  /// **'رؤيتنا الإستراتيجية'**
  String get aboutVision;

  /// No description provided for @aboutVisionText.
  ///
  /// In ar, this message translates to:
  /// **'أن تكون إبزيم النموذج المرجعي في حماية الموروث الثقافي والذاكرة الوطنية في شمال افريقيا.'**
  String get aboutVisionText;

  /// No description provided for @aboutValues.
  ///
  /// In ar, this message translates to:
  /// **'مبادئنا الأساسية'**
  String get aboutValues;

  /// No description provided for @aboutValue1.
  ///
  /// In ar, this message translates to:
  /// **'التطوع الواعي'**
  String get aboutValue1;

  /// No description provided for @aboutValue2.
  ///
  /// In ar, this message translates to:
  /// **'النزاهة المؤسسية'**
  String get aboutValue2;

  /// No description provided for @aboutValue3.
  ///
  /// In ar, this message translates to:
  /// **'الأصالة والهوية'**
  String get aboutValue3;

  /// No description provided for @aboutValue4.
  ///
  /// In ar, this message translates to:
  /// **'المواطنة الرقمية'**
  String get aboutValue4;

  /// No description provided for @aboutHqBadge.
  ///
  /// In ar, this message translates to:
  /// **'المقر الإداري'**
  String get aboutHqBadge;

  /// No description provided for @aboutHqTitle.
  ///
  /// In ar, this message translates to:
  /// **'قلب مدينة سطيف، الجزائر'**
  String get aboutHqTitle;

  /// No description provided for @aboutHqText.
  ///
  /// In ar, this message translates to:
  /// **'يقع المركز العملياتي للجمعية في النبض التاريخي لولاية سطيف، حيث يدار الفعل الثقافي ومبادرات حماية الذاكرة.'**
  String get aboutHqText;

  /// No description provided for @aboutHqAction1.
  ///
  /// In ar, this message translates to:
  /// **'خرائط الموقع'**
  String get aboutHqAction1;

  /// No description provided for @aboutHqAction2.
  ///
  /// In ar, this message translates to:
  /// **'تواصل معنا'**
  String get aboutHqAction2;

  /// No description provided for @aboutQuote.
  ///
  /// In ar, this message translates to:
  /// **'الفعل الثقافي هو البنية التحتية لهويتنا الوطنية. في كل رمز وفي كل تفصيل تاريخي نجد خارطة طريقنا نحو المستقبل.'**
  String get aboutQuote;

  /// No description provided for @aboutQuoteAuthor.
  ///
  /// In ar, this message translates to:
  /// **'المكتب التنفيذي لجمعية إبزيم'**
  String get aboutQuoteAuthor;

  /// No description provided for @actTitle.
  ///
  /// In ar, this message translates to:
  /// **'التقويم الثقافي'**
  String get actTitle;

  /// No description provided for @actSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف المبادرات، وورش العمل، والتجمعات التي تشكل مجتمع إبزيم.'**
  String get actSubtitle;

  /// No description provided for @actSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن فعاليات أو ورش عمل...'**
  String get actSearchHint;

  /// No description provided for @actCatAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get actCatAll;

  /// No description provided for @actCatWorkshops.
  ///
  /// In ar, this message translates to:
  /// **'ورش عمل'**
  String get actCatWorkshops;

  /// No description provided for @actCatEvents.
  ///
  /// In ar, this message translates to:
  /// **'فعاليات'**
  String get actCatEvents;

  /// No description provided for @actCatCampaigns.
  ///
  /// In ar, this message translates to:
  /// **'حملات'**
  String get actCatCampaigns;

  /// No description provided for @actCatYouth.
  ///
  /// In ar, this message translates to:
  /// **'الشباب'**
  String get actCatYouth;

  /// No description provided for @memStepper1.
  ///
  /// In ar, this message translates to:
  /// **'الهوية'**
  String get memStepper1;

  /// No description provided for @memStepper2.
  ///
  /// In ar, this message translates to:
  /// **'الاتصال'**
  String get memStepper2;

  /// No description provided for @memStepper3.
  ///
  /// In ar, this message translates to:
  /// **'الخبرة'**
  String get memStepper3;

  /// No description provided for @memStepper4.
  ///
  /// In ar, this message translates to:
  /// **'المراجعة'**
  String get memStepper4;

  /// No description provided for @memFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get memFullName;

  /// No description provided for @memDOB.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد'**
  String get memDOB;

  /// No description provided for @memGender.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get memGender;

  /// No description provided for @memMale.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get memMale;

  /// No description provided for @memFemale.
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get memFemale;

  /// No description provided for @memWilaya.
  ///
  /// In ar, this message translates to:
  /// **'الولاية'**
  String get memWilaya;

  /// No description provided for @memCommune.
  ///
  /// In ar, this message translates to:
  /// **'البلدية'**
  String get memCommune;

  /// No description provided for @memPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get memPhone;

  /// No description provided for @memPhoneHint.
  ///
  /// In ar, this message translates to:
  /// **'+213 XXX XX XX XX'**
  String get memPhoneHint;

  /// No description provided for @memInterests.
  ///
  /// In ar, this message translates to:
  /// **'مجالات الاهتمام'**
  String get memInterests;

  /// No description provided for @memMotivation.
  ///
  /// In ar, this message translates to:
  /// **'الدافع للانضمام'**
  String get memMotivation;

  /// No description provided for @memConsent.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على الشروط وسياسة الخصوصية لجمعية إبزيم.'**
  String get memConsent;

  /// No description provided for @memNext.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة التالية'**
  String get memNext;

  /// No description provided for @memBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get memBack;

  /// No description provided for @memSubmit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطلب'**
  String get memSubmit;

  /// No description provided for @memPrivacyNote.
  ///
  /// In ar, this message translates to:
  /// **'تتم معالجة معلوماتك والحفاظ عليها بشكل آمن وفقًا للمعايير الأرشيفية لجمعية إبزيم.'**
  String get memPrivacyNote;

  /// No description provided for @memSuccessTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم تقديم الطلب الخطي'**
  String get memSuccessTitle;

  /// No description provided for @memSuccessSub.
  ///
  /// In ar, this message translates to:
  /// **'طلبك قيد المراجعة من طرف المكتب التنفيذي'**
  String get memSuccessSub;

  /// No description provided for @memSuccessHome.
  ///
  /// In ar, this message translates to:
  /// **'العودة للرئيسية'**
  String get memSuccessHome;

  /// No description provided for @memStatusNone.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد طلب انضمام مسجل حالياً'**
  String get memStatusNone;

  /// No description provided for @memStatusSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'طلبك قيد المراجعة من طرف المكتب التنفيذي للجمعية'**
  String get memStatusSubmitted;

  /// No description provided for @memStatusNeedsInfo.
  ///
  /// In ar, this message translates to:
  /// **'طلب الانضمام يحتاج إلى معلومات إضافية من جانبكم'**
  String get memStatusNeedsInfo;

  /// No description provided for @memStatusApproved.
  ///
  /// In ar, this message translates to:
  /// **'تم قبول طلب الانضمام - أهلاً بك كأحد أعضاء الجمعية'**
  String get memStatusApproved;

  /// No description provided for @memStatusRejected.
  ///
  /// In ar, this message translates to:
  /// **'عذراً، لم يتم قبول طلب الانضمام في الوقت الحالي'**
  String get memStatusRejected;

  /// No description provided for @leadHeroBadge.
  ///
  /// In ar, this message translates to:
  /// **'القيادة والحوكمة'**
  String get leadHeroBadge;

  /// No description provided for @leadHeroTitle.
  ///
  /// In ar, this message translates to:
  /// **'رعاة تراثنا.'**
  String get leadHeroTitle;

  /// No description provided for @leadHeroSub.
  ///
  /// In ar, this message translates to:
  /// **'الحفاظ على إرث إبزيم من خلال الحكمة المؤسسية والإشراف الثقافي.'**
  String get leadHeroSub;

  /// No description provided for @leadSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث بالاسم أو المنصب...'**
  String get leadSearchHint;

  /// No description provided for @leadCatAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get leadCatAll;

  /// No description provided for @leadCatBoard.
  ///
  /// In ar, this message translates to:
  /// **'أعضاء المجلس'**
  String get leadCatBoard;

  /// No description provided for @leadCatExec.
  ///
  /// In ar, this message translates to:
  /// **'الإدارة التنفيذية'**
  String get leadCatExec;

  /// No description provided for @leadJoinTitle.
  ///
  /// In ar, this message translates to:
  /// **'مهتم بالانضمام إلى مجلسنا الاستشاري؟'**
  String get leadJoinTitle;

  /// No description provided for @leadJoinSub.
  ///
  /// In ar, this message translates to:
  /// **'نحن نبحث دائماً عن خبراء في التراث، التكنولوجيا، والأنثروبولوجيا الثقافية لتوجيه مهمتنا.'**
  String get leadJoinSub;

  /// No description provided for @leadJoinBtn.
  ///
  /// In ar, this message translates to:
  /// **'تقديم طلب الترشح'**
  String get leadJoinBtn;

  /// No description provided for @dashboardWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في منصة إبزيم، {name}'**
  String dashboardWelcome(Object name);

  /// No description provided for @dashboardWelcomePublic.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في منصة إبزيم، فضاء المواطنة والثقافة.'**
  String get dashboardWelcomePublic;

  /// No description provided for @dashboardWelcomeBack.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك مجدداً في رحاب إبزيم'**
  String get dashboardWelcomeBack;

  /// No description provided for @dashboardStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة العضوية'**
  String get dashboardStatus;

  /// No description provided for @dashboardValidUntil.
  ///
  /// In ar, this message translates to:
  /// **'صالح حتى'**
  String get dashboardValidUntil;

  /// No description provided for @dashboardQuickPay.
  ///
  /// In ar, this message translates to:
  /// **'دفع الرسوم'**
  String get dashboardQuickPay;

  /// No description provided for @dashboardQuickCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة الهوية'**
  String get dashboardQuickCard;

  /// No description provided for @dashboardQuickReg.
  ///
  /// In ar, this message translates to:
  /// **'نشاطاتنا'**
  String get dashboardQuickReg;

  /// No description provided for @dashboardProgress.
  ///
  /// In ar, this message translates to:
  /// **'إكمال الملف الشخصي'**
  String get dashboardProgress;

  /// No description provided for @dashboardProgressDesc.
  ///
  /// In ar, this message translates to:
  /// **'بوابة إبزيم: أكمل بياناتك الشخصية للوصول إلى ميزات المواطنة الكاملة.'**
  String get dashboardProgressDesc;

  /// No description provided for @dashboardUpcoming.
  ///
  /// In ar, this message translates to:
  /// **'الفعاليات القادمة'**
  String get dashboardUpcoming;

  /// No description provided for @dashboardBookmarked.
  ///
  /// In ar, this message translates to:
  /// **'العناصر المحفوظة'**
  String get dashboardBookmarked;

  /// No description provided for @dashLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get dashLoading;

  /// No description provided for @dashViewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get dashViewAll;

  /// No description provided for @dashJoinTitle.
  ///
  /// In ar, this message translates to:
  /// **'انضم لجمعية إبزيم'**
  String get dashJoinTitle;

  /// No description provided for @dashJoinDesc.
  ///
  /// In ar, this message translates to:
  /// **'ساهم في حماية تراثنا وتعزيز المواطنة الثقافية عبر طلب العضوية الرسمية الآن.'**
  String get dashJoinDesc;

  /// No description provided for @dashJoinAction.
  ///
  /// In ar, this message translates to:
  /// **'طلب الانخراط الآن'**
  String get dashJoinAction;

  /// No description provided for @dashPendingTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبك قيد المراجعة'**
  String get dashPendingTitle;

  /// No description provided for @dashPendingDesc.
  ///
  /// In ar, this message translates to:
  /// **'تتم مراجعة طلب انضمامك من قبل المكتب التنفيذي حالياً. سنخطرك فور تحديث الحالة.'**
  String get dashPendingDesc;

  /// No description provided for @dashMemberLevelPublic.
  ///
  /// In ar, this message translates to:
  /// **'حساب مستخدم (منصة إبزيم)'**
  String get dashMemberLevelPublic;

  /// No description provided for @dashMemberLevelMember.
  ///
  /// In ar, this message translates to:
  /// **'عضو رسمي بالجمعية'**
  String get dashMemberLevelMember;

  /// No description provided for @dashMemberLevelAdmin.
  ///
  /// In ar, this message translates to:
  /// **'مسؤول النظام (Admin)'**
  String get dashMemberLevelAdmin;

  /// No description provided for @dashMemberLevelSuperAdmin.
  ///
  /// In ar, this message translates to:
  /// **'المشرف العام (Super Admin)'**
  String get dashMemberLevelSuperAdmin;

  /// No description provided for @dashAccountStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الحساب'**
  String get dashAccountStatus;

  /// No description provided for @dashAccountActive.
  ///
  /// In ar, this message translates to:
  /// **'حساب نشط'**
  String get dashAccountActive;

  /// No description provided for @dashAccountNote.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه: إنشاء حساب في المنصة لا يعني اكتساب العضوية الرسمية في الجمعية.'**
  String get dashAccountNote;

  /// No description provided for @dashQuickProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get dashQuickProfile;

  /// No description provided for @dashNoEvents.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فعاليات مجدولة حالياً'**
  String get dashNoEvents;

  /// No description provided for @dashErrorData.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تحميل البيانات'**
  String get dashErrorData;

  /// No description provided for @dashPublicIntroTitle.
  ///
  /// In ar, this message translates to:
  /// **'البيت الرقمي لإبزيم'**
  String get dashPublicIntroTitle;

  /// No description provided for @dashPublicIntroDesc.
  ///
  /// In ar, this message translates to:
  /// **'فضاؤكم لاكتشاف النشاطات الثقافية، استكشاف مبادرات الجمعية، والتواصل مع الهوية المحلية لمدينة سطيف.'**
  String get dashPublicIntroDesc;

  /// No description provided for @dashQuickAbout.
  ///
  /// In ar, this message translates to:
  /// **'عن الجمعية'**
  String get dashQuickAbout;

  /// No description provided for @dashMembershipInvite.
  ///
  /// In ar, this message translates to:
  /// **'الانضمام إلى الجمعية'**
  String get dashMembershipInvite;

  /// No description provided for @dashMembershipLearnMore.
  ///
  /// In ar, this message translates to:
  /// **'اكتشف شروط العضوية والانتساب'**
  String get dashMembershipLearnMore;

  /// No description provided for @dashMembershipDiscover.
  ///
  /// In ar, this message translates to:
  /// **'مزايا العضوية الرسمية'**
  String get dashMembershipDiscover;

  /// No description provided for @dashStatusActive.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get dashStatusActive;

  /// No description provided for @dashPillar1.
  ///
  /// In ar, this message translates to:
  /// **'الثقافة والفنون'**
  String get dashPillar1;

  /// No description provided for @dashPillar2.
  ///
  /// In ar, this message translates to:
  /// **'التراث والذاكرة الوطنية'**
  String get dashPillar2;

  /// No description provided for @dashPillar3.
  ///
  /// In ar, this message translates to:
  /// **'المواطنة والمجتمع'**
  String get dashPillar3;

  /// No description provided for @cardTitle.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة العضوية'**
  String get cardTitle;

  /// No description provided for @cardFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get cardFullName;

  /// No description provided for @cardMemberId.
  ///
  /// In ar, this message translates to:
  /// **'الرقم التعريفي'**
  String get cardMemberId;

  /// No description provided for @cardIssueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإصدار'**
  String get cardIssueDate;

  /// No description provided for @cardExpiryDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء'**
  String get cardExpiryDate;

  /// No description provided for @cardScanMe.
  ///
  /// In ar, this message translates to:
  /// **'مسح ضوئي'**
  String get cardScanMe;

  /// No description provided for @profilePersonal.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get profilePersonal;

  /// No description provided for @profileContact.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل التواصل'**
  String get profileContact;

  /// No description provided for @profileEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get profilePhone;

  /// No description provided for @profileLang.
  ///
  /// In ar, this message translates to:
  /// **'تفضيلات اللغة'**
  String get profileLang;

  /// No description provided for @profileInterests.
  ///
  /// In ar, this message translates to:
  /// **'الاهتمامات الثقافية'**
  String get profileInterests;

  /// No description provided for @profileHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل المشاركات'**
  String get profileHistory;

  /// No description provided for @profileEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف الشخصي'**
  String get profileEdit;

  /// No description provided for @profileActiveSince.
  ///
  /// In ar, this message translates to:
  /// **'نشط منذ'**
  String get profileActiveSince;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات التطبيق'**
  String get settingsTitle;

  /// No description provided for @settingsLang.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLang;

  /// No description provided for @settingsTheme.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsTheme;

  /// No description provided for @settingsNotif.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get settingsNotif;

  /// No description provided for @settingsPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية والأمان'**
  String get settingsPrivacy;

  /// No description provided for @settingsHelp.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get settingsHelp;

  /// No description provided for @settingsAbout.
  ///
  /// In ar, this message translates to:
  /// **'حول إبزيم'**
  String get settingsAbout;

  /// No description provided for @settingsLogout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get settingsLogout;

  /// No description provided for @settingsDeleteAcc.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get settingsDeleteAcc;

  /// No description provided for @supportSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكننا خدمتك اليوم؟'**
  String get supportSubtitle;

  /// No description provided for @supportFaqTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأسئلة الشائعة'**
  String get supportFaqTitle;

  /// No description provided for @supportContactTitle.
  ///
  /// In ar, this message translates to:
  /// **'قنوات التواصل الرسمية'**
  String get supportContactTitle;

  /// No description provided for @supportEmailLabel.
  ///
  /// In ar, this message translates to:
  /// **'راسلنا بريدياً'**
  String get supportEmailLabel;

  /// No description provided for @supportLocationLabel.
  ///
  /// In ar, this message translates to:
  /// **'مقر الجمعية'**
  String get supportLocationLabel;

  /// No description provided for @supportPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'التواصل الهاتفي'**
  String get supportPhoneLabel;

  /// No description provided for @supportHqValue.
  ///
  /// In ar, this message translates to:
  /// **'ولاية سطيف، الجزائر'**
  String get supportHqValue;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @culturalCurator.
  ///
  /// In ar, this message translates to:
  /// **'قَيِّم ثقافي'**
  String get culturalCurator;

  /// No description provided for @ebzimBadge.
  ///
  /// In ar, this message translates to:
  /// **'شارة إبزيم'**
  String get ebzimBadge;

  /// No description provided for @noNotifs.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات هنا.'**
  String get noNotifs;

  /// No description provided for @notifTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifTitle;

  /// No description provided for @notifAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get notifAll;

  /// No description provided for @notifUnread.
  ///
  /// In ar, this message translates to:
  /// **'غير مقروءة'**
  String get notifUnread;

  /// No description provided for @notifUpdates.
  ///
  /// In ar, this message translates to:
  /// **'تحديثات'**
  String get notifUpdates;

  /// No description provided for @authAccountCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح!'**
  String get authAccountCreated;

  /// No description provided for @authLoginSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول بنجاح!'**
  String get authLoginSuccess;

  /// No description provided for @libTitle.
  ///
  /// In ar, this message translates to:
  /// **'المكتبة الرقمية'**
  String get libTitle;

  /// No description provided for @libSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'بحث في المنشورات والبحوث...'**
  String get libSearchHint;

  /// No description provided for @libCatArt.
  ///
  /// In ar, this message translates to:
  /// **'فنون وآثار'**
  String get libCatArt;

  /// No description provided for @libCatResearch.
  ///
  /// In ar, this message translates to:
  /// **'بحوث ودراسات'**
  String get libCatResearch;

  /// No description provided for @libCatReports.
  ///
  /// In ar, this message translates to:
  /// **'تقارير مؤسساتية'**
  String get libCatReports;

  /// No description provided for @libOpenPdf.
  ///
  /// In ar, this message translates to:
  /// **'فتح ملف PDF'**
  String get libOpenPdf;

  /// No description provided for @libSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص العمل'**
  String get libSummary;

  /// No description provided for @finTitle.
  ///
  /// In ar, this message translates to:
  /// **'المساهمات والاشتراكات'**
  String get finTitle;

  /// No description provided for @finJoinOptional.
  ///
  /// In ar, this message translates to:
  /// **'الانضمام كعضو رسمي (اختياري)'**
  String get finJoinOptional;

  /// No description provided for @finMembershipFee.
  ///
  /// In ar, this message translates to:
  /// **'قيمة الاشتراك'**
  String get finMembershipFee;

  /// No description provided for @finNeedsRenewal.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم التجديد'**
  String get finNeedsRenewal;

  /// No description provided for @finApplyJoin.
  ///
  /// In ar, this message translates to:
  /// **'تقديم طلب انضمام'**
  String get finApplyJoin;

  /// No description provided for @finRenewNow.
  ///
  /// In ar, this message translates to:
  /// **'تجديد الاشتراك الآن'**
  String get finRenewNow;

  /// No description provided for @finSupportProjects.
  ///
  /// In ar, this message translates to:
  /// **'دعم مشاريع الجمعية'**
  String get finSupportProjects;

  /// No description provided for @finChooseType.
  ///
  /// In ar, this message translates to:
  /// **'اختر نوع المساهمة:'**
  String get finChooseType;

  /// No description provided for @finGeneral.
  ///
  /// In ar, this message translates to:
  /// **'تبرع عام'**
  String get finGeneral;

  /// No description provided for @finProject.
  ///
  /// In ar, this message translates to:
  /// **'دعم مشروع'**
  String get finProject;

  /// No description provided for @finAmountLabel.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ (دج)'**
  String get finAmountLabel;

  /// No description provided for @finSend.
  ///
  /// In ar, this message translates to:
  /// **'إرسال المساهمة'**
  String get finSend;

  /// No description provided for @finJoinInvite.
  ///
  /// In ar, this message translates to:
  /// **'هل ترغب في الحصول على بطاقة انخراط رسمية والمشاركة في القرارات؟'**
  String get finJoinInvite;

  /// No description provided for @repTitle.
  ///
  /// In ar, this message translates to:
  /// **'البلاغات المدنية'**
  String get repTitle;

  /// No description provided for @repIncidentCat.
  ///
  /// In ar, this message translates to:
  /// **'صنف الحادثة'**
  String get repIncidentCat;

  /// No description provided for @repDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف الوضع الملاحظ'**
  String get repDescription;

  /// No description provided for @repLocation.
  ///
  /// In ar, this message translates to:
  /// **'الموقع الجغرافي'**
  String get repLocation;

  /// No description provided for @repSubmit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال البلاغ'**
  String get repSubmit;

  /// No description provided for @repSuccess.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لمساهمتك في حماية الموروث. سيتم مراجعة بلاغك فوراً.'**
  String get repSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
