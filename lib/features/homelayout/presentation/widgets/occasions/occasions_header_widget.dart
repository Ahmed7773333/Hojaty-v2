import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class OccasionsHeaderWidget extends StatelessWidget {
  const OccasionsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.strings.occasionsTitle,
              style: context.textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 26.sp,
              ),
            ),
            4.ver,
            Text(
              context.strings.occasionsSubtitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.darkTextSecondary,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
