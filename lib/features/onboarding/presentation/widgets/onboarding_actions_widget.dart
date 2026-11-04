import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';

class OnboardingActionsWidget extends StatelessWidget {
  final bool isLastSlide;
  final VoidCallback onNext;
  final VoidCallback onSkipAll;

  const OnboardingActionsWidget({
    super.key,
    required this.isLastSlide,
    required this.onNext,
    required this.onSkipAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomElevatedButton(
            text: isLastSlide
                ? context.strings.getStarted
                : context.strings.next,
            backgroundColor: AppColors.accentGold,
            foregroundColor: AppColors.primaryDarkBackground,
            onPressed: onNext,
          ),
          16.ver,
          if (!isLastSlide)
            Center(
              child: TextButton(
                onPressed: onSkipAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  context.strings.skipAll,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            )
          else
            SizedBox(height: 38.h),
        ],
      ),
    );
  }
}
