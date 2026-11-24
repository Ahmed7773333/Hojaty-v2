import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class HomeWidgetGuideSheet extends StatelessWidget {
  const HomeWidgetGuideSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isIos = !kIsWeb && Platform.isIOS;
    final steps = isIos
        ? [
            context.strings.homeWidgetGuideStep1Ios,
            context.strings.homeWidgetGuideStep2Ios,
            context.strings.homeWidgetGuideStep3Ios,
          ]
        : [
            context.strings.homeWidgetGuideStep1Android,
            context.strings.homeWidgetGuideStep2Android,
            context.strings.homeWidgetGuideStep3Android,
          ];

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          16.ver,
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.widgets_outlined,
                  color: AppColors.accentGold,
                  size: 22.r,
                ),
              ),
              12.hor,
              Expanded(
                child: Text(
                  context.strings.homeWidgetGuideTitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          16.ver,
          ...steps.map(
            (step) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                step,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
            ),
          ),
          12.ver,
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              context.strings.homeWidgetShowcaseDismiss,
              style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

