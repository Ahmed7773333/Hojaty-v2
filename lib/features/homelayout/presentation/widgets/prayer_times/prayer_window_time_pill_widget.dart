import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class PrayerWindowTimePillWidget extends StatelessWidget {
  final String label;
  final String timeText;
  final VoidCallback onTap;

  const PrayerWindowTimePillWidget({
    super.key,
    required this.label,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final pillBg = isDark
        ? AppColors.white.withValues(alpha: 0.1)
        : const Color(0xFFEFF2F5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontSize: 11.sp,
          ),
        ),
        6.hor,
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorderUnselected.withValues(alpha: 0.4)
                    : AppColors.lightBorderUnselected.withValues(alpha: 0.5),
                width: 0.8,
              ),
            ),
            child: Text(
              timeText,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
