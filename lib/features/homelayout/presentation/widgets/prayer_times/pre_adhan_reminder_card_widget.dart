import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_event.dart';
import '../../bloc/homelayout_state.dart';
import 'pre_adhan_notification_preview_widget.dart';
import 'pre_adhan_test_button_widget.dart';
import 'pre_adhan_time_chip_widget.dart';

class PreAdhanReminderCardWidget extends StatelessWidget {
  static const List<int> minuteOptions = [5, 10, 15, 20, 30];

  const PreAdhanReminderCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.adhanSettings.isPreAdhanReminderEnabled !=
              curr.adhanSettings.isPreAdhanReminderEnabled ||
          prev.adhanSettings.preAdhanReminderMinutes !=
              curr.adhanSettings.preAdhanReminderMinutes,
      builder: (context, state) {
        final isEnabled = state.adhanSettings.isPreAdhanReminderEnabled;
        final selectedMinutes = state.adhanSettings.preAdhanReminderMinutes;

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
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.white.withValues(alpha: 0.08)
                                : AppColors.primaryDark.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.timer_outlined,
                            size: 20.r,
                            color: isDark
                                ? AppColors.accentGold
                                : AppColors.primaryDark,
                          ),
                        ),
                        12.hor,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.strings.preAdhanReminderTitle,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                              2.ver,
                              Text(
                                context.strings.preAdhanReminderSubtitle,
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
                      ],
                    ),
                  ),
                  Switch(
                    value: isEnabled,
                    onChanged: (val) {
                      context
                          .read<HomelayoutBloc>()
                          .add(TogglePreAdhanReminderEvent(val));
                    },
                  ),
                ],
              ),
              if (isEnabled) ...[
                14.ver,
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark
                      ? AppColors.darkBorderUnselected.withValues(alpha: 0.5)
                      : AppColors.lightBorderUnselected.withValues(alpha: 0.6),
                ),
                14.ver,
                Text(
                  context.strings.preAdhanTimingTitle,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                10.ver,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: minuteOptions.map((mins) {
                    return PreAdhanTimeChipWidget(
                      minutes: mins,
                      isSelected: selectedMinutes == mins,
                      onSelected: (val) {
                        context
                            .read<HomelayoutBloc>()
                            .add(ChangePreAdhanReminderMinutesEvent(val));
                      },
                    );
                  }).toList(),
                ),
                14.ver,
                PreAdhanNotificationPreviewWidget(
                  minutes: selectedMinutes,
                  prayerName: context.strings.dhuhr,
                ),
                12.ver,
                PreAdhanTestButtonWidget(
                  onTap: () {
                    context
                        .read<HomelayoutBloc>()
                        .add(const SendTestPreAdhanNotificationEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.strings.preAdhanTestSent),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
