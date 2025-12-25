// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

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
}
