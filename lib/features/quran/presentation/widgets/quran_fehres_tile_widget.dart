import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/surah_info_model.dart';

class QuranFehresTileWidget extends StatelessWidget {
  final SurahInfoModel surah;
  final VoidCallback onTap;

  const QuranFehresTileWidget({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              // Surah Number
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primaryDarkSurface : AppColors.lightCardSelected,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${surah.number}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              14.hor,
              // Surah Names & Ayat count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.name,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    4.ver,
                    Text(
                      '${context.strings.ayahCountText(surah.ayahCount)} • ${surah.englishName}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              10.hor,
              // Revelation type & Page number badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primaryDarkSurface : AppColors.lightCardSelected,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      surah.isMeccan ? context.strings.meccanType : context.strings.medinanType,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.accentGoldLight : AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                  4.ver,
                  Text(
                    '${context.strings.safha} ${surah.pageNumber}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
