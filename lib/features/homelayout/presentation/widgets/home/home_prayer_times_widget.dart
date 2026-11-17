import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_prayer_row_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_sunrise_row_widget.dart';

class HomePrayerTimesWidget extends StatelessWidget {
  const HomePrayerTimesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.strings.prayerTimesSectionTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              Material(
                color: AppColors.transparent,
                borderRadius: BorderRadius.circular(8.r),
                child: InkWell(
                  onTap: () => context.pushNamed(AppRoutes.prayerTimes),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.strings.details,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                        4.hor,
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12.r,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          12.ver,
          BlocBuilder<HomelayoutBloc, HomelayoutState>(
            buildWhen: (prev, curr) =>
                prev.prayerTimes != curr.prayerTimes ||
                prev.sunriseTime != curr.sunriseTime,
            builder: (context, state) {
              final now = DateTime.now();
              final sunriseTime =
                  state.sunriseTime ??
                  PrayersHelper(
                    coordinates: UserHiveHelper.getCachedCoordinates(),
                  ).getSunriseDateTime(state.selectedPrayerDate ?? now);
              final isToday = state.selectedPrayerDayOffset == 0;
              final fajrPrayer = state.prayerTimes
                  .where((p) => p.type == PrayerType.fajr)
                  .firstOrNull;
              final isSunriseNext =
                  isToday &&
                  fajrPrayer?.dateTime != null &&
                  !now.isBefore(fajrPrayer!.dateTime!) &&
                  !fajrPrayer.isCurrent &&
                  now.isBefore(sunriseTime);

              return Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardUnselected
                      : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Column(
                  children: [
                    for (
                      int index = 0;
                      index < state.prayerTimes.length;
                      index++
                    ) ...[
                      HomePrayerRowWidget(
                        prayer: state.prayerTimes[index],
                        onToggleNotification: () {
                          context.read<HomelayoutBloc>().add(
                            TogglePrayerNotificationEvent(
                              state.prayerTimes[index].type,
                            ),
                          );
                        },
                      ),
                      if (state.prayerTimes[index].type == PrayerType.fajr) ...[
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark
                              ? AppColors.darkBorderUnselected.withValues(
                                  alpha: 0.5,
                                )
                              : AppColors.lightBorderUnselected.withValues(
                                  alpha: 0.6,
                                ),
                        ),
                        HomeSunriseRowWidget(
                          sunriseTime: sunriseTime,
                          isNext: isSunriseNext,
                        ),
                      ],
                      if (index < state.prayerTimes.length - 1)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark
                              ? AppColors.darkBorderUnselected.withValues(
                                  alpha: 0.5,
                                )
                              : AppColors.lightBorderUnselected.withValues(
                                  alpha: 0.6,
                                ),
                        ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
