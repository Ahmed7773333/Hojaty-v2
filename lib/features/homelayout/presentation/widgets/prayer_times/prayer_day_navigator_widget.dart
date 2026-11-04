import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayers_helper.dart';

class PrayerDayNavigatorWidget extends StatelessWidget {
  final int dayOffset;
  final DateTime date;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onReturnToToday;

  const PrayerDayNavigatorWidget({
    super.key,
    required this.dayOffset,
    required this.date,
    required this.onPrev,
    required this.onNext,
    required this.onReturnToToday,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final lang = Localizations.localeOf(context).languageCode;
    final isToday = dayOffset == 0;

    final formattedDate =
        PrayersHelper.formatDayOffset(dayOffset, date, language: lang);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Day Button
          IconButton(
            onPressed: dayOffset > -15 ? onPrev : null,
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.white.withValues(alpha: 0.08)
                  : const Color(0xFFEFF6F4),
              shape: const CircleBorder(),
              padding: EdgeInsets.all(8.r),
            ),
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 22.r,
              color: dayOffset > -15
                  ? (isDark ? AppColors.white : AppColors.primaryDark)
                  : (isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted),
            ),
          ),

          // Date Display with Today Button
          Expanded(
            child: GestureDetector(
              onTap: isToday ? null : onReturnToToday,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedDate,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!isToday) ...[
                    4.ver,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryDark.withValues(alpha: 0.5)
                            : AppColors.primaryDarkBackground
                                .withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.accentGold.withValues(alpha: 0.5),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.today_rounded,
                            size: 11.r,
                            color: AppColors.accentGold,
                          ),
                          4.hor,
                          Text(
                            context.strings.today,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Next Day Button
          IconButton(
            onPressed: dayOffset < 15 ? onNext : null,
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.white.withValues(alpha: 0.08)
                  : const Color(0xFFEFF6F4),
              shape: const CircleBorder(),
              padding: EdgeInsets.all(8.r),
            ),
            icon: Icon(
              Icons.chevron_right_rounded,
              size: 22.r,
              color: dayOffset < 15
                  ? (isDark ? AppColors.white : AppColors.primaryDark)
                  : (isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted),
            ),
          ),
        ],
      ),
    );
  }
}
