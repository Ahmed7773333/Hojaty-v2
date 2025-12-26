// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hojaty';

  @override
  String get home => 'Home';

  @override
  String get radio => 'Radio';

  @override
  String get azkar => 'Azkar';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get location => 'Location';

  @override
  String get currentCity => 'Current City';

  @override
  String get unknown => 'Unknown';

  @override
  String get sebhaTitle => 'Sebha';

  @override
  String get reset => 'Reset';

  @override
  String get sound => 'Sound';

  @override
  String get vibrate => 'Vibrate';

  @override
  String get resetDialogTitle => 'Reset Counter';

  @override
  String get resetDialogContent => 'Do you want to reset the counter to zero?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get quranSearch => 'Search';

  @override
  String get quranHezps => 'Hezps';

  @override
  String get quranTafseer => 'Tafseer';

  @override
  String get quranJuzs => 'Juzs';

  @override
  String quranPageNotFound(int pageNum) {
    return 'Page $pageNum not found';
  }

  @override
  String get quranJuzLabel => 'Juz';

  @override
  String get quranHizbLabel => 'Hizb';

  @override
  String get quranPageLabel => 'Page';

  @override
  String navigateTo(String destination) {
    return 'Navigate to $destination';
  }

  @override
  String get nextPrayer => 'Next Prayer';

  @override
  String get remaining => 'Remaining: ';

  @override
  String service(int number) {
    return 'Service $number';
  }

  @override
  String get holyQuran => 'The Holy Quran';

  @override
  String get dailyWird => 'Your Daily Wird';

  @override
  String errorMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get surahs => 'Surahs';

  @override
  String get itsNumber => 'its Number';

  @override
  String get safha => 'Page';

  @override
  String get firstQuarter => 'First Quarter';

  @override
  String get secondQuarter => 'Second Quarter';

  @override
  String get thirdQuarter => 'Third Quarter';

  @override
  String get fourthQuarter => 'Fourth Quarter';

  @override
  String get ayat => 'Ayat';

  @override
  String get quranSearchHint => 'Search in Quran';

  @override
  String get quranNoResults => 'No results found';
}
