import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/quran/data/models/surah_info_model.dart';
import 'package:flutter/material.dart';

class ReaderSurahTileWidget extends StatelessWidget {
  final SurahInfoModel surah;
  final VoidCallback onTap;

  const ReaderSurahTileWidget({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final primaryName = isAr ? surah.name : surah.englishName;
    final secondaryName = isAr ? surah.englishName : surah.name;
    final revelation = isAr ? surah.arabicRevelationType : surah.revelationType;

    return Material(
      color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.accentGoldExtraLight,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${surah.number}',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              14.hor,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            primaryName,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        8.hor,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.lightCardSelected,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            revelation,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.primaryDark,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.ver,
                    Text(
                      secondaryName,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              8.hor,
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.accentGoldExtraLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.accentGold,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
