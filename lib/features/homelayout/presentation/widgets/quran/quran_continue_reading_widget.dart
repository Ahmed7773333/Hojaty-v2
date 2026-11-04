import 'package:hojaty/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class QuranContinueReadingWidget extends StatelessWidget {
  final String surahName;
  final int ayahNumber;
  final VoidCallback onTap;

  const QuranContinueReadingWidget({
    super.key,
    required this.surahName,
    required this.ayahNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.strings.continueReading,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.accentGoldLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                4.ver,
                Text(
                  surahName,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20.sp,
                  ),
                ),
                4.ver,
                Text(
                  context.strings.ayahNumber(ayahNumber),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              Assets.quranQuickAccessIcon,
              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
