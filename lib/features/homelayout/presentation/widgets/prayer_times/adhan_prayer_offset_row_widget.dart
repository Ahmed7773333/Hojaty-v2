import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/prayer_type_icon_widget.dart';

class AdhanPrayerOffsetRowWidget extends StatelessWidget {
  final PrayerType prayerType;
  final int offsetMinutes;
  final ValueChanged<int> onOffsetChanged;

  const AdhanPrayerOffsetRowWidget({
    super.key,
    required this.prayerType,
    required this.offsetMinutes,
    required this.onOffsetChanged,
  });

  String _prayerName(BuildContext context) {
    switch (prayerType) {
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
    final prefix = offsetMinutes > 0 ? '+' : '';
    final formattedOffset =
        '$prefix$offsetMinutes ${context.strings.adhanMinutesUnitShort}';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        children: [
          PrayerTypeIconWidget(type: prayerType, size: 20.r),
          10.hor,
          Expanded(
            child: Text(
              _prayerName(context),
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13.5.sp,
              ),
            ),
          ),
          IconButton(
            onPressed: offsetMinutes > -30
                ? () => onOffsetChanged(offsetMinutes - 1)
                : null,
            icon: Icon(Icons.remove_circle_outline_rounded, size: 20.r),
            color: AppColors.accentGold,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(
            width: 58.w,
            child: Text(
              formattedOffset,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                color: offsetMinutes == 0
                    ? (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)
                    : AppColors.accentGold,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          IconButton(
            onPressed: offsetMinutes < 30
                ? () => onOffsetChanged(offsetMinutes + 1)
                : null,
            icon: Icon(Icons.add_circle_outline_rounded, size: 20.r),
            color: AppColors.accentGold,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
