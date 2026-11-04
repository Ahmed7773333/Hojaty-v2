import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/onboarding_item_model.dart';
import 'onboarding_icon_widget.dart';

class OnboardingBadgeWidget extends StatelessWidget {
  final OnboardingIconType iconType;

  const OnboardingBadgeWidget({
    super.key,
    required this.iconType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170.r,
        height: 170.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: 0.08),
        ),
        child: Center(
          child: Container(
            width: 76.r,
            height: 76.r,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: OnboardingIconWidget(type: iconType),
            ),
          ),
        ),
      ),
    );
  }
}
