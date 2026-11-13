import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'qibla_info_metric_item_widget.dart';

class QiblaLocationInfoCardWidget extends StatelessWidget {
  final String cityName;
  final double distanceKm;
  final double qiblaBearing;
  final double heading;
  final int accuracy;
  final bool hasSensor;

  const QiblaLocationInfoCardWidget({
    super.key,
    required this.cityName,
    required this.distanceKm,
    required this.qiblaBearing,
    required this.heading,
    required this.accuracy,
    required this.hasSensor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAccurate = accuracy >= 2;
    final formattedDistance = distanceKm.round().toString();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // City Name & Accuracy Badge
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.accentGold,
                size: 18.r,
              ),
              6.hor,
              Expanded(
                child: Text(
                  cityName,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasSensor) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: (isAccurate ? AppColors.primaryDarkSurface : AppColors.accentGold)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAccurate ? Icons.check_circle_rounded : Icons.sync_problem_rounded,
                        size: 12.r,
                        color: isAccurate ? AppColors.accentGoldLight : AppColors.accentGoldDark,
                      ),
                      4.hor,
                      Text(
                        isAccurate
                            ? context.strings.qiblaAccuracyGood
                            : context.strings.qiblaAccuracyLow,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 10.sp,
                          color: isAccurate
                              ? AppColors.accentGoldLight
                              : AppColors.accentGoldDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          12.ver,
          const Divider(height: 1, thickness: 0.5),
          12.ver,
          // Stats Row: Distance to Kaaba | Qibla Angle | Current Heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              QiblaInfoMetricItemWidget(
                title: context.strings.qiblaDistanceToKaaba(formattedDistance),
                icon: Icons.route_rounded,
              ),
              Container(
                width: 1,
                height: 28.h,
                color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
              ),
              QiblaInfoMetricItemWidget(
                title: context.strings.qiblaBearingLabel(qiblaBearing.round()),
                icon: Icons.explore_rounded,
              ),
              Container(
                width: 1,
                height: 28.h,
                color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
              ),
              QiblaInfoMetricItemWidget(
                title: context.strings.qiblaCurrentHeading(heading.round()),
                icon: Icons.compass_calibration_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
