import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:flutter/material.dart';

class SurahAudioInfoWidget extends StatelessWidget {
  final String surahNameAr;
  final String surahNameEn;
  final String reciterName;
  final int surahNumber;

  const SurahAudioInfoWidget({
    super.key,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.reciterName,
    required this.surahNumber,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180.r,
          height: 180.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDarkSurface,
                AppColors.primaryDarkBackground,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGold.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
            border: Border.all(
              color: AppColors.accentGold.withValues(alpha: 0.6),
              width: 3.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: AppColors.accentGold,
                size: 40.0,
              ),
              8.ver,
              Text(
                '$surahNumber',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        24.ver,
        Text(
          surahNameAr,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        4.ver,
        Text(
          surahNameEn,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        10.ver,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightCardSelected,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.accentGold.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            reciterName,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.accentGold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
