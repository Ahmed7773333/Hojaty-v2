import 'package:flutter/foundation.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:material_ui/material_ui.dart';

class RepeatCountdownPill extends StatelessWidget {
  final ValueListenable<Duration> remainingListenable;
  final ValueListenable<Duration> totalListenable;
  final VoidCallback onSkip;

  const RepeatCountdownPill({
    super.key,
    required this.remainingListenable,
    required this.totalListenable,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return ValueListenableBuilder<Duration>(
      valueListenable: remainingListenable,
      builder: (context, remaining, _) {
        final seconds = (remaining.inMilliseconds / 1000).ceil().clamp(0, 30);
        final totalMs = totalListenable.value.inMilliseconds;
        final progress = totalMs > 0
            ? (remaining.inMilliseconds / totalMs).clamp(0.0, 1.0)
            : 0.0;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardSelected
                : AppColors.accentGoldExtraLight,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.accentGold),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 22.r,
                height: 22.r,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2.5,
                  color: AppColors.accentGold,
                ),
              ),
              10.hor,
              Expanded(
                child: Text(
                  context.strings.hifzYourTurnToRepeat(seconds),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentGoldDark,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(context.strings.hifzSkipPause),
              ),
            ],
          ),
        );
      },
    );
  }
}

