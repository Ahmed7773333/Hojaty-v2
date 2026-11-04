import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class AthkarDetailHeaderWidget extends StatelessWidget {
  final String title;
  final int currentIndex;
  final int totalCount;

  const AthkarDetailHeaderWidget({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          spacing: 12.w,
          children: [
            IconButton(
              onPressed: () => context.pop(),

              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: 25.r,
              ),
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 22.sp,
                  ),
                ),
                4.ver,
                Text(
                  '$currentIndex / $totalCount',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.darkTextSecondary,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
