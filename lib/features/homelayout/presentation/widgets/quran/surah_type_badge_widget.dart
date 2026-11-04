import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class SurahTypeBadgeWidget extends StatelessWidget {
  final bool isMeccan;

  const SurahTypeBadgeWidget({
    super.key,
    required this.isMeccan,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final bgColor = isMeccan
        ? (isDark
            ? AppColors.accentGold.withValues(alpha: 0.18)
            : const Color(0xFFFBF4E8))
        : (isDark
            ? AppColors.primaryDark.withValues(alpha: 0.25)
            : const Color(0xFFE8F3F0));

    final textColor = isMeccan
        ? (isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark)
        : (isDark ? const Color(0xFF6EE7B7) : AppColors.primaryDark);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        isMeccan ? context.strings.meccanType : context.strings.medinanType,
        style: context.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
