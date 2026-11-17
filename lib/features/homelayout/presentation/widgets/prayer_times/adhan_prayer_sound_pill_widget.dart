import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class AdhanPrayerSoundPillWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AdhanPrayerSoundPillWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color:
              (isDark ? AppColors.darkSurface : AppColors.lightBorderUnselected)
                  .withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.volume_up_rounded,
              size: 13.r,
              color: isDark ? AppColors.accentGoldLight : AppColors.primaryDark,
            ),
            5.hor,
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 160.w),
              child: Text(
                title,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            4.hor,
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 9.r,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
