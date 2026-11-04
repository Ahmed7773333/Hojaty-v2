import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/screen_util_like.dart';

class OnboardingIndicatorWidget extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingIndicatorWidget({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) {
          final isCurrent = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: isCurrent ? 24.w : 5.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppColors.accentGoldLight
                  : AppColors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(3.r),
            ),
          );
        },
      ),
    );
  }
}
