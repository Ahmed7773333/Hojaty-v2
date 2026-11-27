import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/assets.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_nav_item_widget.dart';

class HomeBottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const HomeBottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isGlass = context.isLiquidGlassEnabled;

    final navItemsRow = Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: HomeNavItemWidget(
              index: 0,
              isSelected: currentIndex == 0,
              iconPath: Assets.homeNavBarIcon,
              label: context.strings.navHome,
              onSelected: onTabSelected,
            ),
          ),
          Flexible(
            child: HomeNavItemWidget(
              index: 1,
              isSelected: currentIndex == 1,
              iconPath: Assets.quranNavBarIcon,
              label: context.strings.navQuran,
              onSelected: onTabSelected,
            ),
          ),
          Flexible(
            child: HomeNavItemWidget(
              index: 2,
              isSelected: currentIndex == 2,
              iconPath: Assets.azkharNavBarIcon,
              label: context.strings.navAthkar,
              onSelected: onTabSelected,
            ),
          ),
          Flexible(
            child: HomeNavItemWidget(
              index: 3,
              isSelected: currentIndex == 3,
              iconPath: Assets.occasionsNavBarIcon,
              label: context.strings.navOccasions,
              onSelected: onTabSelected,
            ),
          ),
          Flexible(
            child: HomeNavItemWidget(
              index: 4,
              isSelected: currentIndex == 4,
              iconPath: Assets.moreNavBarIcon,
              label: context.strings.navMore,
              onSelected: onTabSelected,
            ),
          ),
        ],
      ),
    );

    if (isGlass) {
      return SafeArea(
        top: false,
        minimum: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
        child: LiquidGlassContainer(
          borderRadius: BorderRadius.circular(28.r),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
          child: navItemsRow,
        ),
      );
    }

    return LiquidGlassContainer(
      enabled: false,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      fallbackDecoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
          ),
        ),
      ),
      child: SafeArea(top: false, child: navItemsRow),
    );
  }
}
