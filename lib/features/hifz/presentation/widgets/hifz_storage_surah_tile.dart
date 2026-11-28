import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/data/models/reciter_registry.dart';
import 'package:hojaty/features/hifz/domain/entities/surah_cache_summary.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:material_ui/material_ui.dart';

class HifzStorageSurahTile extends StatelessWidget {
  final SurahCacheSummary summary;
  final VoidCallback onDelete;

  const HifzStorageSurahTile({
    super.key,
    required this.summary,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final surahInfo = QuranConstants.surahMap[summary.surahId];
    final reciter = ReciterRegistry.byId(summary.reciterId);
    final mb = (summary.totalBytes / (1024 * 1024)).toStringAsFixed(1);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      child: Row(
        children: [
          Icon(
            summary.isFullyPinned
                ? Icons.offline_pin_rounded
                : Icons.audiotrack_rounded,
            color: summary.isFullyPinned
                ? AppColors.accentGold
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
          12.hor,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? (surahInfo?.name ?? '')
                      : (surahInfo?.englishName ?? ''),
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                2.ver,
                Text(
                  '${reciter.localizedName(isArabic)} • ${summary.ayahCount} • $mb MB',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline_rounded,
              color: context.colors.error,
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }
}

