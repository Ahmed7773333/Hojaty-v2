import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayer_time_model.dart';
import '../../../data/models/prayers_helper.dart';
import 'prayer_type_icon_widget.dart';

class PrayerAlertSheetHeaderWidget extends StatelessWidget {
  final PrayerTimeModel prayer;
  final VoidCallback onClose;

  const PrayerAlertSheetHeaderWidget({
    super.key,
    required this.prayer,
    required this.onClose,
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
    final formattedTime = prayer.dateTime != null
        ? PrayersHelper.formatTimeTo12Hour(
            prayer.dateTime!,
            language: Localizations.localeOf(context).languageCode,
          )
        : prayer.time;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            PrayerTypeIconWidget(type: prayer.type, size: 28.r),
            12.hor,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getPrayerName(context, prayer.type),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17.sp,
                  ),
                ),
                2.ver,
                Text(
                  formattedTime,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: onClose,
          icon: Icon(
            Icons.close_rounded,
            size: 20.r,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
