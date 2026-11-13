import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'qibla_calibration_dialog.dart';

class QiblaAppBarWidget extends StatelessWidget {
  const QiblaAppBarWidget({super.key});

  void _showCalibrationTips(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (_) => const QiblaCalibrationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: 20.r,
              ),
            ),
            8.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.strings.qiblaCompassTitle,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                  2.ver,
                  Text(
                    context.strings.qiblaCompassSubtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showCalibrationTips(context),
              icon: Icon(
                Icons.info_outline_rounded,
                color: AppColors.accentGoldLight,
                size: 22.r,
              ),
              tooltip: context.strings.qiblaCalibrationTipsTitle,
            ),
          ],
        ),
      ),
    );
  }
}

