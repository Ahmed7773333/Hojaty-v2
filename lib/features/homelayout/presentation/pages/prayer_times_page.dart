import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/widgets/liquid_glass_backdrop.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_settings_tab_view.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/prayer_times_header_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/prayer_times_tab_bar_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/prayer_times_tab_view.dart';

class PrayerTimesPage extends StatefulWidget {
  final int initialTabIndex;
  final String? highlightSectionKey;

  const PrayerTimesPage({
    super.key,
    this.initialTabIndex = 0,
    this.highlightSectionKey,
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
      AdhanSettingsTabView(
        initialHighlightSectionKey: widget.highlightSectionKey,
      ),
    ];

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: LiquidGlassBackdrop(
        child: Column(
          children: [
          PrayerTimesHeaderWidget(
            onOpenAdhanSettings: _selectedTab == 0
                ? () {
                    setState(() {
                      _selectedTab = 1;
                    });
                  }
                : null,
          ),
          PrayerTimesTabBarWidget(
            selectedIndex: _selectedTab,
            onTabSelected: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(index: _selectedTab, children: tabViews),
            ),
          ],
        ),
      ),
    );
  }
}
