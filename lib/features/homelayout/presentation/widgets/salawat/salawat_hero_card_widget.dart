import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class SalawatHeroCardWidget extends StatelessWidget {
  const SalawatHeroCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardUnselected
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 16.r,
                color: AppColors.accentGold,
              ),
              8.hor,
              Text(
                context.strings.salawatHadithSource,
                style: context.textTheme.labelMedium?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
              8.hor,
              Icon(
                Icons.auto_awesome,
                size: 16.r,
                color: AppColors.accentGold,
              ),
            ],
          ),
          10.ver,
          Text(
            context.strings.salawatHadithText,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

