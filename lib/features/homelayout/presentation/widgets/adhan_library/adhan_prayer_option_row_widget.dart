import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class AdhanPrayerOptionRowWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AdhanPrayerOptionRowWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryDarkBackground.withValues(
                  alpha: isDark ? 0.35 : 0.12,
                )
              : (isDark
                    ? AppColors.darkCardUnselected
                    : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryDarkBackground
                : (isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20.r,
                  color: isSelected
                      ? (isDark
                            ? AppColors.accentGoldLight
                            : AppColors.primaryDark)
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                ),
                12.hor,
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Container(
                width: 22.r,
                height: 22.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryDarkBackground,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.white,
                  size: 14.r,
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.r,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
