import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'qibla_calibration_tip_row.dart';

class QiblaCalibrationDialog extends StatelessWidget {
  const QiblaCalibrationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border(
          top: BorderSide(
            color: AppColors.accentGold.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.ver,
            // Title
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.accentGold,
                  size: 22.r,
                ),
                8.hor,
                Expanded(
                  child: Text(
                    context.strings.qiblaCalibrationTipsTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
            16.ver,
            QiblaCalibrationTipRow(
              icon: Icons.stay_current_portrait_rounded,
              text: context.strings.qiblaTipFlat,
            ),
            QiblaCalibrationTipRow(
              icon: Icons.shield_outlined,
              text: context.strings.qiblaTipMagnets,
            ),
            QiblaCalibrationTipRow(
              icon: Icons.all_inclusive_rounded,
              text: context.strings.qiblaTipFigure8,
            ),
            QiblaCalibrationTipRow(
              icon: Icons.gps_fixed_rounded,
              text: context.strings.qiblaTipGps,
            ),
            20.ver,
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDarkSurface,
                foregroundColor: AppColors.accentGoldLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: const BorderSide(color: AppColors.accentGold, width: 1),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                context.strings.close,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: AppColors.accentGoldLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

