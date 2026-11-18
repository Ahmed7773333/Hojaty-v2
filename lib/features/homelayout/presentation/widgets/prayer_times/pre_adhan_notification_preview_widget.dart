import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class PreAdhanNotificationPreviewWidget extends StatelessWidget {
  final int minutes;
  final String prayerName;

  const PreAdhanNotificationPreviewWidget({
    super.key,
    required this.minutes,
    required this.prayerName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.04)
            : AppColors.primaryDark.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected.withValues(alpha: 0.4)
              : AppColors.lightBorderUnselected.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    size: 14.r,
                    color: AppColors.accentGold,
                  ),
                  6.hor,
                  Text(
                    context.strings.notificationPreviewLabel,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.volume_up_rounded,
                    size: 12.r,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  4.hor,
                  Text(
                    context.strings.preAdhanSoundName,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          6.ver,
          Text(
            context.strings.preAdhanNotificationTitle(prayerName),
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
          2.ver,
          Text(
            context.strings.preAdhanNotificationBody(minutes, prayerName),
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
