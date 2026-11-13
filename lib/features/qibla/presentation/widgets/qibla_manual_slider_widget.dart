import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';

class QiblaManualSliderWidget extends StatelessWidget {
  final double heading;
  final ValueChanged<double> onHeadingChanged;

  const QiblaManualSliderWidget({
    super.key,
    required this.heading,
    required this.onHeadingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.strings.qiblaManualDialHint,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${heading.round()}°',
                style: context.textTheme.labelMedium?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          4.ver,
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.accentGold,
              inactiveTrackColor: isDark
                  ? AppColors.primaryDarkBorder
                  : AppColors.lightBorderUnselected,
              thumbColor: AppColors.accentGoldLight,
              overlayColor: AppColors.accentGold.withValues(alpha: 0.2),
              trackHeight: 3.h,
            ),
            child: Slider(
              value: heading.clamp(0.0, 360.0),
              min: 0.0,
              max: 360.0,
              onChanged: onHeadingChanged,
            ),
          ),
        ],
      ),
    );
  }
}

