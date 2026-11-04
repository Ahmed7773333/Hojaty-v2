import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class LanguageRadioCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageRadioCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final bgColor = isSelected
        ? (isDark ? AppColors.darkCardSelected : const Color(0xFFEBF3F0))
        : (isDark ? AppColors.darkCardUnselected : AppColors.lightSurface);

    final borderColor = isSelected
        ? (isDark ? AppColors.primaryDark : AppColors.primaryDarkBackground)
        : (isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  4.ver,
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? (isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryDarkBackground)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? (isDark
                              ? AppColors.primaryDark
                              : AppColors.primaryDarkBackground)
                        : (isDark
                              ? AppColors.darkBorderUnselected
                              : AppColors.lightBorderUnselected),
                    width: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
