// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get playlists => 'Playlists';

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

  @override
  String get madina_live => 'Madina Live';

  @override
  String get makkah_live => 'Makkah Live';

  @override
  String get surahs_list => 'Surahs List';

  @override
  String get listen_to_surah => 'Listen to Surah';

  @override
  String get offline_available => 'Available Offline';

  @override
  String get download => 'Download';

  @override
  String get downloading => 'Downloading...';

  @override
  String get download_success => 'Downloaded successfully';

  @override
  String get download_failed => 'Download failed';

  @override
  String get playback_speed => 'Playback Speed';

  @override
  String get readers_list => 'Reciters List';

  @override
  String get search => 'Search';

  @override
  String get duaas => 'Duaas';

  @override
  String get prophet => 'The Prophet';

  @override
  String get prophets_stories => 'Stories of Prophets';

  @override
  String get qibla => 'Qibla';

  @override
  String get ramadan => 'Ramadan';

  @override
  String get ahadith => 'Ahadith';

  @override
  String get allah_names => 'Names of Allah';

  @override
  String get quranIndex => 'Index';

  @override
  String get close => 'Close';

  @override
  String get prophetNames => 'Names of Prophet';

  @override
  String get share => 'Share';

  @override
  String get share_file_not_downloaded =>
      'File not downloaded. Download first or share link?';

  @override
  String get share_link => 'Share Link';

  @override
  String get add_to_playlist => 'Add to Playlist';

  @override
  String get no_playlists_available =>
      'No playlists available. Create one first!';

  @override
  String added_to_playlist(String name) {
    return 'Added to $name';
  }
}
