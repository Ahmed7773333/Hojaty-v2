import 'package:flutter/material.dart';
import '../../../../features/azkar/presentation/pages/azkar_page.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/radio/presentation/pages/radio_page.dart';
import '../../../../features/settings/presentation/pages/settings_page.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    RadioPage(),
    AzkarPage(),
    SettingsPage(),
  ];

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
