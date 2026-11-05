import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class QuranTabHeaderWidget extends StatelessWidget {
  const QuranTabHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.quranKareem,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 26.sp,
                    ),
                  ),
                  6.ver,
                  Text(
                    context.strings.select_qirat,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryDarkSurface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.darkBorderUnselected.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: SvgPicture.asset(
                Assets.quranQuickAccessIcon,
                width: 28.w,
                height: 28.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.accentGold,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

