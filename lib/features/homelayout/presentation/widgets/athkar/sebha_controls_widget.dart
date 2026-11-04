import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class SebhaControlsWidget extends StatelessWidget {
  final VoidCallback onReset;

  const SebhaControlsWidget({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: onReset,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: BorderSide(
            color: context.isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Icon(
          Icons.refresh_rounded,
          size: 18.r,
          color: context.isDark ? AppColors.white : AppColors.primaryDark,
        ),
        label: Text(
          context.strings.reset,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.isDark ? AppColors.white : AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}

