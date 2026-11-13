import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'kaaba_icon_widget.dart';

class QiblaStatusBannerWidget extends StatelessWidget {
  final bool isAligned;
  final bool isClose;
  final double offsetToQibla;

  const QiblaStatusBannerWidget({
    super.key,
    required this.isAligned,
    required this.isClose,
    required this.offsetToQibla,
  });

  @override
  Widget build(BuildContext context) {
    final degrees = offsetToQibla.abs().round();
    final isRight = offsetToQibla > 0;

    final String statusText;
    final Widget leadingIcon;
    final Color backgroundColor;
    final Color borderColor;
    final Color textColor;

    if (isAligned) {
      statusText = context.strings.qiblaFacingKaaba;
      leadingIcon = const KaabaIconWidget(size: 24);
      backgroundColor = AppColors.primaryDarkSurface;
      borderColor = AppColors.accentGold;
      textColor = AppColors.accentGoldLight;
    } else {
      statusText = isRight
          ? context.strings.qiblaTurnRight(degrees)
          : context.strings.qiblaTurnLeft(degrees);
      leadingIcon = Icon(
        isRight ? Icons.rotate_right_rounded : Icons.rotate_left_rounded,
        color: isClose ? AppColors.accentGoldLight : AppColors.darkTextSecondary,
        size: 26.r,
      );
      backgroundColor = context.isDark
          ? AppColors.darkCardUnselected
          : AppColors.lightCardSelected;
      borderColor = isClose
          ? AppColors.accentGold.withValues(alpha: 0.5)
          : AppColors.primaryDarkBorder.withValues(alpha: 0.3);
      textColor = context.isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: borderColor,
          width: isAligned ? 1.5 : 1.0,
        ),
        boxShadow: isAligned
            ? [
                BoxShadow(
                  color: AppColors.accentGold.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          leadingIcon,
          12.hor,
          Expanded(
            child: Text(
              statusText,
              style: context.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
          ),
          if (!isAligned && isClose) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                context.strings.qiblaAlmostThere,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.accentGoldLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

