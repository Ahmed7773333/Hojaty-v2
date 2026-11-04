import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../widgets/prayer_times/adhan_settings_tab_view.dart';
import '../widgets/prayer_times/prayer_times_header_widget.dart';
import '../widgets/prayer_times/prayer_times_tab_bar_widget.dart';
import '../widgets/prayer_times/prayer_times_tab_view.dart';

class PrayerTimesPage extends StatefulWidget {
  final int initialTabIndex;

  const PrayerTimesPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final tabViews = [
      const PrayerTimesTabView(),
      const AdhanSettingsTabView(),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          const PrayerTimesHeaderWidget(),
          PrayerTimesTabBarWidget(
            selectedIndex: _selectedTab,
            onTabSelected: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: tabViews,
            ),
          ),
        ],
      ),
    );
  }
}
