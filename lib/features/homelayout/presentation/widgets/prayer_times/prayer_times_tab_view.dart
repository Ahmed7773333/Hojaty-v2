import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_event.dart';
import '../../bloc/homelayout_state.dart';
import 'prayer_card_widget.dart';
import 'prayer_day_navigator_widget.dart';

class PrayerTimesTabView extends StatelessWidget {
  const PrayerTimesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        final selectedDate = state.selectedPrayerDate ?? DateTime.now();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              PrayerDayNavigatorWidget(
                dayOffset: state.selectedPrayerDayOffset,
                date: selectedDate,
                onPrev: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const NavigatePrayerDayEvent(-1));
                },
                onNext: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const NavigatePrayerDayEvent(1));
                },
                onReturnToToday: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const ResetPrayerDayToTodayEvent());
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardUnselected
                      : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.strings.enableAllPrayersNotifications,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          4.ver,
                          Text(
                            context.strings.allPrayersNotificationsDesc,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: state.adhanSettings.isAllPrayersEnabled,
                      onChanged: (val) {
                        context.read<HomelayoutBloc>().add(
                          ToggleAllPrayersNotificationEvent(val),
                        );
                      },
                    ),
                  ],
                ),
              ),
              16.ver,
              ...state.prayerTimes.map(
                (prayer) => PrayerCardWidget(
                  prayer: prayer,
                  onToggleNotification: () {
                    context.read<HomelayoutBloc>().add(
                      TogglePrayerNotificationEvent(prayer.type),
                    );
                  },
                ),
              ),
              20.ver,
            ],
          ),
        );
      },
    );
  }
}
