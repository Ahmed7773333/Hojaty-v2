import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class AthkarEmptySearchWidget extends StatelessWidget {
  final VoidCallback onClear;

  const AthkarEmptySearchWidget({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56.sp,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
            16.ver,
            Text(
              context.strings.noAthkarFound,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
            16.ver,
            TextButton.icon(
              onPressed: onClear,
              icon: Icon(
                Icons.refresh_rounded,
                size: 18.sp,
                color: isDark ? AppColors.accentGold : AppColors.primaryDark,
              ),
              label: Text(
                context.strings.reset,
                style: context.textTheme.labelMedium?.copyWith(
                  color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

