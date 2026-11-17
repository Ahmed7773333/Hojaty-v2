import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/quick_access_model.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/shared/quick_access_icon_widget.dart';

class HomeQuickAccessCardWidget extends StatelessWidget {
  final QuickAccessModel item;
  final VoidCallback onTap;

  const HomeQuickAccessCardWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuickAccessIconWidget(type: item.type),
            10.ver,
            Text(
              item.titleResolver(context.strings),
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ),
            // 4.ver,
            // Text(
            //   item.subtitleResolver(context.strings),
            //   textAlign: TextAlign.center,
            //   style: context.textTheme.bodySmall?.copyWith(
            //     color: isDark
            //         ? AppColors.darkTextSecondary
            //         : AppColors.lightTextSecondary,
            //     fontSize: 11.sp,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
