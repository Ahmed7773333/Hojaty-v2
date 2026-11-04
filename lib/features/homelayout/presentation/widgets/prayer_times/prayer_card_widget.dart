import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayer_time_model.dart';
import '../../../data/models/prayers_helper.dart';
import 'prayer_type_icon_widget.dart';

class PrayerCardWidget extends StatelessWidget {
  final PrayerTimeModel prayer;
  final VoidCallback onToggleNotification;

  const PrayerCardWidget({
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
    final isHighlighted = prayer.isNext;

    final cardBg = isHighlighted
        ? AppColors.primaryDark
        : (isDark ? AppColors.darkCardUnselected : AppColors.lightSurface);

    final borderColor = isHighlighted
        ? AppColors.primaryDark
        : (isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected);

    final titleColor = isHighlighted
        ? AppColors.white
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    final iconBgColor = isHighlighted
        ? AppColors.accentGold
        : (isDark
              ? AppColors.white.withValues(alpha: 0.08)
              : AppColors.lightBackground);

    final bellColor = isHighlighted
        ? AppColors.primaryDark
        : (prayer.isNotificationEnabled
              ? (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary)
              : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted));

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrayerTypeIconWidget(
                type: prayer.type,
                size: 24.r,
                color: isHighlighted ? null : null,
              ),
              12.hor,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getPrayerName(context, prayer.type),
                    style: context.textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  if (isHighlighted) ...[
                    2.ver,
                    Text(
                      context.strings.nextPrayerBadge,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.accentGoldLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                prayer.dateTime != null
                    ? PrayersHelper.formatTimeTo12Hour(prayer.dateTime!,
                        language:
                            Localizations.localeOf(context).languageCode)
                    : prayer.time,
                style: context.textTheme.titleMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              14.hor,
              InkWell(
                onTap: onToggleNotification,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    prayer.isNotificationEnabled
                        ? Icons.notifications_none_rounded
                        : Icons.notifications_off_outlined,
                    size: 18.r,
                    color: bellColor,
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
