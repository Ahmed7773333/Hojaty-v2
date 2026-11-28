import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_step.dart';
import 'package:material_ui/material_ui.dart';

class HifzLivePhaseBar extends StatelessWidget {
  final HifzStep? step;
  final double stepProgress;

  const HifzLivePhaseBar({
    super.key,
    required this.step,
    required this.stepProgress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final activeStep = step;
    final phaseLabel = switch (activeStep?.stepType) {
      StepType.basmalah => context.strings.hifzPhaseBasmalah,
      StepType.chainLink => context.strings.hifzPhaseChaining,
      StepType.fullRangeReview => context.strings.hifzPhaseReview,
      _ => context.strings.hifzPhaseSingle,
    };
    final totalStr = activeStep == null
        ? '1'
        : (activeStep.isInfinity ? '∞' : '${activeStep.totalRepeats}');
    final repeatText = context.strings.hifzRepeatCounter(
      activeStep?.repeatIndex ?? 1,
      totalStr,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  phaseLabel,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                repeatText,
                style: context.textTheme.labelMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          6.ver,
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: stepProgress,
              minHeight: 4.h,
              backgroundColor: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.accentGold : AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

