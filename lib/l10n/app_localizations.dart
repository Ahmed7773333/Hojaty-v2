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

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change the language later in settings'**
  String get chooseLanguageSubtitle;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicLanguage;

  /// No description provided for @arabicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicSubtitle;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @englishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishSubtitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skipAll.
  ///
  /// In en, this message translates to:
  /// **'Skip all'**
  String get skipAll;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @deleteDownloadConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this book ?'**
  String get deleteDownloadConfirm;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get getStarted;

  /// No description provided for @quranFehres.
  ///
  /// In en, this message translates to:
  /// **'Quran Fehres'**
  String get quranFehres;

  /// No description provided for @onboardingSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Accurate times for every prayer'**
  String get onboardingSlide1Subtitle;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Your prayer on time'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Desc.
  ///
  /// In en, this message translates to:
  /// **'We provide accurate prayer times based on your location, with notifications reminding you of every prayer on time.'**
  String get onboardingSlide1Desc;

  /// No description provided for @onboardingSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Read and glorify at any time'**
  String get onboardingSlide2Subtitle;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Quran and Athkar always with you'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Desc.
  ///
  /// In en, this message translates to:
  /// **'Browse the Holy Quran with a peaceful reading experience, and perform morning and evening Athkar with an interactive counter.'**
  String get onboardingSlide2Desc;

  /// No description provided for @onboardingSlide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart believer feature'**
  String get onboardingSlide3Subtitle;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Hojaty'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Desc.
  ///
  /// In en, this message translates to:
  /// **'When someone calls you during prayer, \"I am praying\" is sent to them automatically — because prayer time is sacred.'**
  String get onboardingSlide3Desc;

  /// No description provided for @onboardingSlide4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Hijri calendar and occasions'**
  String get onboardingSlide4Subtitle;

  /// No description provided for @onboardingSlide4Title.
  ///
  /// In en, this message translates to:
  /// **'Stay close to your religious occasions'**
  String get onboardingSlide4Title;

  /// No description provided for @onboardingSlide4Desc.
  ///
  /// In en, this message translates to:
  /// **'Follow Islamic occasions, fasting days and Ramadan Imsakiya, with notifications reminding you before each occasion.'**
  String get onboardingSlide4Desc;

  /// No description provided for @homeLocation.
  ///
  /// In en, this message translates to:
  /// **'Cairo, Egypt'**
  String get homeLocation;

  /// No description provided for @homeGregorianDate.
  ///
  /// In en, this message translates to:
  /// **'Saturday, 16 August 2026'**
  String get homeGregorianDate;

  /// No description provided for @homeHijriDate.
  ///
  /// In en, this message translates to:
  /// **'18 Muharram 1447 AH'**
  String get homeHijriDate;

  /// No description provided for @nextPrayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayerTitle;

  /// No description provided for @nextPrayerRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get nextPrayerRemaining;

  /// No description provided for @upcomingOccasionBanner.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Occasion: {title} — {days} days left'**
  String upcomingOccasionBanner(Object days, Object title);

  /// No description provided for @prayerTimesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimesSectionTitle;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @currentPrayerBadge.
  ///
  /// In en, this message translates to:
  /// **'Current Prayer'**
  String get currentPrayerBadge;

  /// No description provided for @nextPrayerBadge.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayerBadge;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @quranKareem.
  ///
  /// In en, this message translates to:
  /// **'Holy Quran'**
  String get quranKareem;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// No description provided for @quranStatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'114 Surahs - 30 Juz - 60 Hizb'**
  String get quranStatsSubtitle;

  /// No description provided for @searchSurahHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a surah...'**
  String get searchSurahHint;

  /// No description provided for @surahsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Surahs List'**
  String get surahsListTitle;

  /// No description provided for @surahBaqarah.
  ///
  /// In en, this message translates to:
  /// **'Surah Al-Baqarah'**
  String get surahBaqarah;

  /// No description provided for @ayahNumber.
  ///
  /// In en, this message translates to:
  /// **'Ayah {number}'**
  String ayahNumber(Object number);

  /// No description provided for @ayahCountText.
  ///
  /// In en, this message translates to:
  /// **'{count} Ayahs'**
  String ayahCountText(Object count);

  /// No description provided for @meccanType.
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get meccanType;

  /// No description provided for @medinanType.
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get medinanType;

  /// No description provided for @athkar.
  ///
  /// In en, this message translates to:
  /// **'Athkar'**
  String get athkar;

  /// No description provided for @morningAthkar.
  ///
  /// In en, this message translates to:
  /// **'Morning Athkar'**
  String get morningAthkar;

  /// No description provided for @eveningAthkar.
  ///
  /// In en, this message translates to:
  /// **'Evening Athkar'**
  String get eveningAthkar;

  /// No description provided for @sleepAthkar.
  ///
  /// In en, this message translates to:
  /// **'Sleep Athkar'**
  String get sleepAthkar;

  /// No description provided for @afterPrayerAthkar.
  ///
  /// In en, this message translates to:
  /// **'After Prayer Athkar'**
  String get afterPrayerAthkar;

  /// No description provided for @miscAthkar.
  ///
  /// In en, this message translates to:
  /// **'Various Athkar'**
  String get miscAthkar;

  /// No description provided for @electronicSebha.
  ///
  /// In en, this message translates to:
  /// **'Electronic Sebha'**
  String get electronicSebha;

  /// No description provided for @sebhaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Electronic counter for your tasbeeh'**
  String get sebhaSubtitle;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @salatAlIstikhara.
  ///
  /// In en, this message translates to:
  /// **'Salat Al-Istikhara'**
  String get salatAlIstikhara;

  /// No description provided for @athkarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Athkar for Muslims'**
  String get athkarSubtitle;

  /// No description provided for @countThikr.
  ///
  /// In en, this message translates to:
  /// **'{count} Athkar'**
  String countThikr(Object count);

  /// No description provided for @requiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredLabel;

  /// No description provided for @timesUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} Time'**
  String timesUnit(Object count);

  /// No description provided for @tapLabel.
  ///
  /// In en, this message translates to:
  /// **'Tap'**
  String get tapLabel;

  /// No description provided for @istikharaStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Steps'**
  String get istikharaStepsTitle;

  /// No description provided for @istikharaDuaTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplication After Prayer:'**
  String get istikharaDuaTitle;

  /// No description provided for @occasions.
  ///
  /// In en, this message translates to:
  /// **'Occasions'**
  String get occasions;

  /// No description provided for @occasionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Occasions'**
  String get occasionsTitle;

  /// No description provided for @occasionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hijri Calendar & Religious Occasions'**
  String get occasionsSubtitle;

  /// No description provided for @tabOccasions.
  ///
  /// In en, this message translates to:
  /// **'Occasions'**
  String get tabOccasions;

  /// No description provided for @tabCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get tabCalendar;

  /// No description provided for @tabRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get tabRamadan;

  /// No description provided for @upcomingOccasion.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Occasion'**
  String get upcomingOccasion;

  /// No description provided for @upcomingOccasionsList.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Occasions'**
  String get upcomingOccasionsList;

  /// No description provided for @prophetBirthday.
  ///
  /// In en, this message translates to:
  /// **'Prophet\'s Birthday'**
  String get prophetBirthday;

  /// No description provided for @eidAlAdha.
  ///
  /// In en, this message translates to:
  /// **'Eid Al-Adha'**
  String get eidAlAdha;

  /// No description provided for @hijriNewYear.
  ///
  /// In en, this message translates to:
  /// **'Hijri New Year'**
  String get hijriNewYear;

  /// No description provided for @ashura.
  ///
  /// In en, this message translates to:
  /// **'Ashura'**
  String get ashura;

  /// No description provided for @daysRemainingUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysRemainingUnit(Object count);

  /// No description provided for @daysRemainingText.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String daysRemainingText(Object count);

  /// No description provided for @hijriCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Hijri Calendar'**
  String get hijriCalendarTitle;

  /// No description provided for @gregorianCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Gregorian Calendar'**
  String get gregorianCalendarTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @returnToToday.
  ///
  /// In en, this message translates to:
  /// **'Back to Today'**
  String get returnToToday;

  /// No description provided for @ramadanKareem.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Kareem'**
  String get ramadanKareem;

  /// No description provided for @ramadanDay1Title.
  ///
  /// In en, this message translates to:
  /// **'Day 1 of Ramadan'**
  String get ramadanDay1Title;

  /// No description provided for @ramadanDay1Date.
  ///
  /// In en, this message translates to:
  /// **'1 Ramadan 1448 AH'**
  String get ramadanDay1Date;

  /// No description provided for @remainingOnRamadan.
  ///
  /// In en, this message translates to:
  /// **'Remaining until Ramadan'**
  String get remainingOnRamadan;

  /// No description provided for @ramadanImsakiya.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Imsakiya'**
  String get ramadanImsakiya;

  /// No description provided for @dayColumn.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayColumn;

  /// No description provided for @hijriYearLabel.
  ///
  /// In en, this message translates to:
  /// **'{year} AH'**
  String hijriYearLabel(Object year);

  /// No description provided for @occasionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Occasion Details'**
  String get occasionDetailsTitle;

  /// No description provided for @hijriDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Hijri Date'**
  String get hijriDateLabel;

  /// No description provided for @gregorianDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Gregorian Date'**
  String get gregorianDateLabel;

  /// No description provided for @aboutOccasionLabel.
  ///
  /// In en, this message translates to:
  /// **'About Occasion'**
  String get aboutOccasionLabel;

  /// No description provided for @aboutProphetBirthdayDesc.
  ///
  /// In en, this message translates to:
  /// **'Prophet\'s Birthday commemorates the birth of the Islamic prophet Muhammad, peace be upon him.'**
  String get aboutProphetBirthdayDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get settingsSubtitle;

  /// No description provided for @locationAndGovSection.
  ///
  /// In en, this message translates to:
  /// **'Location & Governorate'**
  String get locationAndGovSection;

  /// No description provided for @currentLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocationLabel;

  /// No description provided for @governorateLabel.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorateLabel;

  /// No description provided for @cairoLocation.
  ///
  /// In en, this message translates to:
  /// **'Cairo, Egypt'**
  String get cairoLocation;

  /// No description provided for @cairoGov.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cairoGov;

  /// No description provided for @prayerTimesAndAdhanSection.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times & Adhan'**
  String get prayerTimesAndAdhanSection;

  /// No description provided for @prayerTimesCalcSettings.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times Calculation Settings'**
  String get prayerTimesCalcSettings;

  /// No description provided for @egyptSurveyAuthority.
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority of Survey'**
  String get egyptSurveyAuthority;

  /// No description provided for @notificationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification Type'**
  String get notificationTypeLabel;

  /// No description provided for @prayerAlertsLabel.
  ///
  /// In en, this message translates to:
  /// **'Prayer Alerts'**
  String get prayerAlertsLabel;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @generalNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'General Notifications'**
  String get generalNotificationsLabel;

  /// No description provided for @occasionsNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Occasions Notifications'**
  String get occasionsNotificationsLabel;

  /// No description provided for @athkarNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Athkar Notifications'**
  String get athkarNotificationsLabel;

  /// No description provided for @fontSection.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get fontSection;

  /// No description provided for @fontSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSizeLabel;

  /// No description provided for @fontTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Font Type'**
  String get fontTypeLabel;

  /// No description provided for @naskhFont.
  ///
  /// In en, this message translates to:
  /// **'Naskh'**
  String get naskhFont;

  /// No description provided for @languageAndThemeSection.
  ///
  /// In en, this message translates to:
  /// **'Language & Appearance'**
  String get languageAndThemeSection;

  /// No description provided for @darkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @aboutAppSection.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutAppSection;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// No description provided for @termsAndConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditionsLabel;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingsTitle;

  /// No description provided for @languageSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose application interface language'**
  String get languageSettingsSubtitle;

  /// No description provided for @prayerCalcSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer & Adhan Settings'**
  String get prayerCalcSettingsTitle;

  /// No description provided for @prayerCalcSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select prayer calculation method'**
  String get prayerCalcSettingsSubtitle;

  /// No description provided for @calcMethodSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times Calculation Method'**
  String get calcMethodSectionTitle;

  /// No description provided for @adhanSoundSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Adhan Sound'**
  String get adhanSoundSectionTitle;

  /// No description provided for @mwlTitle.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get mwlTitle;

  /// No description provided for @mwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Most common in Egypt and Arab countries'**
  String get mwlDesc;

  /// No description provided for @isnaTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Society of North America'**
  String get isnaTitle;

  /// No description provided for @isnaDesc.
  ///
  /// In en, this message translates to:
  /// **'ISNA'**
  String get isnaDesc;

  /// No description provided for @egyptSurveyTitle.
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority of Survey'**
  String get egyptSurveyTitle;

  /// No description provided for @egyptSurveyDesc.
  ///
  /// In en, this message translates to:
  /// **'Recommended in Egypt'**
  String get egyptSurveyDesc;

  /// No description provided for @ummAlQuraTitle.
  ///
  /// In en, this message translates to:
  /// **'Umm Al-Qura, Makkah'**
  String get ummAlQuraTitle;

  /// No description provided for @ummAlQuraDesc.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get ummAlQuraDesc;

  /// No description provided for @karachiTitle.
  ///
  /// In en, this message translates to:
  /// **'University of Islamic Sciences, Karachi'**
  String get karachiTitle;

  /// No description provided for @karachiDesc.
  ///
  /// In en, this message translates to:
  /// **'Pakistan, Afghanistan & India'**
  String get karachiDesc;

  /// No description provided for @adhanMakkah.
  ///
  /// In en, this message translates to:
  /// **'Adhan Makkah Al-Mukarramah'**
  String get adhanMakkah;

  /// No description provided for @adhanMadinah.
  ///
  /// In en, this message translates to:
  /// **'Adhan Al-Madinah Al-Munawwarah'**
  String get adhanMadinah;

  /// No description provided for @adhanAlafasy.
  ///
  /// In en, this message translates to:
  /// **'Sheikh Mishary Alafasy'**
  String get adhanAlafasy;

  /// No description provided for @locationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Location & Governorate'**
  String get locationSettingsTitle;

  /// No description provided for @locationSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your location for accurate prayer times'**
  String get locationSettingsSubtitle;

  /// No description provided for @fontSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Settings'**
  String get fontSettingsTitle;

  /// No description provided for @fontSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize font size and style for comfortable reading'**
  String get fontSettingsSubtitle;

  /// No description provided for @fontPreviewText.
  ///
  /// In en, this message translates to:
  /// **'In the name of Allah, the Entirely Merciful, the Especially Merciful'**
  String get fontPreviewText;

  /// No description provided for @fontTypeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Type'**
  String get fontTypeSettingsTitle;

  /// No description provided for @fontTypeSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose font style for Quran and Athkar'**
  String get fontTypeSettingsSubtitle;

  /// No description provided for @fontTypeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Available Font Types'**
  String get fontTypeSectionTitle;

  /// No description provided for @uthmaniFont.
  ///
  /// In en, this message translates to:
  /// **'Uthmani'**
  String get uthmaniFont;

  /// No description provided for @amiriFont.
  ///
  /// In en, this message translates to:
  /// **'Amiri'**
  String get amiriFont;

  /// No description provided for @naskhFontDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear and easy to read'**
  String get naskhFontDesc;

  /// No description provided for @uthmaniFontDesc.
  ///
  /// In en, this message translates to:
  /// **'Standard Quranic script'**
  String get uthmaniFontDesc;

  /// No description provided for @amiriFontDesc.
  ///
  /// In en, this message translates to:
  /// **'Classical Arabic typography'**
  String get amiriFontDesc;

  /// No description provided for @selectedFontLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Font'**
  String get selectedFontLabel;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your privacy and personal data. The Hojaty app does not collect, sell, or share your private data with any third parties.'**
  String get privacyPolicyContent;

  /// No description provided for @termsAndConditionsContent.
  ///
  /// In en, this message translates to:
  /// **'By using the Hojaty application, you agree to comply with all terms and guidelines detailed herein. The app is provided for religious purposes including prayer reminders, Quran reading, and daily Athkar.'**
  String get termsAndConditionsContent;

  /// No description provided for @hijriCalendar.
  ///
  /// In en, this message translates to:
  /// **'Hijri Calendar'**
  String get hijriCalendar;

  /// No description provided for @prayerSchedule.
  ///
  /// In en, this message translates to:
  /// **'Full Schedule'**
  String get prayerSchedule;

  /// No description provided for @exclusiveFeature.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Feature'**
  String get exclusiveFeature;

  /// No description provided for @anaOsalyTitle.
  ///
  /// In en, this message translates to:
  /// **'Hojaty'**
  String get anaOsalyTitle;

  /// No description provided for @anaOsalyPromoDesc.
  ///
  /// In en, this message translates to:
  /// **'During prayer time, an automated \"I am praying\" message is sent to callers'**
  String get anaOsalyPromoDesc;

  /// No description provided for @enableFeature.
  ///
  /// In en, this message translates to:
  /// **'Enable Feature'**
  String get enableFeature;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get navQuran;

  /// No description provided for @navAthkar.
  ///
  /// In en, this message translates to:
  /// **'Athkar'**
  String get navAthkar;

  /// No description provided for @navOccasions.
  ///
  /// In en, this message translates to:
  /// **'Occasions'**
  String get navOccasions;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @fullPrayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get fullPrayerTimesTitle;

  /// No description provided for @prayerTimesAddress.
  ///
  /// In en, this message translates to:
  /// **'2 Hesham Labib, Makram Ebeid, Nasr City, Cairo, Egypt'**
  String get prayerTimesAddress;

  /// No description provided for @changeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocation;

  /// No description provided for @tabTimes.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get tabTimes;

  /// No description provided for @tabAdhanSettings.
  ///
  /// In en, this message translates to:
  /// **'Adhan Settings'**
  String get tabAdhanSettings;

  /// No description provided for @tabAnaOsaly.
  ///
  /// In en, this message translates to:
  /// **'Hojaty'**
  String get tabAnaOsaly;

  /// No description provided for @enableAllPrayersNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable All Prayers Notifications'**
  String get enableAllPrayersNotifications;

  /// No description provided for @allPrayersNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications before each prayer'**
  String get allPrayersNotificationsDesc;

  /// No description provided for @prayerNotificationTypeSection.
  ///
  /// In en, this message translates to:
  /// **'Prayer Notification Type'**
  String get prayerNotificationTypeSection;

  /// No description provided for @fullAdhanTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Adhan'**
  String get fullAdhanTitle;

  /// No description provided for @fullAdhanDesc.
  ///
  /// In en, this message translates to:
  /// **'Plays full Adhan at prayer time'**
  String get fullAdhanDesc;

  /// No description provided for @shortAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Short Alert'**
  String get shortAlertTitle;

  /// No description provided for @shortAlertDesc.
  ///
  /// In en, this message translates to:
  /// **'\"Allahu Akbar, Allahu Akbar\" then stops'**
  String get shortAlertDesc;

  /// No description provided for @anaOsalyHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When enabled, callers are automatically informed that you are praying.'**
  String get anaOsalyHeroSubtitle;

  /// No description provided for @anaOsalyMessageLang.
  ///
  /// In en, this message translates to:
  /// **'Message Language'**
  String get anaOsalyMessageLang;

  /// No description provided for @anaOsalyToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Hojaty Feature'**
  String get anaOsalyToggleTitle;

  /// No description provided for @anaOsalyToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Activates automatically during prayer times'**
  String get anaOsalyToggleSubtitle;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @minAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} mins ago'**
  String minAgo(Object count);

  /// No description provided for @hourAgo.
  ///
  /// In en, this message translates to:
  /// **'1 hour ago'**
  String get hourAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(Object count);

  /// No description provided for @anaOsalyMessageAr.
  ///
  /// In en, this message translates to:
  /// **'حچتي'**
  String get anaOsalyMessageAr;

  /// No description provided for @anaOsalyMessageEn.
  ///
  /// In en, this message translates to:
  /// **'I am praying'**
  String get anaOsalyMessageEn;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitAppTitle;

  /// No description provided for @exitAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitAppMessage;

  /// No description provided for @exitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitAppConfirm;

  /// No description provided for @exitAppCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get exitAppCancel;

  /// No description provided for @surahs.
  ///
  /// In en, this message translates to:
  /// **'Surahs'**
  String get surahs;

  /// No description provided for @quranSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get quranSearch;

  /// No description provided for @quranSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Quran verses...'**
  String get quranSearchHint;

  /// No description provided for @quranNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get quranNoResults;

  /// No description provided for @quranTafseer.
  ///
  /// In en, this message translates to:
  /// **'Tafseer'**
  String get quranTafseer;

  /// No description provided for @quranJuzs.
  ///
  /// In en, this message translates to:
  /// **'Juzs & Hizbs'**
  String get quranJuzs;

  /// No description provided for @quranPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get quranPageLabel;

  /// No description provided for @safha.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get safha;

  /// No description provided for @qiraat.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get qiraat;

  /// No description provided for @surahs_list.
  ///
  /// In en, this message translates to:
  /// **'Surahs Index'**
  String get surahs_list;

  /// No description provided for @firstQuarter.
  ///
  /// In en, this message translates to:
  /// **'1st Quarter'**
  String get firstQuarter;

  /// No description provided for @secondQuarter.
  ///
  /// In en, this message translates to:
  /// **'2nd Quarter'**
  String get secondQuarter;

  /// No description provided for @thirdQuarter.
  ///
  /// In en, this message translates to:
  /// **'3rd Quarter'**
  String get thirdQuarter;

  /// No description provided for @fourthQuarter.
  ///
  /// In en, this message translates to:
  /// **'4th Quarter'**
  String get fourthQuarter;

  /// No description provided for @itsNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get itsNumber;

  /// No description provided for @ayat.
  ///
  /// In en, this message translates to:
  /// **'Verses'**
  String get ayat;

  /// No description provided for @select_qirat.
  ///
  /// In en, this message translates to:
  /// **'Select Reading'**
  String get select_qirat;

  /// No description provided for @qirat_hafs.
  ///
  /// In en, this message translates to:
  /// **'Hafs'**
  String get qirat_hafs;

  /// No description provided for @qirat_douri.
  ///
  /// In en, this message translates to:
  /// **'Al-Douri'**
  String get qirat_douri;

  /// No description provided for @qirat_qalon.
  ///
  /// In en, this message translates to:
  /// **'Qalun'**
  String get qirat_qalon;

  /// No description provided for @qirat_shubah.
  ///
  /// In en, this message translates to:
  /// **'Shu\'bah'**
  String get qirat_shubah;

  /// No description provided for @qirat_warsh.
  ///
  /// In en, this message translates to:
  /// **'Warsh'**
  String get qirat_warsh;

  /// No description provided for @downloadQuranError.
  ///
  /// In en, this message translates to:
  /// **'Download error occurred'**
  String get downloadQuranError;

  /// No description provided for @downloadQuranSuccess.
  ///
  /// In en, this message translates to:
  /// **'Downloaded successfully'**
  String get downloadQuranSuccess;

  /// No description provided for @downloadingQuran.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloadingQuran;

  /// No description provided for @download_selected.
  ///
  /// In en, this message translates to:
  /// **'Download Selected'**
  String get download_selected;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @juzNumber.
  ///
  /// In en, this message translates to:
  /// **'Juz {number}'**
  String juzNumber(Object number);

  /// No description provided for @hizbNumber.
  ///
  /// In en, this message translates to:
  /// **'Hizb {number}'**
  String hizbNumber(Object number);

  /// No description provided for @allSurahs.
  ///
  /// In en, this message translates to:
  /// **'All Surahs'**
  String get allSurahs;

  /// No description provided for @twoPageMode.
  ///
  /// In en, this message translates to:
  /// **'Two Page Mode'**
  String get twoPageMode;

  /// No description provided for @singlePageMode.
  ///
  /// In en, this message translates to:
  /// **'Single Page Mode'**
  String get singlePageMode;

  /// No description provided for @quranReaderTitle.
  ///
  /// In en, this message translates to:
  /// **'The Holy Quran'**
  String get quranReaderTitle;

  /// No description provided for @anaOsalyCallBlockingActive.
  ///
  /// In en, this message translates to:
  /// **'Call cancellation during prayer is active'**
  String get anaOsalyCallBlockingActive;

  /// No description provided for @anaOsalyPermissionRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Call Screening Permission Required'**
  String get anaOsalyPermissionRequiredTitle;

  /// No description provided for @anaOsalyPermissionRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'Please grant call screening permission so the app can automatically cancel incoming calls during prayer times'**
  String get anaOsalyPermissionRequiredDesc;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @permissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Permission Granted'**
  String get permissionGranted;

  /// No description provided for @downloadQuranPages.
  ///
  /// In en, this message translates to:
  /// **'Download Quran Pages'**
  String get downloadQuranPages;

  /// No description provided for @downloadQuranPagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Quran pages need to be downloaded for offline reading (Size: ~140 MB)'**
  String get downloadQuranPagesDesc;

  /// No description provided for @downloadQiratConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Download Quran Recitation'**
  String get downloadQiratConfirmTitle;

  /// No description provided for @downloadQiratConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Do you want to download {qiratName} ({size} MB) for offline reading?'**
  String downloadQiratConfirmDesc(Object qiratName, Object size);

  /// No description provided for @startDownload.
  ///
  /// In en, this message translates to:
  /// **'Start Download Now'**
  String get startDownload;

  /// No description provided for @retryDownload.
  ///
  /// In en, this message translates to:
  /// **'Retry Download'**
  String get retryDownload;

  /// No description provided for @downloadProgress.
  ///
  /// In en, this message translates to:
  /// **'{downloaded} MB of {total} MB ({percent}%)'**
  String downloadProgress(Object downloaded, Object percent, Object total);

  /// No description provided for @qiratComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get qiratComingSoon;

  /// No description provided for @radio.
  ///
  /// In en, this message translates to:
  /// **'Quran Radio'**
  String get radio;

  /// No description provided for @radioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Listen to the Holy Quran'**
  String get radioSubtitle;

  /// No description provided for @makkahLive.
  ///
  /// In en, this message translates to:
  /// **'Makkah Live'**
  String get makkahLive;

  /// No description provided for @madinahLive.
  ///
  /// In en, this message translates to:
  /// **'Madinah Live'**
  String get madinahLive;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @recitersList.
  ///
  /// In en, this message translates to:
  /// **'Reciters List'**
  String get recitersList;

  /// No description provided for @searchReciter.
  ///
  /// In en, this message translates to:
  /// **'Search for a reciter...'**
  String get searchReciter;

  /// No description provided for @searchSurah.
  ///
  /// In en, this message translates to:
  /// **'Search for a surah...'**
  String get searchSurah;

  /// No description provided for @listenToSurah.
  ///
  /// In en, this message translates to:
  /// **'Listen to Surah'**
  String get listenToSurah;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get addToPlaylist;

  /// No description provided for @newPlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'New Playlist'**
  String get newPlaylistTitle;

  /// No description provided for @playlistNameHint.
  ///
  /// In en, this message translates to:
  /// **'Playlist Name'**
  String get playlistNameHint;

  /// No description provided for @deletePlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist'**
  String get deletePlaylistTitle;

  /// No description provided for @noSurahsInPlaylist.
  ///
  /// In en, this message translates to:
  /// **'No surahs in this playlist'**
  String get noSurahsInPlaylist;

  /// No description provided for @noRecitersFound.
  ///
  /// In en, this message translates to:
  /// **'No reciters found'**
  String get noRecitersFound;

  /// No description provided for @noSurahsFound.
  ///
  /// In en, this message translates to:
  /// **'No surahs found'**
  String get noSurahsFound;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playbackSpeed;

  /// No description provided for @speedNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal (1.0x)'**
  String get speedNormal;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @offlineAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available Offline'**
  String get offlineAvailable;

  /// No description provided for @downloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Surah downloaded successfully'**
  String get downloadSuccess;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to download surah'**
  String get downloadFailed;

  /// No description provided for @deleteDownload.
  ///
  /// In en, this message translates to:
  /// **'Delete Download'**
  String get deleteDownload;

  /// No description provided for @offlinePlayback.
  ///
  /// In en, this message translates to:
  /// **'Playing Offline'**
  String get offlinePlayback;

  /// No description provided for @downloadedAudios.
  ///
  /// In en, this message translates to:
  /// **'Downloaded Audios'**
  String get downloadedAudios;

  /// No description provided for @noDownloadsYet.
  ///
  /// In en, this message translates to:
  /// **'No downloaded audios yet'**
  String get noDownloadsYet;

  /// No description provided for @hadithBooksTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith & Islamic Books'**
  String get hadithBooksTitle;

  /// No description provided for @hadithBooksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari, Muslim, Forties & Sunnah'**
  String get hadithBooksSubtitle;

  /// No description provided for @searchBooksHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a book or author...'**
  String get searchBooksHint;

  /// No description provided for @allCategory.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategory;

  /// No description provided for @nineBooksCategory.
  ///
  /// In en, this message translates to:
  /// **'Nine Hadith Books'**
  String get nineBooksCategory;

  /// No description provided for @fortiesCategory.
  ///
  /// In en, this message translates to:
  /// **'The Forties'**
  String get fortiesCategory;

  /// No description provided for @otherBooksCategory.
  ///
  /// In en, this message translates to:
  /// **'Other Books'**
  String get otherBooksCategory;

  /// No description provided for @noBooksFound.
  ///
  /// In en, this message translates to:
  /// **'No matching books found'**
  String get noBooksFound;

  /// No description provided for @searchChaptersHint.
  ///
  /// In en, this message translates to:
  /// **'Search in chapters...'**
  String get searchChaptersHint;

  /// No description provided for @noChaptersFound.
  ///
  /// In en, this message translates to:
  /// **'No chapters found'**
  String get noChaptersFound;

  /// No description provided for @searchHadithsHint.
  ///
  /// In en, this message translates to:
  /// **'Search in hadiths...'**
  String get searchHadithsHint;

  /// No description provided for @noHadithsFound.
  ///
  /// In en, this message translates to:
  /// **'No hadiths found'**
  String get noHadithsFound;

  /// No description provided for @hadithWord.
  ///
  /// In en, this message translates to:
  /// **'Hadiths'**
  String get hadithWord;

  /// No description provided for @hadithCopied.
  ///
  /// In en, this message translates to:
  /// **'Hadith copied to clipboard'**
  String get hadithCopied;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @shareAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Hojaty app - Your comprehensive Islamic companion for prayer times, Holy Quran, Athkar, and Islamic occasions.'**
  String get shareAppMessage;

  /// No description provided for @downloadAppPrompt.
  ///
  /// In en, this message translates to:
  /// **'Download the app'**
  String get downloadAppPrompt;

  /// No description provided for @developedByPrompt.
  ///
  /// In en, this message translates to:
  /// **'Developed by Saddaq'**
  String get developedByPrompt;

  /// No description provided for @shareRecitation.
  ///
  /// In en, this message translates to:
  /// **'Share Recitation'**
  String get shareRecitation;

  /// No description provided for @downloadAudioPrompt.
  ///
  /// In en, this message translates to:
  /// **'The audio file must be downloaded first to share it. Would you like to download it now?'**
  String get downloadAudioPrompt;

  /// No description provided for @downloadAndShare.
  ///
  /// In en, this message translates to:
  /// **'Download & Share'**
  String get downloadAndShare;

  /// No description provided for @downloadingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Download in progress, please wait...'**
  String get downloadingInProgress;

  /// No description provided for @searchAthkarHint.
  ///
  /// In en, this message translates to:
  /// **'Search in Athkar & Duas...'**
  String get searchAthkarHint;

  /// No description provided for @hisnAlMuslim.
  ///
  /// In en, this message translates to:
  /// **'Hisn Al-Muslim'**
  String get hisnAlMuslim;

  /// No description provided for @dailyAthkar.
  ///
  /// In en, this message translates to:
  /// **'Daily Athkar'**
  String get dailyAthkar;

  /// No description provided for @noAthkarFound.
  ///
  /// In en, this message translates to:
  /// **'No matching Athkar found'**
  String get noAthkarFound;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @allAthkarCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Categories'**
  String allAthkarCount(Object count);

  /// No description provided for @asmaAllahTitle.
  ///
  /// In en, this message translates to:
  /// **'Names of Allah'**
  String get asmaAllahTitle;

  /// No description provided for @asmaAllahSubtitle.
  ///
  /// In en, this message translates to:
  /// **'99 Beautiful Names with Meanings'**
  String get asmaAllahSubtitle;

  /// No description provided for @searchAsmaHint.
  ///
  /// In en, this message translates to:
  /// **'Search Names of Allah...'**
  String get searchAsmaHint;

  /// No description provided for @noAsmaFound.
  ///
  /// In en, this message translates to:
  /// **'No matching name found'**
  String get noAsmaFound;

  /// No description provided for @asmaCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Names'**
  String asmaCount(Object count);

  /// No description provided for @meaningLabel.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaningLabel;

  /// No description provided for @explanationLabel.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanationLabel;
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
