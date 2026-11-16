import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/azan_audio_item_model.dart';
import '../../../data/models/prayer_time_model.dart';
import 'adhan_prayer_option_row_widget.dart';

class AdhanPrayerSelectorBottomSheet extends StatelessWidget {
  final AzanAudioItemModel adhan;
  final Map<String, String> currentPrayerSounds;
  final ValueChanged<PrayerType?> onSelect;

  const AdhanPrayerSelectorBottomSheet({
    super.key,
    required this.adhan,
    required this.currentPrayerSounds,
    required this.onSelect,
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

  IconData _getPrayerIcon(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return Icons.nights_stay_outlined;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_rounded;
      case PrayerType.asr:
        return Icons.wb_twilight_rounded;
      case PrayerType.maghrib:
        return Icons.wb_twilight;
      case PrayerType.isha:
        return Icons.dark_mode_rounded;
    }
  }

  bool _isAllPrayersSelected() {
    for (final type in PrayerType.values) {
      if (currentPrayerSounds[type.name] != adhan.id) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.ver,
            Text(
              context.strings.setAdhanForPrayerTitle,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
            ),
            4.ver,
            Text(
              adhan.title,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.accentGoldLight
                    : AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            14.ver,
            AdhanPrayerOptionRowWidget(
              title: context.strings.setForAllPrayers,
              icon: Icons.all_inclusive_rounded,
              isSelected: _isAllPrayersSelected(),
              onTap: () {
                Navigator.of(context).pop();
                onSelect(null);
              },
            ),
            10.ver,
            Divider(
              height: 1,
              thickness: 1,
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
            10.ver,
            ...PrayerType.values.map((type) {
              final isSelected = currentPrayerSounds[type.name] == adhan.id;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: AdhanPrayerOptionRowWidget(
                  title: _getPrayerName(context, type),
                  icon: _getPrayerIcon(type),
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelect(type);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

