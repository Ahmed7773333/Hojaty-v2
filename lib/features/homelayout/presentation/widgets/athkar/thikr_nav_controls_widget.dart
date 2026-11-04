import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class ThikrNavControlsWidget extends StatelessWidget {
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onReset;

  const ThikrNavControlsWidget({
    super.key,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onNext,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: hasPrevious ? onPrevious : null,
            icon: Icon(
              Icons.skip_previous_rounded,
              color: hasPrevious
                  ? (isDark ? AppColors.white : AppColors.primaryDark)
                  : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              size: 28.r,
            ),
          ),
          IconButton(
            onPressed: onReset,
            icon: Icon(
              Icons.replay_rounded,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              size: 24.r,
            ),
          ),
          IconButton(
            onPressed: hasNext ? onNext : null,
            icon: Icon(
              Icons.skip_next_rounded,
              color: hasNext
                  ? (isDark ? AppColors.white : AppColors.primaryDark)
                  : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              size: 28.r,
            ),
          ),
        ],
      ),
    );
  }
}
