import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/theme/liquid_glass_style.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/local_notification_service.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/prayer_alert_sheet_header_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/pre_adhan_minutes_counter_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/pre_adhan_notification_preview_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/pre_adhan_test_button_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/pre_adhan_time_chip_widget.dart';

class PrayerAlertSettingsBottomSheetWidget extends StatelessWidget {
  static const List<int> minuteOptions = [5, 10, 15, 20, 30];

  final PrayerTimeModel prayer;

  const PrayerAlertSettingsBottomSheetWidget({super.key, required this.prayer});

  static void show(BuildContext context, {required PrayerTimeModel prayer}) {
    final bloc = context.read<HomelayoutBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: PrayerAlertSettingsBottomSheetWidget(prayer: prayer),
      ),
    );
  }

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

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        final currentPrayer = state.prayerTimes.firstWhere(
          (p) => p.type == prayer.type,
          orElse: () => prayer,
        );
        final isNotificationEnabled = currentPrayer.isNotificationEnabled;
        final isPreReminderEnabled =
            state.adhanSettings.isPreAdhanReminderEnabled;
        final selectedMinutes = state.adhanSettings
            .getPreAdhanReminderMinutesForPrayer(prayer.type);
        final prayerName = _getPrayerName(context, prayer.type);

        return LiquidGlassContainer(
          variant: LiquidGlassSurfaceVariant.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          blurSigma: LiquidGlassStyle.maxBlurSigma,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          fallbackDecoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
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
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    14.ver,
                    PrayerAlertSheetHeaderWidget(
                      prayer: currentPrayer,
                      onClose: () => Navigator.of(context).pop(),
                    ),
                    16.ver,
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardUnselected
                            : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorderUnselected
                              : AppColors.lightBorderUnselected,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.strings.alertAtPrayerTime,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.sp,
                                      ),
                                ),
                                2.ver,
                                Text(
                                  context.strings.alertAtPrayerTimeDesc,
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
                            value: isNotificationEnabled,
                            onChanged: (val) {
                              context.read<HomelayoutBloc>().add(
                                TogglePrayerNotificationEvent(prayer.type),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    14.ver,
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardUnselected
                            : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorderUnselected
                              : AppColors.lightBorderUnselected,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.strings.preAdhanReminderTitle,
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.sp,
                                          ),
                                    ),
                                    2.ver,
                                    Text(
                                      context.strings.preAdhanReminderSubtitle,
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
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
                                value: isPreReminderEnabled,
                                onChanged: (val) {
                                  context.read<HomelayoutBloc>().add(
                                    TogglePreAdhanReminderEvent(val),
                                  );
                                },
                              ),
                            ],
                          ),
                          if (isPreReminderEnabled) ...[
                            14.ver,
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
                                    context.read<HomelayoutBloc>().add(
                                      ChangePreAdhanReminderMinutesEvent(
                                        val,
                                        prayerType: prayer.type,
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            14.ver,
                            PreAdhanMinutesCounterWidget(
                              minutes: selectedMinutes,
                              onChanged: (val) {
                                context.read<HomelayoutBloc>().add(
                                  ChangePreAdhanReminderMinutesEvent(
                                    val,
                                    prayerType: prayer.type,
                                  ),
                                );
                              },
                            ),
                            14.ver,
                            PreAdhanNotificationPreviewWidget(
                              minutes: selectedMinutes,
                              prayerName: prayerName,
                            ),
                            12.ver,
                            PreAdhanTestButtonWidget(
                              onTap: () {
                                LocalNotificationService.showTestPreAdhanNotification(
                                  language: state.currentLanguage,
                                  minutes: selectedMinutes,
                                  prayerType: prayer.type,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.strings.preAdhanTestSent,
                                    ),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    16.ver,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
