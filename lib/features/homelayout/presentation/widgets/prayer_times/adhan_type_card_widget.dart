import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class AdhanTypeCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const AdhanTypeCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final backgroundColor = isSelected
        ? (isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected)
        : (isDark
              ? AppColors.darkCardUnselected
              : AppColors.lightCardUnselected);

    final borderColor = isSelected
        ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
        : (isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected);

    final radioBorderColor = isSelected
        ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
        : (isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected);

    final radioFillColor = isSelected
        ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
        : AppColors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                  4.ver,
                  Text(
                    subtitle,
                    textAlign: TextAlign.end,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: radioBorderColor, width: 2.0),
                color: radioFillColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
