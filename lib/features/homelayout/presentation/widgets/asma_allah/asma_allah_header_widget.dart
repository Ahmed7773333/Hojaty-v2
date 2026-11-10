import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class AsmaAllahHeaderWidget extends StatelessWidget {
  final int totalCount;

  const AsmaAllahHeaderWidget({
    super.key,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.white,
                size: 22.r,
              ),
            ),
            8.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.asmaAllahTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20.sp,
                    ),
                  ),
                  2.ver,
                  Text(
                    context.strings.asmaAllahSubtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$totalCount',
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

