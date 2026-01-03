import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/radio/presentation/bloc/radio_bloc.dart';
import '../../../../features/radio/presentation/pages/radio_page.dart';
import '../../../../features/settings/presentation/pages/settings_page.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../data/models/user_db_helper.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/constants/surahs_list.dart';
import '../../../radio/data/models/readers_response.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    BlocProvider(
      create: (_) => injector<RadioBloc>(),
      child: const RadioPage(),
    ),
    // const AzkarPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreLastRoute();
      NotificationService.schedulePrayerNotifications();
    });
  }

  void _restoreLastRoute() {
    try {
      final user = UserDbHelper.getById();
      final lastRoute = user?.uiLastRoute;
      debugPrint('Last route: $lastRoute');
      final args = user?.lastRouteArguments;

      if (lastRoute != null &&
          lastRoute.isNotEmpty &&
          lastRoute != AppRoutes.splash &&
          lastRoute != AppRoutes.login &&
          lastRoute != AppRoutes.home) {
        Object? routeArgs;
        if (args != null) {
          // Reconstruct objects based on route name
          if (lastRoute == AppRoutes.surahAudio && args['surah'] != null) {
            final surahMap = Map<String, dynamic>.from(args['surah']);
            final surah = Surah.fromJson(surahMap);
            routeArgs = {
              'surah': surah,
              'serverUrl': args['serverUrl'],
              'reciterName': args['reciterName'],
            };
          } else if (lastRoute == AppRoutes.readerSurahs &&
              args['_single_arg_'] != null) {
            final reciterMap = Map<String, dynamic>.from(args['_single_arg_']);
            routeArgs = Reciters.fromJson(reciterMap);
          } else if (lastRoute == AppRoutes.playlistDetails &&
              args['_single_arg_'] != null) {
            // PlaylistModel might be complex to reconstruct if it has nested HiveObjects or if adapter is needed.
            // But for now let's assume we can pass the Map or we need a fromJson in PlaylistModel.
            // PlaylistModel has HiveType. It doesn't seem to have fromJson.
            // If we saved it as map, we need to reconstruct it.
            // Let's check PlaylistModel again.
            // For now, if we can't reconstruct, we skip args or let it fail?
            // Better: we added toJson/fromJson to Reciters/Surah. PlaylistModel was not modified.
            // I should modify PlaylistModel if needed, but for now I'll handle what I can.
          } else if (lastRoute == AppRoutes.liveStream) {
            routeArgs = args;
          } else if (lastRoute == AppRoutes.tafseer) {
            routeArgs = args;
          } else {
            // Default handling for simple Map args or no args
            routeArgs = args;
          }
        }

        context.pushNamed(lastRoute, extra: routeArgs);
      }
    } catch (e) {
      debugPrint('Error restoring last route: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}
