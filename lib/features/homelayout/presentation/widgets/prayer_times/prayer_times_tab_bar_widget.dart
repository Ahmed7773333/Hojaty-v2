import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/prayer_tab_item_widget.dart';

class PrayerTimesTabBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const PrayerTimesTabBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
          ),
        ),
      ),
      child: Row(
        children: [
          PrayerTabItemWidget(
            title: context.strings.tabTimes,
            isSelected: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          PrayerTabItemWidget(
            title: context.strings.tabAdhanSettings,
            isSelected: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
        ],
      ),
    );
  }
}
