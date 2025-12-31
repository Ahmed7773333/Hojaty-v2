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
  String get quranIndex => 'الفهرس';
}
