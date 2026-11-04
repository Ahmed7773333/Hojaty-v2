import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/surah_item_model.dart';
import 'surah_number_badge_widget.dart';
import 'surah_type_badge_widget.dart';

class SurahItemRowWidget extends StatelessWidget {
  final SurahItemModel surah;
  final VoidCallback onTap;

  const SurahItemRowWidget({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            SurahNumberBadgeWidget(number: surah.number),
            14.hor,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.arabicName,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  4.ver,
                  Text(
                    '${context.strings.ayahCountText(surah.ayahCount)} — ${surah.englishName}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            12.hor,
            SurahTypeBadgeWidget(isMeccan: surah.isMeccan),
          ],
        ),
      ),
    );
  }
}
