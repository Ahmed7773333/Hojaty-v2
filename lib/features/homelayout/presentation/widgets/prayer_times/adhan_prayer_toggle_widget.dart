import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayer_time_model.dart';
import 'prayer_type_icon_widget.dart';

class AdhanPrayerToggleWidget extends StatelessWidget {
  final PrayerTimeModel prayer;
  final ValueChanged<bool> onToggle;

  const AdhanPrayerToggleWidget({
    super.key,
    required this.prayer,
    required this.onToggle,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrayerTypeIconWidget(type: prayer.type, size: 22.r),
              10.hor,
              Text(
                _getPrayerName(context, prayer.type),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          Switch(
            value: prayer.isNotificationEnabled,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
