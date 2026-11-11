// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get hello => 'مرحبا';

  @override
  String get chooseLanguage => 'اختر لغتك';

  @override
  String get chooseLanguageSubtitle => 'يمكنك تغيير اللغة لاحقًا من الإعدادات';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get arabicSubtitle => 'Arabic';

  @override
  String get englishLanguage => 'English';

  @override
  String get englishSubtitle => 'الإنجليزية';

  @override
  String get continueButton => 'متابعة';

  @override
  String get skip => 'تخطي';

  @override
  String get skipAll => 'تخطي الكل';

  @override
  String get next => 'التالي';

  @override
  String get deleteDownloadConfirm =>
      'هل أنت متأكد من رغبتك في حذف هذا الكتاب؟';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get quranFehres => 'فهرس القرآن';

  @override
  String get onboardingSlide1Subtitle => 'مواقيت دقيقة لكل صلاة';

  @override
  String get onboardingSlide1Title => 'صلاتك في وقتها';

  @override
  String get onboardingSlide1Desc =>
      'نوفر لك مواقيت الصلاة الدقيقة بحسب موقعك الجغرافي، مع إشعارات تذكرك بكل صلاة في وقتها.';

  @override
  String get onboardingSlide2Subtitle => 'اقرأ وسبّح في أي وقت';

  @override
  String get onboardingSlide2Title => 'القرآن والأذكار معك دائمًا';

  @override
  String get onboardingSlide2Desc =>
      'تصفّح القرآن الكريم بتجربة قراءة هادئة، وأدِّ أذكار الصباح والمساء مع عداد تفاعلي.';

  @override
  String get onboardingSlide3Subtitle => 'ميزة المؤمن الذكية';

  @override
  String get onboardingSlide3Title => 'حچتي';

  @override
  String get onboardingSlide3Desc =>
      'عند اتصال أحدهم بك أثناء الصلاة، يُرسَل له تلقائيًا: \"حچتي\" — لأن وقت الصلاة مقدّس.';

  @override
  String get onboardingSlide4Subtitle => 'التقويم الهجري والمناسبات';

  @override
  String get onboardingSlide4Title => 'ابقَ قريبًا من مناسباتك الدينية';

  @override
  String get onboardingSlide4Desc =>
      'تابع المناسبات الإسلامية وأيام الصيام وإمساكية رمضان، مع إشعارات تذكّرك قبل كل مناسبة.';

  @override
  String get homeLocation => 'القاهرة، مصر';

  @override
  String get homeGregorianDate => 'السبت، 16 أغسطس 2026';

  @override
  String get homeHijriDate => '18 محرم 1447 هـ';

  @override
  String get nextPrayerTitle => 'الصلاة القادمة';

  @override
  String get nextPrayerRemaining => 'متبقى على الصلاة';

  @override
  String upcomingOccasionBanner(Object days, Object title) {
    return 'المناسبة القادمة: $title — متبقى $days يوم';
  }

  @override
  String get prayerTimesSectionTitle => 'مواقيت الصلاة';

  @override
  String get details => 'التفاصيل';

  @override
  String get currentPrayerBadge => 'الصلاة الحالية';

  @override
  String get nextPrayerBadge => 'الصلاة القادمة';

  @override
  String get fajr => 'الفجر';

  @override
  String get dhuhr => 'الظهر';

  @override
  String get asr => 'العصر';

  @override
  String get maghrib => 'المغرب';

  @override
  String get isha => 'العشاء';

  @override
  String get quickAccess => 'الوصول السريع';

  @override
  String get quranKareem => 'القرآن الكريم';

  @override
  String get continueReading => 'متابعة القراءة';

  @override
  String get quranStatsSubtitle => '114 سورة - 30 جزء - 60 حزب';

  @override
  String get searchSurahHint => 'ابحث عن سورة...';

  @override
  String get surahsListTitle => 'قائمة السور';

  @override
  String get surahBaqarah => 'سورة البقرة';

  @override
  String ayahNumber(Object number) {
    return 'الآية $number';
  }

  @override
  String ayahCountText(Object count) {
    return '$count آية';
  }

  @override
  String get meccanType => 'مكية';

  @override
  String get medinanType => 'مدنية';

  @override
  String get athkar => 'الأذكار';

  @override
  String get morningAthkar => 'أذكار الصباح';

  @override
  String get eveningAthkar => 'أذكار المساء';

  @override
  String get sleepAthkar => 'أذكار قبل النوم';

  @override
  String get afterPrayerAthkar => 'أذكار بعد الصلاة';

  @override
  String get miscAthkar => 'أذكار متنوعة';

  @override
  String get electronicSebha => 'السبحة الإلكترونية';

  @override
  String get sebhaSubtitle => 'عداد إلكتروني للتسبيح والذكر الحر';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get salatAlIstikhara => 'صلاة الإستخارة';

  @override
  String get athkarSubtitle => 'أذكار يومية للمسلم';

  @override
  String countThikr(Object count) {
    return '$count ذكر';
  }

  @override
  String get requiredLabel => 'المطلوب';

  @override
  String timesUnit(Object count) {
    return '$count مرة';
  }

  @override
  String get tapLabel => 'اضغط';

  @override
  String get istikharaStepsTitle => 'خطوات الصلاة';

  @override
  String get istikharaDuaTitle => 'الدعاء بعد الصلاة:';

  @override
  String get occasions => 'المناسبات';

  @override
  String get occasionsTitle => 'المناسبات الإسلامية';

  @override
  String get occasionsSubtitle => 'التقويم الهجري والمناسبات الدينية';

  @override
  String get tabOccasions => 'المناسبات';

  @override
  String get tabCalendar => 'التقويم';

  @override
  String get tabRamadan => 'رمضان';

  @override
  String get upcomingOccasion => 'المناسبة القادمة';

  @override
  String get upcomingOccasionsList => 'المناسبات القادمة';

  @override
  String get prophetBirthday => 'المولد النبوي';

  @override
  String get eidAlAdha => 'عيد الأضحى';

  @override
  String get hijriNewYear => 'رأس السنة الهجرية';

  @override
  String get ashura => 'عاشوراء';

  @override
  String daysRemainingUnit(Object count) {
    return '$count يوم';
  }

  @override
  String daysRemainingText(Object count) {
    return 'متبقى $count أيام';
  }

  @override
  String get hijriCalendarTitle => 'التقويم الهجري';

  @override
  String get gregorianCalendarTitle => 'التقويم الميلادي';

  @override
  String get today => 'اليوم';

  @override
  String get returnToToday => 'العودة لليوم';

  @override
  String get ramadanKareem => 'رمضان كريم';

  @override
  String get ramadanDay1Title => 'اليوم 1 من رمضان';

  @override
  String get ramadanDay1Date => '1 رمضان 1448 هـ';

  @override
  String get remainingOnRamadan => 'متبقى على رمضان';

  @override
  String get ramadanImsakiya => 'إمساكية رمضان';

  @override
  String get dayColumn => 'اليوم';

  @override
  String hijriYearLabel(Object year) {
    return '$year هـ';
  }

  @override
  String get occasionDetailsTitle => 'تفاصيل المناسبة';

  @override
  String get hijriDateLabel => 'التاريخ الهجري';

  @override
  String get gregorianDateLabel => 'التاريخ الميلادي';

  @override
  String get aboutOccasionLabel => 'عن المناسبة';

  @override
  String get aboutProphetBirthdayDesc =>
      'المولد النبوى هو يوم مولد النبي محمد صلى الله عليه وسلم';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get locationAndGovSection => 'الموقع والمحافظة';

  @override
  String get currentLocationLabel => 'الموقع الحالي';

  @override
  String get governorateLabel => 'المحافظة';

  @override
  String get cairoLocation => 'القاهرة، مصر';

  @override
  String get cairoGov => 'القاهرة';

  @override
  String get prayerTimesAndAdhanSection => 'مواقيت الصلاة والأذان';

  @override
  String get prayerTimesCalcSettings => 'إعدادات مواقيت الصلاة والأذان';

  @override
  String get egyptSurveyAuthority => 'الهيئة المصرية العامة للمساحة';

  @override
  String get notificationTypeLabel => 'نوع التنبيه';

  @override
  String get prayerAlertsLabel => 'تنبيهات الصلاة';

  @override
  String get notificationsSection => 'الإشعارات';

  @override
  String get generalNotificationsLabel => 'الإشعارات العامة';

  @override
  String get occasionsNotificationsLabel => 'إشعارات المناسبات';

  @override
  String get athkarNotificationsLabel => 'إشعارات الأذكار';

  @override
  String get fontSection => 'الخط';

  @override
  String get fontSizeLabel => 'حجم الخط';

  @override
  String get fontTypeLabel => 'نوع الخط';

  @override
  String get naskhFont => 'نسخ';

  @override
  String get languageAndThemeSection => 'اللغة والمظهر';

  @override
  String get darkModeLabel => 'الوضع الداكن';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get aboutAppSection => 'عن التطبيق';

  @override
  String get privacyPolicyLabel => 'سياسة الخصوصية';

  @override
  String get termsAndConditionsLabel => 'الشروط والأحكام';

  @override
  String get languageSettingsTitle => 'اللغة';

  @override
  String get languageSettingsSubtitle => 'اختر لغة واجهة التطبيق';

  @override
  String get prayerCalcSettingsTitle => 'إعدادات الصلاة والأذان';

  @override
  String get prayerCalcSettingsSubtitle => 'حدد طريقة حساب مواقيت الصلاة';

  @override
  String get calcMethodSectionTitle => 'طريقة حساب مواقيت الصلاة';

  @override
  String get adhanSoundSectionTitle => 'صوت الأذان';

  @override
  String get mwlTitle => 'رابطة العالم الإسلامي';

  @override
  String get mwlDesc => 'الأكثر شيوعًا في مصر والدول العربية';

  @override
  String get isnaTitle => 'الجمعية الإسلامية لأمريكا الشمالية';

  @override
  String get isnaDesc => 'ISNA';

  @override
  String get egyptSurveyTitle => 'الهيئة المصرية العامة للمساحة';

  @override
  String get egyptSurveyDesc => 'موصى بها في مصر';

  @override
  String get ummAlQuraTitle => 'أم القرى، مكة المكرمة';

  @override
  String get ummAlQuraDesc => 'المملكة العربية السعودية';

  @override
  String get karachiTitle => 'جامعة العلوم الإسلامية، كراتشي';

  @override
  String get karachiDesc => 'باكستان وأفغانستان والهند';

  @override
  String get adhanMakkah => 'أذان مكة المكرمة';

  @override
  String get adhanMadinah => 'أذان المدينة المنورة';

  @override
  String get adhanAlafasy => 'الشيخ مشاري العفاسي';

  @override
  String get locationSettingsTitle => 'الموقع والمحافظة';

  @override
  String get locationSettingsSubtitle => 'تحديد موقعك لحساب المواقيت بدقة';

  @override
  String get fontSettingsTitle => 'إعدادات الخط';

  @override
  String get fontSettingsSubtitle => 'تخصيص حجم ونوع الخط لقراءة مريحة';

  @override
  String get fontPreviewText => 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

  @override
  String get fontTypeSettingsTitle => 'نوع الخط';

  @override
  String get fontTypeSettingsSubtitle =>
      'اختر نوع الخط المفضل لقراءة القرآن والأذكار';

  @override
  String get fontTypeSectionTitle => 'أنواع الخطوط المتاحة';

  @override
  String get uthmaniFont => 'عثماني';

  @override
  String get amiriFont => 'أميري';

  @override
  String get naskhFontDesc => 'خط واضح ومريح للقراءة';

  @override
  String get uthmaniFontDesc => 'الرسم العثماني المعتمد للمصحف';

  @override
  String get amiriFontDesc => 'خط عربي كلاسيكي أصيل';

  @override
  String get selectedFontLabel => 'الخط المحدد';

  @override
  String get privacyPolicyContent =>
      'نحن نلتزم بحماية خصوصيتك وبياناتك. تطبيق حچتي لا يجمع أو يشارك أو يبيع أي بيانات شخصية مع أي أطراف ثالثة.';

  @override
  String get termsAndConditionsContent =>
      'باستخدامك لتطبيق حچتي، فإنك توافق على الالتزام بجميع الشروط والأحكام الموضحة هنا. يُستخدم التطبيق لأغراض التذكير بالصلوات وقراءة القرآن والأذكار وفق التعاليم الإسلامية.';

  @override
  String get hijriCalendar => 'التقويم الهجري';

  @override
  String get prayerSchedule => 'الجدول الكامل';

  @override
  String get exclusiveFeature => 'ميزة حصرية';

  @override
  String get anaOsalyTitle => 'حچتي';

  @override
  String get anaOsalyPromoDesc =>
      'أثناء وقت الصلاة، يرسل للمتصل تلقائيًا رسالة \"حچتي\"';

  @override
  String get enableFeature => 'تفعيل الميزة';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navQuran => 'القرآن';

  @override
  String get navAthkar => 'الأذكار';

  @override
  String get navOccasions => 'المناسبات';

  @override
  String get navMore => 'المزيد';

  @override
  String get fullPrayerTimesTitle => 'مواقيت الصلاة';

  @override
  String get prayerTimesAddress =>
      '2 هشام لبيب مكرم عبيد مدينة نصر القاهرة، مصر';

  @override
  String get changeLocation => 'تغيير الموقع';

  @override
  String get tabTimes => 'المواقيت';

  @override
  String get tabAdhanSettings => 'إعدادات الأذان';

  @override
  String get tabAnaOsaly => 'حچتي';

  @override
  String get enableAllPrayersNotifications => 'تفعيل تنبيهات جميع الصلوات';

  @override
  String get allPrayersNotificationsDesc => 'تلقى تنبيهات قبل كل صلاة';

  @override
  String get prayerNotificationTypeSection => 'نوع تنبيه الصلاة';

  @override
  String get fullAdhanTitle => 'الأذان الكامل';

  @override
  String get fullAdhanDesc => 'يشغّل الأذان كامل عند دخول وقت الصلاة';

  @override
  String get shortAlertTitle => 'تنبيه مختصر';

  @override
  String get shortAlertDesc => '\"الله أكبر، الله أكبر\" ثم يتوقف التنبيه';

  @override
  String get anaOsalyHeroSubtitle =>
      'عند تفعيل هذه الميزة، يمكن إعلام المتصل بأنك في وقت الصلاة تلقائيًا.';

  @override
  String get anaOsalyMessageLang => 'لغة الرسالة';

  @override
  String get anaOsalyToggleTitle => 'تفعيل ميزة حچتي';

  @override
  String get anaOsalyToggleSubtitle => 'تفعّل تلقائيًا وقت الصلاة';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get markAllAsRead => 'تعيين الكل كمقروء';

  @override
  String minAgo(Object count) {
    return 'منذ $count دقائق';
  }

  @override
  String get hourAgo => 'منذ ساعة';

  @override
  String hoursAgo(Object count) {
    return 'منذ $count ساعات';
  }

  @override
  String get anaOsalyMessageAr => 'حچتي';

  @override
  String get anaOsalyMessageEn => 'I am praying';

  @override
  String get exitAppTitle => 'إغلاق التطبيق';

  @override
  String get exitAppMessage => 'هل أنت متأكد من أنك تريد إغلاق التطبيق؟';

  @override
  String get exitAppConfirm => 'خروج';

  @override
  String get exitAppCancel => 'إلغاء';

  @override
  String get surahs => 'السور';

  @override
  String get quranSearch => 'البحث';

  @override
  String get quranSearchHint => 'ابحث في آيات القرآن الكريم...';

  @override
  String get quranNoResults => 'لا توجد نتائج بحث';

  @override
  String get quranTafseer => 'التفسير';

  @override
  String get quranJuzs => 'الأجزاء والأحزاب';

  @override
  String get quranPageLabel => 'صفحة';

  @override
  String get safha => 'صفحة';

  @override
  String get qiraat => 'القراءات';

  @override
  String get surahs_list => 'فهرس السور';

  @override
  String get firstQuarter => 'الربع الأول';

  @override
  String get secondQuarter => 'الربع الثاني';

  @override
  String get thirdQuarter => 'الربع الثالث';

  @override
  String get fourthQuarter => 'الربع الرابع';

  @override
  String get itsNumber => 'رقمها';

  @override
  String get ayat => 'آياتها';

  @override
  String get select_qirat => 'اختر القراءة';

  @override
  String get qirat_hafs => 'حفص عن عاصم';

  @override
  String get qirat_douri => 'الدوري عن أبي عمرو';

  @override
  String get qirat_qalon => 'قالون عن نافع';

  @override
  String get qirat_shubah => 'شعبة عن عاصم';

  @override
  String get qirat_warsh => 'ورش عن نافع';

  @override
  String get downloadQuranError => 'حدث خطأ أثناء التحميل';

  @override
  String get downloadQuranSuccess => 'تم التحميل بنجاح';

  @override
  String get downloadingQuran => 'جاري التحميل...';

  @override
  String get download_selected => 'تحميل المحدد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String juzNumber(Object number) {
    return 'الجزء $number';
  }

  @override
  String hizbNumber(Object number) {
    return 'الحزب $number';
  }

  @override
  String get allSurahs => 'جميع السور';

  @override
  String get twoPageMode => 'عرض صفحتين';

  @override
  String get singlePageMode => 'عرض صفحة واحدة';

  @override
  String get quranReaderTitle => 'المصحف الشريف';

  @override
  String get anaOsalyCallBlockingActive => 'حظر المكالمات أثناء الصلاة مفعل';

  @override
  String get anaOsalyPermissionRequiredTitle => 'إذن حظر المكالمات مطلوب';

  @override
  String get anaOsalyPermissionRequiredDesc =>
      'يرجى منح إذن حظر المكالمات ليتمكن التطبيق من إلغاء المكالمات الواردة تلقائيًا أثناء وقت الصلاة';

  @override
  String get grantPermission => 'منح الإذن';

  @override
  String get permissionGranted => 'تم منح الإذن';

  @override
  String get downloadQuranPages => 'تحميل صفحات المصحف الشريف';

  @override
  String get downloadQuranPagesDesc =>
      'يلزم تحميل صفحات المصحف للقراءة لأول مرة وبدون إنترنت (الحجم: ~140 ميجابايت)';

  @override
  String get downloadQiratConfirmTitle => 'تحميل رواية المصحف';

  @override
  String downloadQiratConfirmDesc(Object qiratName, Object size) {
    return 'هل تريد تحميل مصحف $qiratName بحجم $size ميجابايت للقراءة بدون إنترنت؟';
  }

  @override
  String get startDownload => 'بدء التحميل الآن';

  @override
  String get retryDownload => 'إعادة المحاولة';

  @override
  String downloadProgress(Object downloaded, Object percent, Object total) {
    return '$downloaded ميجابايت من $total ميجابايت ($percent%)';
  }

  @override
  String get qiratComingSoon => 'قريباً إن شاء الله';

  @override
  String get radio => 'إذاعة القرآن';

  @override
  String get radioSubtitle => 'استمع إلى القرآن الكريم بأصوات كبار القراء';

  @override
  String get makkahLive => 'بث مباشر مكة المكرمة';

  @override
  String get madinahLive => 'بث مباشر المدينة المنورة';

  @override
  String get playlists => 'قوائم التشغيل';

  @override
  String get recitersList => 'قائمة القراء';

  @override
  String get searchReciter => 'ابحث عن قارئ...';

  @override
  String get searchSurah => 'ابحث عن سورة...';

  @override
  String get listenToSurah => 'استماع للسورة';

  @override
  String get addToPlaylist => 'إضافة إلى قائمة التشغيل';

  @override
  String get newPlaylistTitle => 'قائمة جديدة';

  @override
  String get playlistNameHint => 'اسم القائمة';

  @override
  String get deletePlaylistTitle => 'حذف القائمة';

  @override
  String get noSurahsInPlaylist => 'لا توجد سور في هذه القائمة';

  @override
  String get noRecitersFound => 'لم يتم العثور على قراء';

  @override
  String get noSurahsFound => 'لم يتم العثور على سور';

  @override
  String get nowPlaying => 'يتم الاستماع الآن';

  @override
  String get playbackSpeed => 'سرعة التشغيل';

  @override
  String get speedNormal => 'عادي (1.0x)';

  @override
  String get create => 'إنشاء';

  @override
  String get favorites => 'المفضلة';

  @override
  String get download => 'تحميل';

  @override
  String get downloading => 'جاري التحميل...';

  @override
  String get offlineAvailable => 'متاح بدون إنترنت';

  @override
  String get downloadSuccess => 'تم تحميل السورة بنجاح';

  @override
  String get downloadFailed => 'فشل تحميل السورة';

  @override
  String get deleteDownload => 'حذف الملف';

  @override
  String get offlinePlayback => 'تشغيل بدون إنترنت';

  @override
  String get downloadedAudios => 'التسجيلات المحملة';

  @override
  String get noDownloadsYet => 'لا توجد تسجيلات محملة بعد';

  @override
  String get hadithBooksTitle => 'كتب الحديث والمصنفات';

  @override
  String get hadithBooksSubtitle =>
      'صحيح البخاري، مسلم، الأربعينيات ومصنفات السنة';

  @override
  String get searchBooksHint => 'ابحث عن كتاب أو مؤلف...';

  @override
  String get allCategory => 'الكل';

  @override
  String get nineBooksCategory => 'كتب السنة التسعة';

  @override
  String get fortiesCategory => 'الأربعينيات';

  @override
  String get otherBooksCategory => 'كتب ورسائل أخرى';

  @override
  String get noBooksFound => 'لم يتم العثور على كتب مطابقة';

  @override
  String get searchChaptersHint => 'ابحث في الأبواب...';

  @override
  String get noChaptersFound => 'لم يتم العثور على أبواب';

  @override
  String get searchHadithsHint => 'ابحث في نص الأحاديث...';

  @override
  String get noHadithsFound => 'لم يتم العثور على أحاديث';

  @override
  String get hadithWord => 'حديث';

  @override
  String get hadithCopied => 'تم نسخ الحديث بنجاح';

  @override
  String get copy => 'نسخ';

  @override
  String get delete => 'حذف';

  @override
  String get shareApp => 'مشاركة التطبيق';

  @override
  String get shareAppMessage =>
      'تطبيق حجتي - رفيقك الإسلامي الشامل لمواقيت الصلاة، القرآن الكريم، الأذكار، والمناسبات الإسلامية.';

  @override
  String get downloadAppPrompt => 'تحميل التطبيق';

  @override
  String get developedByPrompt => 'تم التطوير بواسطة صدّق';

  @override
  String get shareRecitation => 'مشاركة التلاوة';

  @override
  String get downloadAudioPrompt =>
      'يجب تحميل الملف الصوتي أولاً لتتمكن من مشاركته. هل تريد بدء التحميل الآن؟';

  @override
  String get downloadAndShare => 'تحميل ومشاركة';

  @override
  String get downloadingInProgress => 'جاري التحميل حالياً، يرجى الانتظار...';

  @override
  String get searchAthkarHint => 'ابحث في الأذكار والأدعية...';

  @override
  String get hisnAlMuslim => 'حصن المسلم';

  @override
  String get dailyAthkar => 'الأذكار اليومية';

  @override
  String get noAthkarFound => 'لم يتم العثور على أذكار مطابقة';

  @override
  String get searchResults => 'نتائج البحث';

  @override
  String allAthkarCount(Object count) {
    return '$count باباً';
  }

  @override
  String get asmaAllahTitle => 'أسماء الله الحسنى';

  @override
  String get asmaAllahSubtitle => '٩٩ اسماً مع المعاني والتفسير';

  @override
  String get searchAsmaHint => 'ابحث في أسماء الله الحسنى...';

  @override
  String get noAsmaFound => 'لم يتم العثور على اسم مطابق';

  @override
  String asmaCount(Object count) {
    return '$count اسماً';
  }

  @override
  String get meaningLabel => 'المعنى';

  @override
  String get explanationLabel => 'التفسير';

  @override
  String get hojatyAiTitle => 'المساعد الإسلامي الذكي';

  @override
  String get hojatyAiSubtitle => 'إجابات وتوجيهات مستندة للكتاب والسنة';

  @override
  String get hojatyAiInputHint => 'اسأل عن مسألة، أو شارك ما يضيق به صدرك...';

  @override
  String get hojatyAiSourcesTitle => 'المصادر الموثقة من التطبيق';

  @override
  String get hojatyAiCopyText => 'نسخ النص';

  @override
  String get hojatyAiTextCopied => 'تم نسخ النص إلى الحافظة';

  @override
  String get hojatyAiEmptyTitle => 'كيف يمكنني مساعدتك اليوم؟';

  @override
  String get hojatyAiEmptySubtitle =>
      'اطرح سؤالاً شرعياً أو شارك موقفاً حياتياً للحصول على مواساة وتوجيه من الكتاب والسنة';

  @override
  String get hojatyAiClearChat => 'مسح المحادثة';

  @override
  String get hojatyAiQuickAccessTitle => 'المساعد الذكي';

  @override
  String get hojatyAiQuickAccessSubtitle =>
      'استشارات وتوجيهات من الكتاب والسنة';

  @override
  String get hojatyAiDownloadTitle => 'تحميل قاعدة بيانات المساعد الإسلامي';

  @override
  String get hojatyAiDownloadDesc =>
      'يلزم تحميل قاعدة البيانات الإسلامية الموثقة (أكثر من 57 ألف نص شرعي وتفسير) لتمكين المساعد الذكي من استخراج الآيات والأحاديث النبوية والإجابة بدقة وبدون تأليف.';

  @override
  String get hojatyAiDownloadSize => 'حجم التحميل: ~237 ميجابايت';

  @override
  String get hojatyAiStartDownload => 'بدء التحميل الآن';

  @override
  String get hojatyAiRetryDownload => 'إعادة المحاولة';

  @override
  String get hojatyAiCancelDownload => 'إلغاء التحميل';

  @override
  String get hojatyAiDownloadError =>
      'تعذر تحميل قاعدة البيانات، يرجى التأكد من اتصال الإنترنت والمحاولة مجدداً.';

  @override
  String get hojatyAiDownloadReady => 'تم تجهيز قاعدة البيانات بنجاح';

  @override
  String hojatyAiDownloadProgress(int downloaded, int total, int percent) =>
      '$downloaded ميجابايت من $total ميجابايت ($percent%)';

  @override
  String get hojatyAiMicListening => 'جاري الاستماع... تحدث الآن';

  @override
  String get hojatyAiMicPermissionDenied =>
      'يرجى منح إذن الميكروفون لاستخدام الإدخال الصوتي';

  @override
  String get hojatyAiRequiresDownload => 'يتطلب التحميل (~237MB)';
}
