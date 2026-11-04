import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class QuranSearchFieldWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const QuranSearchFieldWidget({
    super.key,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: context.strings.searchSurahHint,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.darkTextSecondary.withValues(alpha: 0.7),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.darkTextSecondary,
            size: 22.r,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
