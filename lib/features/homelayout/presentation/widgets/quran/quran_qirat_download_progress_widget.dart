import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class QuranQiratDownloadProgressWidget extends StatelessWidget {
  final double progress;
  final Color? color;

  const QuranQiratDownloadProgressWidget({
    super.key,
    required this.progress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final percent = (progress * 100).clamp(0, 100).toInt();
    final indicatorColor = color ?? AppColors.accentGold;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.strings.downloading,
              style: context.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                fontSize: 10.sp,
              ),
            ),
            6.hor,
            Text(
              '$percent%',
              style: context.textTheme.labelSmall?.copyWith(
                color: indicatorColor,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        6.ver,
        SizedBox(
          width: 80.w,
          child: LinearProgressIndicator(
            value: progress > 0 ? progress : null,
            color: indicatorColor,
            backgroundColor: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightCardSelected,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}

