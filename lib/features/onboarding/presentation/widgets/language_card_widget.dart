import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';

class LanguageCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCardWidget({
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.onSurface,
                    ),
                  ),
                  4.ver,
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.r,
              height: 24.r,
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
