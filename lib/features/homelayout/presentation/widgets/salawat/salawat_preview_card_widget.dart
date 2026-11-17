import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class SalawatPreviewCardWidget extends StatelessWidget {
  const SalawatPreviewCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCardUnselected
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.preview_rounded,
                size: 18.r,
                color: AppColors.accentGold,
              ),
              8.hor,
              Text(
                context.strings.salawatNotificationPreviewTitle,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          4.ver,
          Text(
            context.strings.salawatNotificationPreviewSubtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
              fontSize: 11.sp,
            ),
          ),
          12.ver,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorderUnselected.withValues(alpha: 0.6)
                    : AppColors.lightBorderUnselected,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/logo.png',
                      width: 18.r,
                      height: 18.r,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.notifications_active_rounded,
                        size: 18.r,
                        color: AppColors.accentGold,
                      ),
                    ),
                    8.hor,
                    Text(
                      'حچتي',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '• الآن',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 10.sp,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                8.ver,
                Text(
                  context.strings.salawatNotificationContentTitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                4.ver,
                Text(
                  context.strings.salawatNotificationContentBody,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 12.sp,
                    height: 1.35,
                  ),
                ),
                12.ver,
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.white.withValues(alpha: 0.06)
                            : AppColors.primaryDark.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        context.strings.salawatNotificationOpen,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.accentGold
                              : AppColors.primaryDark,
                        ),
                      ),
                    ),
                    8.hor,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.white.withValues(alpha: 0.04)
                            : AppColors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        context.strings.salawatNotificationDismiss,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 11.sp,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

