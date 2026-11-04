import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import 'home_nav_item_widget.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: SafeArea(
        top: false,
        child: Directionality(
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
        ),
      ),
    );
  }
}
