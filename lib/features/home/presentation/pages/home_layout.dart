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
      if (lastRoute != null &&
          lastRoute.isNotEmpty &&
          lastRoute != AppRoutes.splash &&
          lastRoute != AppRoutes.login &&
          lastRoute != AppRoutes.home) {
        context.pushNamed(lastRoute);
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
