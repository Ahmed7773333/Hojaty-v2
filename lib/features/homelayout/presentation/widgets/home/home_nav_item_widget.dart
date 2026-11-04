import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class HomeNavItemWidget extends StatelessWidget {
  final int index;
  final bool isSelected;
  final String iconPath;
  final String label;
  final ValueChanged<int> onSelected;

  const HomeNavItemWidget({
    super.key,
    required this.index,
    required this.isSelected,
    required this.iconPath,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final activeBgColor = isDark ? AppColors.accentGold : AppColors.primaryDark;
    final activeIconColor = isDark
        ? AppColors.primaryDarkHeader
        : AppColors.white;
    final activeTextColor = isDark
        ? AppColors.accentGold
        : AppColors.primaryDark;
    final inactiveColor = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;

    return InkWell(
      onTap: () => onSelected(index),
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? activeBgColor : AppColors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isSelected ? activeIconColor : inactiveColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            6.ver,
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                color: isSelected ? activeTextColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
