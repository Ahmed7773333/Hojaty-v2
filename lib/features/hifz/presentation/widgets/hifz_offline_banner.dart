import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:material_ui/material_ui.dart';

class HifzOfflineBanner extends StatelessWidget {
  final int ayahNumber;
  final VoidCallback onSwitchToSilentTest;

  const HifzOfflineBanner({
    super.key,
    required this.ayahNumber,
    required this.onSwitchToSilentTest,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardSelected : AppColors.accentGoldExtraLight,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            color: AppColors.accentGoldDark,
            size: 20.r,
          ),
          10.hor,
          Expanded(
            child: Text(
              context.strings.hifzOfflineBanner(ayahNumber),
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          8.hor,
          TextButton(
            onPressed: onSwitchToSilentTest,
            style: TextButton.styleFrom(
              foregroundColor:
                  isDark ? AppColors.accentGold : AppColors.primaryDark,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
            child: Text(context.strings.hifzSwitchToSilentTest),
          ),
        ],
      ),
    );
  }
}

