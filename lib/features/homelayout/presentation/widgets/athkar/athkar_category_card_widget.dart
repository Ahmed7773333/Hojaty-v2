import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/athkar_category_model.dart';
import 'athkar_category_icon_widget.dart';

class AthkarCategoryCardWidget extends StatelessWidget {
  final AthkarCategoryModel category;
  final VoidCallback onTap;

  const AthkarCategoryCardWidget({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AthkarCategoryIconWidget(type: category.type),
            12.ver,
            Text(
              category.titleResolver(context.strings),
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
            if (!category.isGuide) ...[
              4.ver,
              Text(
                context.strings.countThikr(category.count),
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
