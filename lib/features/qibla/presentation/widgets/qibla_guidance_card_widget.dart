import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';

class QiblaGuidanceCardWidget extends StatelessWidget {
  final int accuracy;
  final bool hasSensor;

  const QiblaGuidanceCardWidget({
    super.key,
    required this.accuracy,
    required this.hasSensor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final String hintText;
    final IconData icon;

    if (!hasSensor) {
      hintText = context.strings.qiblaSensorUnavailable;
      icon = Icons.info_outline_rounded;
    } else if (accuracy < 2) {
      hintText = context.strings.qiblaCalibrateHint;
      icon = Icons.screen_rotation_rounded;
    } else {
      hintText = context.strings.qiblaInterferenceHint;
      icon = Icons.shield_outlined;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryDarkSurface.withValues(alpha: 0.4)
            : AppColors.lightCardSelected,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? AppColors.primaryDarkBorder.withValues(alpha: 0.5)
              : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.r,
            color: AppColors.accentGold,
          ),
          10.hor,
          Expanded(
            child: Text(
              hintText,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

