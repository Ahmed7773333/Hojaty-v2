// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get playlists => 'قوائم التشغيل';

  @override
  String get appTitle => 'حجتي';

  @override
  String get home => 'الرئيسية';

  @override
  String get radio => 'الراديو';

  @override
  String get azkar => 'الأذكار';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get location => 'الموقع';

  @override
  String get currentCity => 'المدينة الحالية';

  @override
  String get unknown => 'غير معروف';

  @override
  String get sebhaTitle => 'السبحة';

  @override
  String get reset => 'إعادة';

  @override
  String get sound => 'الصوت';

  @override
  String get vibrate => 'اهتزاز';

  @override
  String get resetDialogTitle => 'إعادة تعيين';

  @override
  String get resetDialogContent => 'هل تريد إعادة ضبط العداد إلى الصفر؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'موافق';

  @override
  String get quranSearch => 'بحث';

  @override
  String get quranHezps => 'الأحزاب';

  @override
  String get quranTafseer => 'التفسير';

  @override
  String get quranJuzs => 'الأجزاء';

  @override
  String quranPageNotFound(int pageNum) {
    return 'الصفحة $pageNum غير موجودة';
  }

  @override
  String get quranJuzLabel => 'الجزء';

  @override
  String get quranHizbLabel => 'الحزب';

  @override
  String get quranPageLabel => 'صفحة';

  @override
  String navigateTo(String destination) {
    return 'الانتقال إلى $destination';
  }

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String get remaining => 'متبقي: ';

  @override
  String service(int number) {
    return 'خدمة $number';
  }

  @override
  String get holyQuran => 'القرآن الكريم';

  @override
  String get dailyWird => 'وردك اليومي';

  @override
  String errorMessage(String message) {
    return 'خطأ: $message';
  }

  @override
  String get surahs => 'سور';

  @override
  String get itsNumber => 'رقمها';

  @override
  String get safha => 'صفحة';

  @override
  String get firstQuarter => 'الربع الأول';

  @override
  String get secondQuarter => 'الربع الثاني';

  @override
  String get thirdQuarter => 'الربع الثالث';

  @override
  String get fourthQuarter => 'الربع الرابع';

  @override
  String get ayat => 'آيات';

  @override
  String get quranSearchHint => 'بحث في القرآن';

  @override
  String get quranNoResults => 'لا نتائج';

  @override
  String get madina_live => 'بث مباشر المدينة';

  @override
  String get makkah_live => 'بث مباشر مكة';

  @override
  String get surahs_list => 'قائمة السور';

  @override
  String get listen_to_surah => 'استماع للسورة';

  @override
  String get offline_available => 'متاح بدون إنترنت';

  @override
  String get download => 'تحميل';

  @override
  String get downloading => 'جاري التحميل...';

  @override
  String get download_success => 'تم التحميل بنجاح';

  @override
  String get download_failed => 'فشل التحميل';

  @override
  String get playback_speed => 'سرعة التشغيل';

  @override
  String get readers_list => 'قائمة القراء';

  @override
  String get search => 'بحث';

  @override
  String get duaas => 'أدعية';

  @override
  String get prophet => 'النبي';

  @override
  String get prophets_stories => 'قصص الأنبياء';

  @override
  String get qibla => 'القبلة';

  @override
  String get ramadan => 'رمضان';

  @override
  String get ahadith => 'أحاديث';

  @override
  String get allah_names => 'أسماء الله الحسنى';

  @override
  String get close => 'إغلاق';

  @override
  String get prophetNames => 'أسماء النبي';

  @override
  String get share => 'مشاركة';

  @override
  String get share_file_not_downloaded =>
      'الملف غير محمّل. هل تريد تحميله أولاً أم مشاركة الرابط؟';

  @override
  String get share_link => 'مشاركة الرابط';

  @override
  String get add_to_playlist => 'إضافة إلى قائمة التشغيل';

  @override
  String get no_playlists_available => 'لا توجد قوائم تشغيل. أنشئ واحدة أولاً!';

  @override
  String added_to_playlist(String name) {
    return 'تمت الإضافة إلى $name';
  }

  @override
  String get hadith_search_hint => 'بحث في الأحاديث';

  @override
  String get no_hadith_found => 'لا توجد أحاديث';

  @override
  String get hadith_number => 'حديث رقم';

  @override
  String get show_description => 'عرض الشرح';

  @override
  String get hide_description => 'إخفاء الشرح';

  @override
  String get about_app => 'عن التطبيق';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get contact_us => 'تواصل معنا';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get show_notifications => 'عرض الإشعارات';

  @override
  String get refresh_location => 'تحديث الموقع';

  @override
  String get version => 'الإصدار';

  @override
  String get developed_by => 'تم التطوير بواسطة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get website => 'الموقع الإلكتروني';

  @override
  String get privacy_policy_text =>
      'تشرح سياسة الخصوصية هذه كيفية استخدام تطبيقنا لبياناتك...';

  @override
  String get app_description => 'حجتي هو رفيقك الإسلامي الشامل...';

  @override
  String get downloadQuranTitle => 'تحميل صفحات المصحف';

  @override
  String get downloadQuranMessage =>
      'صفحات المصحف غير محملة. هل وريت تحميلها الآن؟ (الحجم: ~100 ميجابايت)';

  @override
  String get downloadQuranAction => 'تحميل';

  @override
  String get downloadQuranCancel => 'لاحقاً';

  @override
  String get downloadingQuran => 'جاري تحميل صفحات المصحف...';

  @override
  String get downloadQuranSuccess => 'تم تحميل صفحات المصحف بنجاح';

  @override
  String get downloadQuranError => 'فشل تحميل صفحات المصحف';

  @override
  String get qirat_hafs => 'حفص';

  @override
  String get qirat_douri => 'الدوري';

  @override
  String get qirat_qalon => 'قالون';

  @override
  String get qirat_shubah => 'شعبة';

  @override
  String get qirat_warsh => 'ورش';

  @override
  String get select_qirat => 'اختر القراءات';

  @override
  String get qiraat => 'القراءات';

  @override
  String get download_selected => 'تحميل المحدد';

  @override
  String get quranIndex => 'الفهرس';

  @override
  String get book_bukhari => 'صحيح البخاري';

  @override
  String get book_muslim => 'صحيح مسلم';

  @override
  String get book_nasai => 'سنن النسائي';

  @override
  String get book_abudawud => 'سنن أبي داود';

  @override
  String get book_tirmidhi => 'جامع الترمذي';

  @override
  String get book_ibnmajah => 'سنن ابن ماجه';

  @override
  String get book_malik => 'موطأ مالك';

  @override
  String get book_ahmed => 'مسند أحمد';

  @override
  String get book_darimi => 'سنن الدارمي';

  @override
  String get book_nawawi40 => 'الأربعون النووية';

  @override
  String get book_qudsi40 => 'الأربعون القدسية';

  @override
  String get book_shahwaliullah40 => 'أربعون الشاه ولي الله';

  @override
  String get book_riyad => 'رياض الصالحين';

  @override
  String get book_bulugh => 'بلوغ المرام';

  @override
  String get book_mishkat => 'مشكاة المصابيح';

  @override
  String get book_adab => 'الأدب المفرد';

  @override
  String get book_shamail => 'الشمائل المحمدية';
}
