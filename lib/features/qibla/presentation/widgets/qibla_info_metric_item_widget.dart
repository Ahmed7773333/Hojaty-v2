import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';

class QiblaInfoMetricItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const QiblaInfoMetricItemWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14.r,
          color: AppColors.accentGold,
        ),
        6.hor,
        Text(
          title,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

