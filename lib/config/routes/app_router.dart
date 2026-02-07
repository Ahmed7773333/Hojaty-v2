import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/presentation/pages/azkar_page.dart';
import '../../features/quraan/presentation/bloc/quraan_bloc.dart';
import '../../features/home/presentation/pages/home_layout.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/prayers/presentation/pages/prayers_page.dart';
import '../../features/home/presentation/pages/ahadith_page.dart';
import '../../features/home/presentation/pages/allah_names_page.dart';
import '../../features/home/presentation/pages/duaas_page.dart';
import '../../features/home/presentation/pages/prophet_page.dart';
import '../../features/home/presentation/pages/other_books_page.dart';
import '../../features/home/presentation/pages/qibla_page.dart';
import '../../features/home/presentation/pages/ramadan_page.dart';
import '../../features/home/presentation/pages/sebha_page.dart';
import '../../features/settings/presentation/pages/about_app_page.dart';
import '../../features/settings/presentation/pages/contact_us_page.dart';
import '../../features/settings/presentation/pages/notifications_page.dart';
import '../../features/settings/presentation/pages/privacy_policy_page.dart';

import '../../features/radio/presentation/pages/radio_page.dart';
import '../../features/radio/presentation/pages/live_stream_page.dart';
import '../../features/radio/presentation/pages/playlists_screen.dart';
import '../../features/radio/presentation/pages/playlist_details_screen.dart';
import '../../features/radio/data/models/playlist_model.dart';
import '../../features/radio/presentation/pages/reader_surahs_page.dart';
import '../../features/radio/data/models/readers_response.dart';
import '../../features/radio/presentation/pages/surah_audio_page.dart';

import '../../core/constants/surahs_list.dart';
import '../../core/di/injector.dart';
import '../../features/quraan/presentation/bloc/quraan_event.dart';

import '../../features/quraan/presentation/pages/quraan_page.dart';
import '../../features/quraan/presentation/pages/fehres.dart';
import '../../features/quraan/presentation/pages/juzs.dart';
import '../../features/quraan/presentation/pages/tafseer.dart';
import '../../features/quraan/presentation/pages/search.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home'; // HomeLayout

  // Home Features
  static const String ahadith = '/ahadith';
  static const String allahNames = '/allah_names';
  static const String duaas = '/duaas';
  static const String prophet = '/prophet';
  static const String prophetsStories = '/prophets_stories';
  static const String qibla = '/qibla';
  static const String ramadan = '/ramadan';
  static const String sebha = '/sebha';
  static const String azkar = '/azkar';

  // Prayers
  static const String prayers = '/prayers';

  // Radio
  static const String radio = '/radio';
  static const String liveStream = '/live_stream';
  static const String playlists = '/playlists';
  static const String playlistDetails = '/playlist_details';
  static const String readerSurahs = '/reader_surahs';
  static const String surahAudio = '/surah_audio';

  // Quraan
  static const String quraan = '/quraan';
  static const String fehres = '/fehres';
  static const String juzs = '/juzs';
  static const String tafseer = '/tafseer';
  static const String search = '/search';

  // Settings
  static const String settings = '/settings';
  static const String aboutApp = '/about_app';
  static const String privacyPolicy = '/privacy_policy';
  static const String contactUs = '/contact_us';
  static const String notifications = '/notifications';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeLayout());

      // Home Features
      case AppRoutes.ahadith:
        return MaterialPageRoute(builder: (_) => const AhadithPage());
      case AppRoutes.allahNames:
        return MaterialPageRoute(builder: (_) => const AllahNamesPage());
      case AppRoutes.duaas:
        return MaterialPageRoute(builder: (_) => const DuaasPage());
      case AppRoutes.prophet:
        return MaterialPageRoute(builder: (_) => const ProphetPage());
      case AppRoutes.prophetsStories:
        return MaterialPageRoute(builder: (_) => const ProphetsStoriesPage());
      case AppRoutes.qibla:
        return MaterialPageRoute(builder: (_) => const QiblaPage());
      case AppRoutes.ramadan:
        return MaterialPageRoute(builder: (_) => const RamadanPage());
      case AppRoutes.sebha:
        return MaterialPageRoute(builder: (_) => const SebhaPage());
      case AppRoutes.azkar:
        return MaterialPageRoute(builder: (_) => const AzkarPage());

      // Prayers
      case AppRoutes.prayers:
        return MaterialPageRoute(builder: (_) => const PrayersPage());

      // Radio
      case AppRoutes.radio:
        return MaterialPageRoute(builder: (_) => const RadioPage());
      case AppRoutes.liveStream:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => LiveStreamPage(
            streamUrl: args['streamUrl'] as String,
            title: args['title'] as String,
          ),
        );
      case AppRoutes.playlists:
        return MaterialPageRoute(builder: (_) => const PlaylistsScreen());
      case AppRoutes.playlistDetails:
        final playlist = settings.arguments as PlaylistModel;
        return MaterialPageRoute(
          builder: (_) => PlaylistDetailsScreen(playlist: playlist),
        );
      case AppRoutes.readerSurahs:
        final reciter = settings.arguments as Reciters;
        return MaterialPageRoute(
          builder: (_) => ReaderSurahsPage(reciter: reciter),
        );
      case AppRoutes.surahAudio:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SurahAudioPage(
            surah: args['surah'] as Surah,
            serverUrl: args['serverUrl'] as String,
            reciterName: args['reciterName'] as String,
          ),
        );

      // Quraan
      case AppRoutes.quraan:
        return MaterialPageRoute(builder: (_) => const QuraanPage());
      case AppRoutes.fehres:
        return MaterialPageRoute<int>(builder: (_) => const FehrsPage());
      case AppRoutes.juzs:
        return MaterialPageRoute<int>(
          builder: (_) => BlocProvider(
            create: (_) => injector<QuraanBloc>()..add(LoadQuraanData()),
            child: const Guzs(),
          ),
        );
      case AppRoutes.tafseer:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TafseerPage(
            content: args['content'] as String,
            pageNum: args['pageNum'] as String,
          ),
        );
      case AppRoutes.search:
        return MaterialPageRoute<int>(
          builder: (_) => BlocProvider(
            create: (_) => injector<QuraanBloc>()..add(LoadQuraanData()),
            child: const SearchPage(),
          ),
        );

      // Settings
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.aboutApp:
        return MaterialPageRoute(builder: (_) => const AboutAppPage());
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      case AppRoutes.contactUs:
        return MaterialPageRoute(builder: (_) => const ContactUsPage());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
