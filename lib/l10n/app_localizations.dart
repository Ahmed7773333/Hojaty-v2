import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  ];

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Hojaty'**
  String get appTitle;

  /// Home tab title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Radio tab title
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get radio;

  /// Azkar tab title
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkar;

  /// Settings tab title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Appearance section header
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Language section header
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Location section header
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Current city label
  ///
  /// In en, this message translates to:
  /// **'Current City'**
  String get currentCity;

  /// Unknown value placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Sebha page title
  ///
  /// In en, this message translates to:
  /// **'Sebha'**
  String get sebhaTitle;

  /// Reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Sound toggle label
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Vibrate toggle label
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get vibrate;

  /// Title of the reset confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Reset Counter'**
  String get resetDialogTitle;

  /// Content of the reset confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset the counter to zero?'**
  String get resetDialogContent;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Search button tooltip
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get quranSearch;

  /// Hezps button label
  ///
  /// In en, this message translates to:
  /// **'Hezps'**
  String get quranHezps;

  /// Tafseer button label
  ///
  /// In en, this message translates to:
  /// **'Tafseer'**
  String get quranTafseer;

  /// Juzs button tooltip
  ///
  /// In en, this message translates to:
  /// **'Juzs'**
  String get quranJuzs;

  /// Error message when page is missing
  ///
  /// In en, this message translates to:
  /// **'Page {pageNum} not found'**
  String quranPageNotFound(int pageNum);

  /// Label for Juz
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get quranJuzLabel;

  /// Label for Hizb
  ///
  /// In en, this message translates to:
  /// **'Hizb'**
  String get quranHizbLabel;

  /// Label for Page
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get quranPageLabel;

  /// Generic navigation message
  ///
  /// In en, this message translates to:
  /// **'Navigate to {destination}'**
  String navigateTo(String destination);

  /// Label for next prayer header
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// Prefix for remaining time
  ///
  /// In en, this message translates to:
  /// **'Remaining: '**
  String get remaining;

  /// Service placeholder label
  ///
  /// In en, this message translates to:
  /// **'Service {number}'**
  String service(int number);

  /// Title for Quran card
  ///
  /// In en, this message translates to:
  /// **'The Holy Quran'**
  String get holyQuran;

  /// Subtitle for Quran card
  ///
  /// In en, this message translates to:
  /// **'Your Daily Wird'**
  String get dailyWird;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorMessage(String message);

  /// Surahs button label
  ///
  /// In en, this message translates to:
  /// **'Surahs'**
  String get surahs;

  /// Label for number
  ///
  /// In en, this message translates to:
  /// **'its Number'**
  String get itsNumber;

  /// Label for page
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get safha;

  /// Label for first quarter of Hizb
  ///
  /// In en, this message translates to:
  /// **'First Quarter'**
  String get firstQuarter;

  /// Label for second quarter of Hizb
  ///
  /// In en, this message translates to:
  /// **'Second Quarter'**
  String get secondQuarter;

  /// Label for third quarter of Hizb
  ///
  /// In en, this message translates to:
  /// **'Third Quarter'**
  String get thirdQuarter;

  /// Label for fourth quarter of Hizb
  ///
  /// In en, this message translates to:
  /// **'Fourth Quarter'**
  String get fourthQuarter;

  /// Label for verses
  ///
  /// In en, this message translates to:
  /// **'Ayat'**
  String get ayat;

  /// Hint text for Quran search
  ///
  /// In en, this message translates to:
  /// **'Search in Quran'**
  String get quranSearchHint;

  /// Message shown when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get quranNoResults;

  /// Title for Madina Live Stream card
  ///
  /// In en, this message translates to:
  /// **'Madina Live'**
  String get madina_live;

  /// Title for Makkah Live Stream card
  ///
  /// In en, this message translates to:
  /// **'Makkah Live'**
  String get makkah_live;

  /// Header for Surahs list
  ///
  /// In en, this message translates to:
  /// **'Surahs List'**
  String get surahs_list;

  /// Button or action to listen to a Surah
  ///
  /// In en, this message translates to:
  /// **'Listen to Surah'**
  String get listen_to_surah;

  /// Message indicating content is downloaded
  ///
  /// In en, this message translates to:
  /// **'Available Offline'**
  String get offline_available;

  /// Download button label
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Downloading status message
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// Download success message
  ///
  /// In en, this message translates to:
  /// **'Downloaded successfully'**
  String get download_success;

  /// Download failure message
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get download_failed;

  /// Playback speed option
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playback_speed;

  /// Header for list of reciters
  ///
  /// In en, this message translates to:
  /// **'Reciters List'**
  String get readers_list;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @duaas.
  ///
  /// In en, this message translates to:
  /// **'Duaas'**
  String get duaas;

  /// No description provided for @prophet.
  ///
  /// In en, this message translates to:
  /// **'The Prophet'**
  String get prophet;

  /// No description provided for @prophets_stories.
  ///
  /// In en, this message translates to:
  /// **'Stories of Prophets'**
  String get prophets_stories;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @ramadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get ramadan;

  /// No description provided for @ahadith.
  ///
  /// In en, this message translates to:
  /// **'Ahadith'**
  String get ahadith;

  /// No description provided for @allah_names.
  ///
  /// In en, this message translates to:
  /// **'Names of Allah'**
  String get allah_names;

  /// No description provided for @quranIndex.
  ///
  /// In en, this message translates to:
  /// **'Index'**
  String get quranIndex;
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
      <String>['ar', 'en'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
