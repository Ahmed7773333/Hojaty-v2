import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class AthkarSegmentedProgressWidget extends StatelessWidget {
  final int totalSegments;
  final int currentSegmentIndex;

  const AthkarSegmentedProgressWidget({
    super.key,
    required this.totalSegments,
    required this.currentSegmentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: List.generate(
          totalSegments,
          (index) {
            final isFilled = index <= currentSegmentIndex;
            return Expanded(
              child: Container(
                height: 4.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: isFilled
                      ? AppColors.accentGold
                      : (isDark
                          ? AppColors.white.withValues(alpha: 0.15)
                          : const Color(0xFFE8ECEB)),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
