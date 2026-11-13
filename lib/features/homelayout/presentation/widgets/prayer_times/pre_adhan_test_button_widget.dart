import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class PreAdhanTestButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const PreAdhanTestButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.white.withValues(alpha: 0.06)
                : AppColors.primaryDark.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.primaryDark.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline_rounded,
                size: 18.r,
                color: isDark ? AppColors.white : AppColors.primaryDark,
              ),
              8.hor,
              Text(
                context.strings.preAdhanTestButton,
                style: context.textTheme.labelMedium?.copyWith(
                  color: isDark ? AppColors.white : AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
