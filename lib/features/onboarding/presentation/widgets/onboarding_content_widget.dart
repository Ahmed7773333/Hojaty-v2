import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';

class OnboardingContentWidget extends StatelessWidget {
  final String subtitle;
  final String title;
  final String description;

  const OnboardingContentWidget({
    super.key,
    required this.subtitle,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.accentGoldLight,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        10.ver,
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
            fontSize: 28.sp,
          ),
        ),
        14.ver,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.darkTextSecondary,
              fontSize: 14.sp,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
