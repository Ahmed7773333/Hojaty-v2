import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/app_fonts.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_ayah_content.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/quran/constants/quran_text_helper.dart';
import 'package:material_ui/material_ui.dart';

class FocusAyahCard extends StatelessWidget {
  final HifzAyahContent ayah;
  final bool isActive;
  final bool isTestingMode;
  final bool isRevealed;
  final bool isHinted;
  final bool isMastered;
  final bool needsReview;
  final AudioCacheStatus cacheStatus;
  final VoidCallback onTap;
  final VoidCallback onLongPressHint;
  final VoidCallback onAudioHint;
  final VoidCallback onMarkMastered;
  final VoidCallback onMarkNeedsReview;

  const FocusAyahCard({
    super.key,
    required this.ayah,
    required this.isActive,
    required this.isTestingMode,
    required this.isRevealed,
    required this.isHinted,
    required this.isMastered,
    required this.needsReview,
    required this.cacheStatus,
    required this.onTap,
    required this.onLongPressHint,
    required this.onAudioHint,
    required this.onMarkMastered,
    required this.onMarkNeedsReview,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final showMask = isTestingMode && !isRevealed;
    final opacity = (isActive || isTestingMode) ? 1.0 : 0.36;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: opacity,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: showMask ? onLongPressHint : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                    ? AppColors.darkCardSelected
                    : AppColors.lightCardSelected)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isActive
                  ? AppColors.accentGold
                  : (isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected),
              width: isActive ? 1.6 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '${ayah.surahNameAr} • ${ayah.ayahNumber}',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (cacheStatus == AudioCacheStatus.cached)
                    Icon(
                      Icons.offline_pin_rounded,
                      size: 16.r,
                      color: AppColors.accentGold,
                    ),
                ],
              ),
              14.ver,
              if (showMask) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBackground.withValues(alpha: 0.6)
                        : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorderUnselected
                          : AppColors.lightBorderUnselected,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (isHinted)
                        Text(
                          ayah.firstWords(),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontFamily: AppFonts.hafsSmart,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            height: 1.8,
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.visibility_off_outlined,
                              color: AppColors.accentGold,
                              size: 20.r,
                            ),
                            8.hor,
                            Text(
                              context.strings.hifzTapToReveal,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      12.ver,
                      Wrap(
                        spacing: 8.w,
                        children: [
                          ActionChip(
                            onPressed: onLongPressHint,
                            avatar: Icon(Icons.text_fields_rounded, size: 16.r),
                            label: Text(context.strings.hifzFirstWordsHint),
                          ),
                          ActionChip(
                            onPressed: onAudioHint,
                            avatar: Icon(Icons.volume_up_rounded, size: 16.r),
                            label: Text(context.strings.hifzAudioHint),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  '${ayah.uthmaniText} ${QuranTextHelper.getVerseEndSymbol(ayah.ayahNumber)}',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppFonts.hafsSmart,
                    fontSize: isActive ? 25.sp : 21.sp,
                    height: 1.9,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                if (isTestingMode && isRevealed) ...[
                  14.ver,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onMarkNeedsReview,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: needsReview
                                ? context.colors.error
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                            side: BorderSide(
                              color: needsReview
                                  ? context.colors.error
                                  : (isDark
                                      ? AppColors.darkBorderUnselected
                                      : AppColors.lightBorderUnselected),
                            ),
                          ),
                          child: Text(context.strings.hifzNeedsReviewAction),
                        ),
                      ),
                      10.hor,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onMarkMastered,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isMastered
                                ? AppColors.accentGold
                                : (isDark
                                    ? AppColors.primaryDarkSurface
                                    : AppColors.primaryDark),
                            foregroundColor: isMastered
                                ? AppColors.primaryDarkHeader
                                : AppColors.white,
                          ),
                          child: Text(context.strings.hifzMasteredAction),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

