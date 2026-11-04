import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'onboarding_indicator_widget.dart';

class OnboardingTopBarWidget extends StatelessWidget {
  final int count;
  final int currentIndex;
  final VoidCallback onSkip;

  const OnboardingTopBarWidget({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OnboardingIndicatorWidget(
            count: count,
            currentIndex: currentIndex,
          ),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              context.strings.skip,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.darkTextSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
