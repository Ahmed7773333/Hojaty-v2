import 'package:flutter/material.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class ThemePreviewBadgeWidget extends StatelessWidget {
  final AppThemeMode mode;

  const ThemePreviewBadgeWidget({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final (
      Color bgColor,
      Color borderColor,
      Color primaryDot,
      Color secondaryDot,
    ) = switch (mode) {
      AppThemeMode.light => (
        AppColors.lightBackground,
        AppColors.lightBorderUnselected,
        AppColors.primaryDark,
        AppColors.accentGold,
      ),
      AppThemeMode.dark => (
        AppColors.greenDarkBackground,
        AppColors.greenDarkBorderUnselected,
        AppColors.accentGold,
        AppColors.greenDarkSurface,
      ),
      AppThemeMode.amoled => (
        AppColors.amoledBackground,
        AppColors.amoledBorderUnselected,
        AppColors.accentGold,
        AppColors.amoledSurface,
      ),
    };

    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.r,
              height: 10.r,
              decoration: BoxDecoration(
                color: primaryDot,
                shape: BoxShape.circle,
              ),
            ),
            4.hor,
            Container(
              width: 10.r,
              height: 10.r,
              decoration: BoxDecoration(
                color: secondaryDot,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
