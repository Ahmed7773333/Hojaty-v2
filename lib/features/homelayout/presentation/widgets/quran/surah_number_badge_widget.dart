import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class SurahNumberBadgeWidget extends StatelessWidget {
  final int number;

  const SurahNumberBadgeWidget({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.08)
            : const Color(0xFFEFF2F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          '$number',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}
