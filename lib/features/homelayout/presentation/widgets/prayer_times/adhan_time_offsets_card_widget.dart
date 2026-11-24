import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_prayer_offset_row_widget.dart';

class AdhanTimeOffsetsCardWidget extends StatelessWidget {
  const AdhanTimeOffsetsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.adhanSettings.prayerTimeOffsets !=
          curr.adhanSettings.prayerTimeOffsets,
      builder: (context, state) {
        final hasAnyOffset = state.adhanSettings.prayerTimeOffsets.values.any(
          (v) => v != 0,
        );

        return Container(
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.strings.adhanTimeOffsetsTitle,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          2.ver,
                          Text(
                            context.strings.adhanTimeOffsetsSubtitle,
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
                    if (hasAnyOffset)
                      TextButton(
                        onPressed: () {
                          context.read<HomelayoutBloc>().add(
                            const ResetPrayerTimeOffsetsEvent(),
                          );
                        },
                        child: Text(
                          context.strings.adhanTimeOffsetsReset,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              8.ver,
              Divider(
                height: 1,
                thickness: 1,
                color: isDark
                    ? AppColors.darkBorderUnselected.withValues(alpha: 0.5)
                    : AppColors.lightBorderUnselected.withValues(alpha: 0.6),
              ),
              for (int i = 0; i < PrayerType.values.length; i++) ...[
                AdhanPrayerOffsetRowWidget(
                  prayerType: PrayerType.values[i],
                  offsetMinutes: state.adhanSettings.getTimeOffsetForPrayer(
                    PrayerType.values[i],
                  ),
                  onOffsetChanged: (minutes) {
                    context.read<HomelayoutBloc>().add(
                      ChangePrayerTimeOffsetEvent(
                        prayerType: PrayerType.values[i],
                        offsetMinutes: minutes,
                      ),
                    );
                  },
                ),
                if (i < PrayerType.values.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? AppColors.darkBorderUnselected.withValues(alpha: 0.4)
                        : AppColors.lightBorderUnselected.withValues(
                            alpha: 0.5,
                          ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
