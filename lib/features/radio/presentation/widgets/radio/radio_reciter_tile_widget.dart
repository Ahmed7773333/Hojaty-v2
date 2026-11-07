import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/quran/data/models/surah_info_model.dart';
import 'package:hojaty/features/radio/data/models/reciter_model.dart';
import 'package:hojaty/features/radio/data/models/surah_audio_args.dart';
import 'package:flutter/material.dart';

class RadioReciterTileWidget extends StatelessWidget {
  final ReciterModel reciter;
  final SurahInfoModel? targetSurah;

  const RadioReciterTileWidget({
    super.key,
    required this.reciter,
    this.targetSurah,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final moshaf = (targetSurah != null)
        ? reciter.getMoshafForSurah(targetSurah!.number)
        : reciter.moshaf?.firstOrNull;
    final moshafTitle = (moshaf?.name?.isNotEmpty ?? false)
        ? moshaf!.name
        : ((reciter.moshaf?.isNotEmpty ?? false)
            ? reciter.moshaf?.first.name
            : context.strings.listenToSurah);

    return RepaintBoundary(
      child: Material(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {
            if (targetSurah != null) {
              final serverUrl =
                  moshaf?.server ?? reciter.moshaf?.firstOrNull?.server ?? '';
              context.pushNamed(
                AppRoutes.surahAudio,
                extra: SurahAudioArgs(
                  surahNumber: targetSurah!.number,
                  surahNameAr: targetSurah!.name,
                  surahNameEn: targetSurah!.englishName,
                  reciterName: reciter.name ?? '',
                  reciterLetter: reciter.letter ?? '',
                  serverUrl: serverUrl,
                  reciterId: '${reciter.id}',
                ),
              );
            } else {
              context.pushNamed(AppRoutes.readerSurahs, extra: reciter);
            }
          },
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
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.accentGoldExtraLight,
                  child: Text(
                    (reciter.letter?.isNotEmpty ?? false)
                        ? (reciter.letter ?? '')
                        : '؟',
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
                      Text(
                        reciter.name ?? '',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.ver,
                      Text(
                        moshafTitle ?? '',
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
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
