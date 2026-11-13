import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class PrayerPreAlertBadgeWidget extends StatelessWidget {
  final int minutes;
  final bool isHighlighted;

  const PrayerPreAlertBadgeWidget({
    super.key,
    required this.minutes,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final badgeBg = isHighlighted
        ? AppColors.white.withValues(alpha: 0.15)
        : (isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : AppColors.primaryDark.withValues(alpha: 0.07));

    final textColor = isHighlighted
        ? AppColors.white.withValues(alpha: 0.9)
        : (isDark ? AppColors.darkTextSecondary : AppColors.primaryDark);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 11.r,
            color: textColor,
          ),
          4.hor,
          Text(
            context.strings.preAdhanBadgeText(minutes),
            style: context.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
