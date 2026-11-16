import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/prayer_time_model.dart';
import 'adhan_prayer_sound_pill_widget.dart';
import 'prayer_type_icon_widget.dart';

class AdhanPrayerToggleWidget extends StatelessWidget {
  final PrayerTimeModel prayer;
  final ValueChanged<bool> onToggle;
  final String soundTitle;
  final VoidCallback onSelectSound;

  const AdhanPrayerToggleWidget({
    super.key,
    required this.prayer,
    required this.onToggle,
    required this.soundTitle,
    required this.onSelectSound,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                PrayerTypeIconWidget(type: prayer.type, size: 22.r),
                12.hor,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPrayerName(context, prayer.type),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                      4.ver,
                      AdhanPrayerSoundPillWidget(
                        title: soundTitle,
                        onTap: onSelectSound,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
