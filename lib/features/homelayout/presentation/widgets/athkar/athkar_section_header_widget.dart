import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class AthkarSectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? badgeText;

  const AthkarSectionHeaderWidget({
    super.key,
    required this.title,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 16.sp,
          ),
        ),
        if (badgeText != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              badgeText!,
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.accentGold,
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
              ),
            ),
          ),
      ],
    );
  }
}

