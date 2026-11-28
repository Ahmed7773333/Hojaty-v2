import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:material_ui/material_ui.dart';

class HifzHubHeader extends StatelessWidget {
  final int streakDays;
  final VoidCallback onOpenStorage;

  const HifzHubHeader({
    super.key,
    required this.streakDays,
    required this.onOpenStorage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.strings.hifzTitle,
              style: context.textTheme.headlineMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (streakDays > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.accentGold.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.accentGold,
                    size: 16.r,
                  ),
                  4.hor,
                  Text(
                    context.strings.hifzStreakDays(streakDays),
                    style: context.textTheme.labelMedium?.copyWith(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            8.hor,
          ],
          IconButton(
            onPressed: onOpenStorage,
            tooltip: context.strings.hifzStorageTitle,
            style: IconButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.lightSurface,
              side: BorderSide(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
              ),
            ),
            icon: Icon(
              Icons.download_for_offline_outlined,
              color: isDark
                  ? AppColors.accentGold
                  : AppColors.primaryDark,
              size: 22.r,
            ),
          ),
        ],
      ),
    );
  }
}

