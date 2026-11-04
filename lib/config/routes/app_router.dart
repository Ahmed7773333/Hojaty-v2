import 'package:flutter/material.dart';
import '../../core/local/user_hive_helper.dart';
import '../../data/mocks/occasions_mock_data.dart';
import '../../features/books/data/models/book_collection_model.dart';
import '../../features/books/data/models/book_info_model.dart';
import '../../features/books/data/models/hadith_item_model.dart';
import '../../features/books/presentation/pages/book_chapters_page.dart';
import '../../features/books/presentation/pages/book_hadiths_page.dart';
import '../../features/books/presentation/pages/books_page.dart';
import '../../features/homelayout/data/models/athkar_category_model.dart';
import '../../features/homelayout/data/models/athkar_detail_args.dart';
import '../../features/homelayout/data/models/occasion_item_model.dart';
import '../../features/homelayout/presentation/pages/app_info_content_page.dart';
import '../../features/homelayout/presentation/pages/athkar_detail_page.dart';
import '../../features/homelayout/presentation/pages/font_settings_page.dart';
import '../../features/homelayout/presentation/pages/font_type_settings_page.dart';
import '../../features/homelayout/presentation/pages/homelayout_page.dart';
import '../../features/homelayout/presentation/pages/istikhara_page.dart';
import '../../features/homelayout/presentation/pages/language_settings_page.dart';
import '../../features/homelayout/presentation/pages/location_settings_page.dart';
import '../../features/homelayout/presentation/pages/notifications_page.dart';
import '../../features/homelayout/presentation/pages/occasion_detail_page.dart';
import '../../features/homelayout/presentation/pages/prayer_calculation_settings_page.dart';
import '../../features/homelayout/presentation/pages/prayer_times_page.dart';
import '../../features/homelayout/presentation/pages/sebha_page.dart';
import '../../features/onboarding/presentation/pages/language_selection_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/quran/data/models/page_data_model.dart';
import '../../features/quran/presentation/pages/quran_fehres_page.dart';
import '../../features/quran/presentation/pages/quran_juzs_page.dart';
import '../../features/quran/presentation/pages/quran_reader_page.dart';
import '../../features/quran/presentation/pages/quran_search_page.dart';
import '../../features/quran/presentation/pages/quran_tafseer_page.dart';
import '../../features/radio/data/models/live_stream_args.dart';
import '../../features/radio/data/models/playlist_model.dart';
import '../../features/radio/data/models/reciter_model.dart';
import '../../features/radio/data/models/surah_audio_args.dart';
import '../../features/radio/presentation/pages/live_stream_page.dart';
import '../../features/radio/presentation/pages/playlist_details_page.dart';
import '../../features/radio/presentation/pages/playlists_page.dart';
import '../../features/radio/presentation/pages/radio_page.dart';
import '../../features/radio/presentation/pages/reader_surahs_page.dart';
import '../../features/radio/presentation/pages/surah_audio_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String prayerTimes = '/prayer-times';
  static const String notifications = '/notifications';
  static const String athkarDetail = '/athkar-detail';
  static const String istikhara = '/istikhara';
  static const String sebha = '/sebha';
  static const String occasionDetail = '/occasion-detail';
  static const String languageSettings = '/language-settings';
  static const String prayerCalculationSettings = '/prayer-calculation-settings';
  static const String locationSettings = '/location-settings';
  static const String fontSettings = '/font-settings';
  static const String fontTypeSettings = '/font-type-settings';
  static const String appInfoContent = '/app-info-content';
  static const String login = '/login';
  static const String quranReader = '/quran-reader';
  static const String quranFehres = '/quran-fehres';
  static const String quranJuzs = '/quran-juzs';
  static const String quranSearch = '/quran-search';
  static const String quranTafseer = '/quran-tafseer';
  static const String radio = '/radio';
  static const String readerSurahs = '/reader-surahs';
  static const String surahAudio = '/surah-audio';
  static const String playlists = '/playlists';
  static const String playlistDetails = '/playlist-details';
  static const String liveStream = '/live-stream';
  static const String books = '/books';
  static const String bookChapters = '/book-chapters';
  static const String bookHadiths = '/book-hadiths';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        final user = UserHiveHelper.getUser();
        final bool isCompleted = user?.onBoardingCompleted ?? false;
        if (isCompleted) {
          return MaterialPageRoute(
            builder: (_) => const HomelayoutPage(),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const LanguageSelectionPage(),
          settings: settings,
        );
      case AppRoutes.languageSelection:
        return MaterialPageRoute(
          builder: (_) => const LanguageSelectionPage(),
          settings: settings,
        );
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingPage(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomelayoutPage(),
          settings: settings,
        );
      case AppRoutes.prayerTimes:
        final initialTab = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => PrayerTimesPage(initialTabIndex: initialTab),
          settings: settings,
        );
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsPage(),
          settings: settings,
        );
      case AppRoutes.athkarDetail:
        if (settings.arguments is AthkarDetailArgs) {
          final args = settings.arguments as AthkarDetailArgs;
          return MaterialPageRoute(
            builder: (_) => AthkarDetailPage(
              title: args.title,
              items: args.items,
              categoryType: args.categoryType,
            ),
            settings: settings,
          );
        } else if (settings.arguments is AthkarCategoryModel) {
          final category = settings.arguments as AthkarCategoryModel;
          return MaterialPageRoute(
            builder: (_) => AthkarDetailPage(
              title: '',
              categoryModel: category,
            ),
            settings: settings,
          );
        }
        final title = settings.arguments as String? ?? 'أذكار الصباح';
        return MaterialPageRoute(
          builder: (_) => AthkarDetailPage(title: title),
          settings: settings,
        );
      case AppRoutes.istikhara:
        return MaterialPageRoute(
          builder: (_) => const IstikharaPage(),
          settings: settings,
        );
      case AppRoutes.sebha:
        return MaterialPageRoute(
          builder: (_) => const SebhaPage(),
          settings: settings,
        );
      case AppRoutes.occasionDetail:
        final occasion = settings.arguments as OccasionItemModel? ??
            OccasionsMockData.nextOccasion;
        return MaterialPageRoute(
          builder: (_) => OccasionDetailPage(occasion: occasion),
          settings: settings,
        );
      case AppRoutes.languageSettings:
        return MaterialPageRoute(
          builder: (_) => const LanguageSettingsPage(),
          settings: settings,
        );
      case AppRoutes.prayerCalculationSettings:
        return MaterialPageRoute(
          builder: (_) => const PrayerCalculationSettingsPage(),
          settings: settings,
        );
      case AppRoutes.locationSettings:
        return MaterialPageRoute(
          builder: (_) => const LocationSettingsPage(),
          settings: settings,
        );
      case AppRoutes.fontSettings:
        return MaterialPageRoute(
          builder: (_) => const FontSettingsPage(),
          settings: settings,
        );
      case AppRoutes.fontTypeSettings:
        return MaterialPageRoute(
          builder: (_) => const FontTypeSettingsPage(),
          settings: settings,
        );
      case AppRoutes.appInfoContent:
        if (settings.arguments is Map) {
          final args = settings.arguments as Map;
          final contentType = args['contentType'] as AppContentType? ?? AppContentType.custom;
          final title = (args['title'] as String?) ?? '';
          final content = (args['content'] as String?) ?? '';
          return MaterialPageRoute(
            builder: (_) => AppInfoContentPage(
              contentType: contentType,
              title: title,
              content: content,
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const AppInfoContentPage(
            title: '',
            content: '',
          ),
          settings: settings,
        );
      case AppRoutes.quranReader:
        final initialPage = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => QuranReaderPage(initialPage: initialPage),
          settings: settings,
        );
      case AppRoutes.quranFehres:
        return MaterialPageRoute(
          builder: (_) => const QuranFehresPage(),
          settings: settings,
        );
      case AppRoutes.quranJuzs:
        return MaterialPageRoute(
          builder: (_) => const QuranJuzsPage(),
          settings: settings,
        );
      case AppRoutes.quranSearch:
        return MaterialPageRoute(
          builder: (_) => const QuranSearchPage(),
          settings: settings,
        );
      case AppRoutes.quranTafseer:
        final extra = settings.arguments as Map<String, dynamic>? ?? {};
        final pageData = extra['pageData'] as PageDataModel?;
        final pageNum = extra['pageNum'] as int? ?? 1;
        final highlightVerse = extra['highlightVerse'] as int?;
        return MaterialPageRoute(
          builder: (_) => QuranTafseerPage(
            pageData: pageData,
            pageNum: pageNum,
            highlightVerse: highlightVerse,
          ),
          settings: settings,
        );
      case AppRoutes.radio:
        return MaterialPageRoute(
          builder: (_) => const RadioPage(),
          settings: settings,
        );
      case AppRoutes.readerSurahs:
        final reciter = settings.arguments as ReciterModel;
        return MaterialPageRoute(
          builder: (_) => ReaderSurahsPage(reciter: reciter),
          settings: settings,
        );
      case AppRoutes.surahAudio:
        final args = settings.arguments as SurahAudioArgs;
        return MaterialPageRoute(
          builder: (_) => SurahAudioPage(args: args),
          settings: settings,
        );
      case AppRoutes.playlists:
        return MaterialPageRoute(
          builder: (_) => const PlaylistsPage(),
          settings: settings,
        );
      case AppRoutes.playlistDetails:
        final playlist = settings.arguments as PlaylistModel;
        return MaterialPageRoute(
          builder: (_) => PlaylistDetailsPage(playlist: playlist),
          settings: settings,
        );
      case AppRoutes.liveStream:
        final args = settings.arguments as LiveStreamArgs;
        return MaterialPageRoute(
          builder: (_) => LiveStreamPage(args: args),
          settings: settings,
        );
      case AppRoutes.books:
        return MaterialPageRoute(
          builder: (_) => const BooksPage(),
          settings: settings,
        );
      case AppRoutes.bookChapters:
        final map = settings.arguments as Map<String, dynamic>;
        final book = map['book'] as BookInfoModel;
        final collection = map['collection'] as BookCollectionModel;
        return MaterialPageRoute(
          builder: (_) => BookChaptersPage(book: book, collection: collection),
          settings: settings,
        );
      case AppRoutes.bookHadiths:
        final map = settings.arguments as Map<String, dynamic>;
        final bookTitle = map['bookTitle'] as String;
        final chapterTitle = map['chapterTitle'] as String;
        final hadiths = map['hadiths'] as List<HadithItemModel>;
        return MaterialPageRoute(
          builder: (_) => BookHadithsPage(
            bookTitle: bookTitle,
            chapterTitle: chapterTitle,
            hadiths: hadiths,
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
