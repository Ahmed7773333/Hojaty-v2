import 'package:flutter/material.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class AsmaAllahBannerCardWidget extends StatelessWidget {
  const AsmaAllahBannerCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.pushNamed(AppRoutes.asmaAllah);
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AppColors.accentGold.withValues(alpha: 0.3)
                  : AppColors.accentGold.withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                  size: 22.sp,
                ),
              ),
              14.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.strings.asmaAllahTitle,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                    4.ver,
                    Text(
                      context.strings.asmaAllahSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              8.hor,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '99',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              6.hor,
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

