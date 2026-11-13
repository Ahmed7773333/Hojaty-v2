import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';

class QiblaTiltWarningWidget extends StatelessWidget {
  final bool isLevel;
  final double pitch;
  final double roll;

  const QiblaTiltWarningWidget({
    super.key,
    required this.isLevel,
    required this.pitch,
    required this.roll,
  });

  @override
  Widget build(BuildContext context) {
    if (isLevel) {
      return const SizedBox.shrink();
    }

    final bubbleX = (roll / 30.0).clamp(-1.0, 1.0);
    final bubbleY = (pitch / 30.0).clamp(-1.0, 1.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.accentGold.withValues(alpha: 0.4),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Miniature spirit level visual
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accentGoldLight,
                width: 1.5,
              ),
              color: AppColors.primaryDarkSurface,
            ),
            child: Align(
              alignment: Alignment(bubbleX, bubbleY),
              child: Container(
                width: 10.r,
                height: 10.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentGold,
                ),
              ),
            ),
          ),
          10.hor,
          Expanded(
            child: Text(
              context.strings.qiblaTiltWarning,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.accentGoldLight,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

