import 'package:flutter/material.dart';
import '../../../../../config/theme/app_theme_mode.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import 'theme_preview_badge_widget.dart';

class ThemeRadioCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeRadioCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final bgColor = isSelected
        ? (isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected)
        : (isDark ? AppColors.darkCardUnselected : AppColors.lightSurface);

    final borderColor = isSelected
        ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
        : (isDark
            ? AppColors.darkBorderUnselected
            : AppColors.lightBorderUnselected);

    final activeIndicatorColor =
        isDark ? AppColors.accentGold : AppColors.primaryDark;

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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          child: Row(
            children: [
              ThemePreviewBadgeWidget(mode: mode),
              14.hor,
              Expanded(
                child: Column(
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
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              12.hor,
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? activeIndicatorColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? activeIndicatorColor
                        : (isDark
                            ? AppColors.darkBorderUnselected
                            : AppColors.lightBorderUnselected),
                    width: 2.0,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 14.r,
                        color: isDark ? AppColors.black : AppColors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

