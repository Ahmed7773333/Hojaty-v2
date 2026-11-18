import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/azan_audio_item_model.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/adhan_library/adhan_card_action_buttons_widget.dart';

class AdhanLibraryItemCardWidget extends StatelessWidget {
  final AzanAudioItemModel item;
  final bool isPlaying;
  final bool isLoadingAudio;
  final bool isDownloading;
  final double downloadProgress;
  final List<String> assignedPrayerNames;
  final VoidCallback onTogglePlay;
  final VoidCallback onDownload;
  final VoidCallback onDelete;
  final VoidCallback onSet;

  const AdhanLibraryItemCardWidget({
    super.key,
    required this.item,
    required this.isPlaying,
    required this.isLoadingAudio,
    required this.isDownloading,
    required this.downloadProgress,
    required this.assignedPrayerNames,
    required this.onTogglePlay,
    required this.onDownload,
    required this.onDelete,
    required this.onSet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isPlaying
              ? AppColors.primaryDarkBackground
              : (isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected),
          width: isPlaying ? 1.5 : 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Play/Pause button
              GestureDetector(
                onTap: onTogglePlay,
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPlaying
                        ? AppColors.primaryDarkBackground
                        : (isDark
                              ? AppColors.darkSurface
                              : AppColors.lightBorderUnselected.withValues(
                                  alpha: 0.4,
                                )),
                  ),
                  child: Center(
                    child: isLoadingAudio
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isPlaying
                                    ? AppColors.white
                                    : (isDark
                                          ? AppColors.accentGoldLight
                                          : AppColors.primaryDark),
                              ),
                            ),
                          )
                        : Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 26.r,
                            color: isPlaying
                                ? AppColors.white
                                : (isDark
                                      ? AppColors.white
                                      : AppColors.primaryDark),
                          ),
                  ),
                ),
              ),
              12.hor,
              // Title & Badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    6.ver,
                    Row(
                      children: [
                        Text(
                          item.formattedDuration,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: 11.sp,
                          ),
                        ),
                        6.hor,
                        Text(
                          '•',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: 10.sp,
                          ),
                        ),
                        6.hor,
                        Text(
                          item.formattedSize,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: 11.sp,
                          ),
                        ),
                        if (item.isBuiltIn) ...[
                          8.hor,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentGoldDark.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              context.strings.adhanFilterBuiltIn,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? AppColors.accentGoldLight
                                    : AppColors.accentGoldDark,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ] else if (item.isDownloaded) ...[
                          8.hor,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDarkBackground.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              context.strings.adhanFilterDownloaded,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? AppColors.accentGoldLight
                                    : AppColors.primaryDark,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (assignedPrayerNames.isNotEmpty) ...[
            10.ver,
            Wrap(
              spacing: 6.w,
              runSpacing: 4.h,
              children: assignedPrayerNames.map((prayer) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarkBackground.withValues(
                      alpha: isDark ? 0.3 : 0.1,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.primaryDarkBackground.withValues(
                        alpha: 0.3,
                      ),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 12.r,
                        color: isDark
                            ? AppColors.accentGoldLight
                            : AppColors.primaryDark,
                      ),
                      4.hor,
                      Text(
                        prayer,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.accentGoldLight
                              : AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          if (isDownloading) ...[
            10.ver,
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: downloadProgress > 0 ? downloadProgress : null,
                backgroundColor: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryDarkBackground,
                ),
                minHeight: 4.h,
              ),
            ),
          ],
          8.ver,
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: AdhanCardActionButtonsWidget(
              item: item,
              isDownloading: isDownloading,
              onDownload: onDownload,
              onDelete: onDelete,
              onSet: onSet,
            ),
          ),
        ],
      ),
    );
  }
}
