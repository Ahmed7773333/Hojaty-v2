import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayer_time_model.dart';
import '../../../data/models/prayers_helper.dart';
import '../prayer_times/prayer_type_icon_widget.dart';

class HomePrayerRowWidget extends StatelessWidget {
  final PrayerTimeModel prayer;
  final VoidCallback onToggleNotification;

  const HomePrayerRowWidget({
    super.key,
    required this.prayer,
    required this.onToggleNotification,
  });

  String _getPrayerName(BuildContext context, PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return context.strings.fajr;
      case PrayerType.dhuhr:
        return context.strings.dhuhr;
      case PrayerType.asr:
        return context.strings.asr;
      case PrayerType.maghrib:
        return context.strings.maghrib;
      case PrayerType.isha:
        return context.strings.isha;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final rowBg = prayer.isNext
        ? (isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected)
        : AppColors.transparent;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrayerTypeIconWidget(type: prayer.type),
              8.hor,
              Text(
                _getPrayerName(context, prayer.type),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
              8.hor,
              if (prayer.isCurrent) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    context.strings.currentPrayerBadge,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                prayer.dateTime != null
                    ? PrayersHelper.formatTimeTo12Hour(
                        prayer.dateTime!,
                        language: Localizations.localeOf(context).languageCode,
                      )
                    : prayer.time,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
              8.hor,
              GestureDetector(
                onTap: onToggleNotification,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    prayer.isNotificationEnabled
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined,
                    size: 20.r,
                    color: prayer.isNotificationEnabled
                        ? (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary)
                        : (isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
