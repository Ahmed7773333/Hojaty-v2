import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_event.dart';
import '../../bloc/homelayout_state.dart';
import 'adhan_prayer_toggle_widget.dart';
import 'adhan_test_button_widget.dart';
import 'adhan_type_card_widget.dart';

class AdhanSettingsTabView extends StatelessWidget {
  const AdhanSettingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdhanTestButtonWidget(
                onTap: () {
                  context
                      .read<HomelayoutBloc>()
                      .add(const SendTestNotificationEvent());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 'تم إرسال إشعار تجريبي'
                            : 'Test notification sent',
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              18.ver,
              Text(
                context.strings.prayerNotificationTypeSection,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              12.ver,
              AdhanTypeCardWidget(
                title: context.strings.fullAdhanTitle,
                subtitle: context.strings.fullAdhanDesc,
                isSelected: state.adhanSettings.isFullAdhan,
                onTap: () {
                  context.read<HomelayoutBloc>().add(
                    const ChangeAdhanTypeEvent(true),
                  );
                },
              ),
              10.ver,
              AdhanTypeCardWidget(
                title: context.strings.shortAlertTitle,
                subtitle: context.strings.shortAlertDesc,
                isSelected: !state.adhanSettings.isFullAdhan,
                onTap: () {
                  context.read<HomelayoutBloc>().add(
                    const ChangeAdhanTypeEvent(false),
                  );
                },
              ),
              20.ver,
              Container(
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
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Column(
                  children: List.generate(state.prayerTimes.length, (index) {
                    final prayer = state.prayerTimes[index];
                    return Column(
                      children: [
                        AdhanPrayerToggleWidget(
                          prayer: prayer,
                          onToggle: (val) {
                            context.read<HomelayoutBloc>().add(
                              TogglePrayerNotificationEvent(prayer.type),
                            );
                          },
                        ),
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
                    );
                  }),
                ),
              ),
              24.ver,
            ],
          ),
        );
      },
    );
  }
}
