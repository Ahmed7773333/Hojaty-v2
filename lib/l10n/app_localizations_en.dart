// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get chooseLanguageSubtitle =>
      'You can change the language later in settings';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get arabicSubtitle => 'Arabic';

  @override
  String get englishLanguage => 'English';

  @override
  String get englishSubtitle => 'English';

  @override
  String get continueButton => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get skipAll => 'Skip all';

  @override
  String get next => 'Next';

  @override
  String get deleteDownloadConfirm =>
      'Are you sure you want to delete this book ?';

  @override
  String get getStarted => 'Start now';

  @override
  String get quranFehres => 'Quran Fehres';

  @override
  String get onboardingSlide1Subtitle => 'Accurate times for every prayer';

  @override
  String get onboardingSlide1Title => 'Your prayer on time';

  @override
  String get onboardingSlide1Desc =>
      'We provide accurate prayer times based on your location, with notifications reminding you of every prayer on time.';

  @override
  String get onboardingSlide2Subtitle => 'Read and glorify at any time';

  @override
  String get onboardingSlide2Title => 'Quran and Athkar always with you';

  @override
  String get onboardingSlide2Desc =>
      'Browse the Holy Quran with a peaceful reading experience, and perform morning and evening Athkar with an interactive counter.';

  @override
  String get onboardingSlide3Subtitle => 'Smart believer feature';

  @override
  String get onboardingSlide3Title => 'Hojaty';

  @override
  String get onboardingSlide3Desc =>
      'When someone calls you during prayer, \"I am praying\" is sent to them automatically — because prayer time is sacred.';

  @override
  String get onboardingSlide4Subtitle => 'Hijri calendar and occasions';

  @override
  String get onboardingSlide4Title => 'Stay close to your religious occasions';

  @override
  String get onboardingSlide4Desc =>
      'Follow Islamic occasions, fasting days and Ramadan Imsakiya, with notifications reminding you before each occasion.';

  @override
  String get homeLocation => 'Cairo, Egypt';

  @override
  String get homeGregorianDate => 'Saturday, 16 August 2026';

  @override
  String get homeHijriDate => '18 Muharram 1447 AH';

  @override
  String get nextPrayerTitle => 'Next Prayer';

  @override
  String get nextPrayerRemaining => 'Time Remaining';

  @override
  String upcomingOccasionBanner(Object days, Object title) {
    return 'Upcoming Occasion: $title — $days days left';
  }

  @override
  String get prayerTimesSectionTitle => 'Prayer Times';

  @override
  String get details => 'Details';

  @override
  String get currentPrayerBadge => 'Current Prayer';

  @override
  String get nextPrayerBadge => 'Next Prayer';

  @override
  String get fajr => 'Fajr';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get isha => 'Isha';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get quranKareem => 'Holy Quran';

  @override
  String get continueReading => 'Continue Reading';

  @override
  String get quranStatsSubtitle => '114 Surahs - 30 Juz - 60 Hizb';

  @override
  String get searchSurahHint => 'Search for a surah...';

  @override
  String get surahsListTitle => 'Surahs List';

  @override
  String get surahBaqarah => 'Surah Al-Baqarah';

  @override
  String ayahNumber(Object number) {
    return 'Ayah $number';
  }

  @override
  String ayahCountText(Object count) {
    return '$count Ayahs';
  }

  @override
  String get meccanType => 'Meccan';

  @override
  String get medinanType => 'Medinan';

  @override
  String get athkar => 'Athkar';

  @override
  String get morningAthkar => 'Morning Athkar';

  @override
  String get eveningAthkar => 'Evening Athkar';

  @override
  String get sleepAthkar => 'Sleep Athkar';

  @override
  String get afterPrayerAthkar => 'After Prayer Athkar';

  @override
  String get miscAthkar => 'Various Athkar';

  @override
  String get electronicSebha => 'Electronic Sebha';

  @override
  String get sebhaSubtitle => 'Electronic counter for your tasbeeh';

  @override
  String get reset => 'Reset';

  @override
  String get salatAlIstikhara => 'Salat Al-Istikhara';

  @override
  String get athkarSubtitle => 'Daily Athkar for Muslims';

  @override
  String countThikr(Object count) {
    return '$count Athkar';
  }

  @override
  String get requiredLabel => 'Required';

  @override
  String timesUnit(Object count) {
    return '$count Time';
  }

  @override
  String get tapLabel => 'Tap';

  @override
  String get istikharaStepsTitle => 'Prayer Steps';

  @override
  String get istikharaDuaTitle => 'Supplication After Prayer:';

  @override
  String get occasions => 'Occasions';

  @override
  String get occasionsTitle => 'Islamic Occasions';

  @override
  String get occasionsSubtitle => 'Hijri Calendar & Religious Occasions';

  @override
  String get tabOccasions => 'Occasions';

  @override
  String get tabCalendar => 'Calendar';

  @override
  String get tabRamadan => 'Ramadan';

  @override
  String get upcomingOccasion => 'Upcoming Occasion';

  @override
  String get upcomingOccasionsList => 'Upcoming Occasions';

  @override
  String get prophetBirthday => 'Prophet\'s Birthday';

  @override
  String get eidAlAdha => 'Eid Al-Adha';

  @override
  String get hijriNewYear => 'Hijri New Year';

  @override
  String get ashura => 'Ashura';

  @override
  String daysRemainingUnit(Object count) {
    return '$count days';
  }

  @override
  String daysRemainingText(Object count) {
    return '$count days left';
  }

  @override
  String get hijriCalendarTitle => 'Hijri Calendar';

  @override
  String get gregorianCalendarTitle => 'Gregorian Calendar';

  @override
  String get today => 'Today';

  @override
  String get returnToToday => 'Back to Today';

  @override
  String get ramadanKareem => 'Ramadan Kareem';

  @override
  String get ramadanDay1Title => 'Day 1 of Ramadan';

  @override
  String get ramadanDay1Date => '1 Ramadan 1448 AH';

  @override
  String get remainingOnRamadan => 'Remaining until Ramadan';

  @override
  String get ramadanImsakiya => 'Ramadan Imsakiya';

  @override
  String get dayColumn => 'Day';

  @override
  String hijriYearLabel(Object year) {
    return '$year AH';
  }

  @override
  String get occasionDetailsTitle => 'Occasion Details';

  @override
  String get hijriDateLabel => 'Hijri Date';

  @override
  String get gregorianDateLabel => 'Gregorian Date';

  @override
  String get aboutOccasionLabel => 'About Occasion';

  @override
  String get aboutProphetBirthdayDesc =>
      'Prophet\'s Birthday commemorates the birth of the Islamic prophet Muhammad, peace be upon him.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Customize your experience';

  @override
  String get locationAndGovSection => 'Location & Governorate';

  @override
  String get currentLocationLabel => 'Current Location';

  @override
  String get governorateLabel => 'Governorate';

  @override
  String get cairoLocation => 'Cairo, Egypt';

  @override
  String get cairoGov => 'Cairo';

  @override
  String get prayerTimesAndAdhanSection => 'Prayer Times & Adhan';

  @override
  String get prayerTimesCalcSettings => 'Prayer Times Calculation Settings';

  @override
  String get egyptSurveyAuthority => 'Egyptian General Authority of Survey';

  @override
  String get notificationTypeLabel => 'Notification Type';

  @override
  String get prayerAlertsLabel => 'Prayer Alerts';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get generalNotificationsLabel => 'General Notifications';

  @override
  String get occasionsNotificationsLabel => 'Occasions Notifications';

  @override
  String get athkarNotificationsLabel => 'Athkar Notifications';

  @override
  String get fontSection => 'Font';

  @override
  String get fontSizeLabel => 'Font Size';

  @override
  String get fontTypeLabel => 'Font Type';

  @override
  String get naskhFont => 'Naskh';

  @override
  String get languageAndThemeSection => 'Language & Appearance';

  @override
  String get darkModeLabel => 'Dark Mode';

  @override
  String get languageLabel => 'Language';

  @override
  String get aboutAppSection => 'About App';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get termsAndConditionsLabel => 'Terms and Conditions';

  @override
  String get languageSettingsTitle => 'Language';

  @override
  String get languageSettingsSubtitle =>
      'Choose application interface language';

  @override
  String get prayerCalcSettingsTitle => 'Prayer & Adhan Settings';

  @override
  String get prayerCalcSettingsSubtitle => 'Select prayer calculation method';

  @override
  String get calcMethodSectionTitle => 'Prayer Times Calculation Method';

  @override
  String get adhanSoundSectionTitle => 'Adhan Sound';

  @override
  String get mwlTitle => 'Muslim World League';

  @override
  String get mwlDesc => 'Most common in Egypt and Arab countries';

  @override
  String get isnaTitle => 'Islamic Society of North America';

  @override
  String get isnaDesc => 'ISNA';

  @override
  String get egyptSurveyTitle => 'Egyptian General Authority of Survey';

  @override
  String get egyptSurveyDesc => 'Recommended in Egypt';

  @override
  String get ummAlQuraTitle => 'Umm Al-Qura, Makkah';

  @override
  String get ummAlQuraDesc => 'Saudi Arabia';

  @override
  String get karachiTitle => 'University of Islamic Sciences, Karachi';

  @override
  String get karachiDesc => 'Pakistan, Afghanistan & India';

  @override
  String get adhanMakkah => 'Adhan Makkah Al-Mukarramah';

  @override
  String get adhanMadinah => 'Adhan Al-Madinah Al-Munawwarah';

  @override
  String get adhanAlafasy => 'Sheikh Mishary Alafasy';

  @override
  String get locationSettingsTitle => 'Location & Governorate';

  @override
  String get locationSettingsSubtitle =>
      'Set your location for accurate prayer times';

  @override
  String get fontSettingsTitle => 'Font Settings';

  @override
  String get fontSettingsSubtitle =>
      'Customize font size and style for comfortable reading';

  @override
  String get fontPreviewText =>
      'In the name of Allah, the Entirely Merciful, the Especially Merciful';

  @override
  String get fontTypeSettingsTitle => 'Font Type';

  @override
  String get fontTypeSettingsSubtitle =>
      'Choose font style for Quran and Athkar';

  @override
  String get fontTypeSectionTitle => 'Available Font Types';

  @override
  String get uthmaniFont => 'Uthmani';

  @override
  String get amiriFont => 'Amiri';

  @override
  String get naskhFontDesc => 'Clear and easy to read';

  @override
  String get uthmaniFontDesc => 'Standard Quranic script';

  @override
  String get amiriFontDesc => 'Classical Arabic typography';

  @override
  String get selectedFontLabel => 'Selected Font';

  @override
  String get privacyPolicyContent =>
      'We are committed to protecting your privacy and personal data. The Hojaty app does not collect, sell, or share your private data with any third parties.';

  @override
  String get termsAndConditionsContent =>
      'By using the Hojaty application, you agree to comply with all terms and guidelines detailed herein. The app is provided for religious purposes including prayer reminders, Quran reading, and daily Athkar.';

  @override
  String get hijriCalendar => 'Hijri Calendar';

  @override
  String get prayerSchedule => 'Full Schedule';

  @override
  String get exclusiveFeature => 'Exclusive Feature';

  @override
  String get anaOsalyTitle => 'Hojaty';

  @override
  String get anaOsalyPromoDesc =>
      'During prayer time, an automated \"I am praying\" message is sent to callers';

  @override
  String get enableFeature => 'Enable Feature';

  @override
  String get navHome => 'Home';

  @override
  String get navQuran => 'Quran';

  @override
  String get navAthkar => 'Athkar';

  @override
  String get navOccasions => 'Occasions';

  @override
  String get navMore => 'More';

  @override
  String get fullPrayerTimesTitle => 'Prayer Times';

  @override
  String get prayerTimesAddress =>
      '2 Hesham Labib, Makram Ebeid, Nasr City, Cairo, Egypt';

  @override
  String get changeLocation => 'Change Location';

  @override
  String get tabTimes => 'Times';

  @override
  String get tabAdhanSettings => 'Adhan Settings';

  @override
  String get tabAnaOsaly => 'Hojaty';

  @override
  String get enableAllPrayersNotifications =>
      'Enable All Prayers Notifications';

  @override
  String get allPrayersNotificationsDesc =>
      'Receive notifications before each prayer';

  @override
  String get prayerNotificationTypeSection => 'Prayer Notification Type';

  @override
  String get fullAdhanTitle => 'Full Adhan';

  @override
  String get fullAdhanDesc => 'Plays full Adhan at prayer time';

  @override
  String get shortAlertTitle => 'Short Alert';

  @override
  String get shortAlertDesc => '\"Allahu Akbar, Allahu Akbar\" then stops';

  @override
  String get anaOsalyHeroSubtitle =>
      'When enabled, callers are automatically informed that you are praying.';

  @override
  String get anaOsalyMessageLang => 'Message Language';

  @override
  String get anaOsalyToggleTitle => 'Enable Hojaty Feature';

  @override
  String get anaOsalyToggleSubtitle =>
      'Activates automatically during prayer times';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String minAgo(Object count) {
    return '$count mins ago';
  }

  @override
  String get hourAgo => '1 hour ago';

  @override
  String hoursAgo(Object count) {
    return '$count hours ago';
  }

  @override
  String get anaOsalyMessageAr => 'حچتي';

  @override
  String get anaOsalyMessageEn => 'I am praying';

  @override
  String get exitAppTitle => 'Exit App';

  @override
  String get exitAppMessage => 'Are you sure you want to exit the app?';

  @override
  String get exitAppConfirm => 'Exit';

  @override
  String get exitAppCancel => 'Cancel';

  @override
  String get surahs => 'Surahs';

  @override
  String get quranSearch => 'Search';

  @override
  String get quranSearchHint => 'Search Quran verses...';

  @override
  String get quranNoResults => 'No results found';

  @override
  String get quranTafseer => 'Tafseer';

  @override
  String get quranJuzs => 'Juzs & Hizbs';

  @override
  String get quranPageLabel => 'Page';

  @override
  String get safha => 'Page';

  @override
  String get qiraat => 'Readings';

  @override
  String get surahs_list => 'Surahs Index';

  @override
  String get firstQuarter => '1st Quarter';

  @override
  String get secondQuarter => '2nd Quarter';

  @override
  String get thirdQuarter => '3rd Quarter';

  @override
  String get fourthQuarter => '4th Quarter';

  @override
  String get itsNumber => 'Number';

  @override
  String get ayat => 'Verses';

  @override
  String get select_qirat => 'Select Reading';

  @override
  String get qirat_hafs => 'Hafs';

  @override
  String get qirat_douri => 'Al-Douri';

  @override
  String get qirat_qalon => 'Qalun';

  @override
  String get qirat_shubah => 'Shu\'bah';

  @override
  String get qirat_warsh => 'Warsh';

  @override
  String get downloadQuranError => 'Download error occurred';

  @override
  String get downloadQuranSuccess => 'Downloaded successfully';

  @override
  String get downloadingQuran => 'Downloading...';

  @override
  String get download_selected => 'Download Selected';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String juzNumber(Object number) {
    return 'Juz $number';
  }

  @override
  String hizbNumber(Object number) {
    return 'Hizb $number';
  }

  @override
  String get allSurahs => 'All Surahs';

  @override
  String get twoPageMode => 'Two Page Mode';

  @override
  String get singlePageMode => 'Single Page Mode';

  @override
  String get quranReaderTitle => 'The Holy Quran';

  @override
  String get anaOsalyCallBlockingActive =>
      'Call cancellation during prayer is active';

  @override
  String get anaOsalyPermissionRequiredTitle =>
      'Call Screening Permission Required';

  @override
  String get anaOsalyPermissionRequiredDesc =>
      'Please grant call screening permission so the app can automatically cancel incoming calls during prayer times';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get permissionGranted => 'Permission Granted';

  @override
  String get downloadQuranPages => 'Download Quran Pages';

  @override
  String get downloadQuranPagesDesc =>
      'Quran pages need to be downloaded for offline reading (Size: ~140 MB)';

  @override
  String get downloadQiratConfirmTitle => 'Download Quran Recitation';

  @override
  String downloadQiratConfirmDesc(Object qiratName, Object size) {
    return 'Do you want to download $qiratName ($size MB) for offline reading?';
  }

  @override
  String get startDownload => 'Start Download Now';

  @override
  String get retryDownload => 'Retry Download';

  @override
  String downloadProgress(Object downloaded, Object percent, Object total) {
    return '$downloaded MB of $total MB ($percent%)';
  }

  @override
  String get qiratComingSoon => 'Coming Soon';

  @override
  String get radio => 'Quran Radio';

  @override
  String get radioSubtitle => 'Listen to the Holy Quran';

  @override
  String get makkahLive => 'Makkah Live';

  @override
  String get madinahLive => 'Madinah Live';

  @override
  String get playlists => 'Playlists';

  @override
  String get recitersList => 'Reciters List';

  @override
  String get searchReciter => 'Search for a reciter...';

  @override
  String get searchSurah => 'Search for a surah...';

  @override
  String get listenToSurah => 'Listen to Surah';

  @override
  String get addToPlaylist => 'Add to Playlist';

  @override
  String get newPlaylistTitle => 'New Playlist';

  @override
  String get playlistNameHint => 'Playlist Name';

  @override
  String get deletePlaylistTitle => 'Delete Playlist';

  @override
  String get noSurahsInPlaylist => 'No surahs in this playlist';

  @override
  String get noRecitersFound => 'No reciters found';

  @override
  String get noSurahsFound => 'No surahs found';

  @override
  String get nowPlaying => 'Now Playing';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get speedNormal => 'Normal (1.0x)';

  @override
  String get create => 'Create';

  @override
  String get favorites => 'Favorites';

  @override
  String get download => 'Download';

  @override
  String get downloading => 'Downloading...';

  @override
  String get offlineAvailable => 'Available Offline';

  @override
  String get downloadSuccess => 'Surah downloaded successfully';

  @override
  String get downloadFailed => 'Failed to download surah';

  @override
  String get deleteDownload => 'Delete Download';

  @override
  String get offlinePlayback => 'Playing Offline';

  @override
  String get downloadedAudios => 'Downloaded Audios';

  @override
  String get noDownloadsYet => 'No downloaded audios yet';

  @override
  String get hadithBooksTitle => 'Hadith & Islamic Books';

  @override
  String get hadithBooksSubtitle =>
      'Sahih al-Bukhari, Muslim, Forties & Sunnah';

  @override
  String get searchBooksHint => 'Search for a book or author...';

  @override
  String get allCategory => 'All';

  @override
  String get nineBooksCategory => 'Nine Hadith Books';

  @override
  String get fortiesCategory => 'The Forties';

  @override
  String get otherBooksCategory => 'Other Books';

  @override
  String get noBooksFound => 'No matching books found';

  @override
  String get searchChaptersHint => 'Search in chapters...';

  @override
  String get noChaptersFound => 'No chapters found';

  @override
  String get searchHadithsHint => 'Search in hadiths...';

  @override
  String get noHadithsFound => 'No hadiths found';

  @override
  String get hadithWord => 'Hadiths';

  @override
  String get hadithCopied => 'Hadith copied to clipboard';

  @override
  String get copy => 'Copy';

  @override
  String get delete => 'Delete';

  @override
  String get shareApp => 'Share App';

  @override
  String get shareAppMessage =>
      'Hojaty app - Your comprehensive Islamic companion for prayer times, Holy Quran, Athkar, and Islamic occasions.';

  @override
  String get downloadAppPrompt => 'Download the app';

  @override
  String get developedByPrompt => 'Developed by Saddaq';

  @override
  String get shareRecitation => 'Share Recitation';

  @override
  String get downloadAudioPrompt =>
      'The audio file must be downloaded first to share it. Would you like to download it now?';

  @override
  String get downloadAndShare => 'Download & Share';

  @override
  String get downloadingInProgress => 'Download in progress, please wait...';

  @override
  String get searchAthkarHint => 'Search in Athkar & Duas...';

  @override
  String get hisnAlMuslim => 'Hisn Al-Muslim';

  @override
  String get dailyAthkar => 'Daily Athkar';

  @override
  String get noAthkarFound => 'No matching Athkar found';

  @override
  String get searchResults => 'Search Results';

  @override
  String allAthkarCount(Object count) {
    return '$count Categories';
  }
}
