import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_download_state.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:flutter/material.dart';

class BookCardWidget extends StatelessWidget {
  final BookInfoModel book;
  final BookDownloadProgress downloadProgress;
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const BookCardWidget({
    super.key,
    required this.book,
    required this.downloadProgress,
    required this.onTap,
    required this.onDownload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDownloaded =
        downloadProgress.status == BookDownloadStatus.downloaded;
    final isDownloading =
        downloadProgress.status == BookDownloadStatus.downloading;

    return Material(
      color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: isDownloading ? null : (isDownloaded ? onTap : onDownload),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDownloaded
                  ? (isDark
                        ? AppColors.accentGold.withValues(alpha: 0.5)
                        : AppColors.primaryDark.withValues(alpha: 0.3))
                  : (isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected),
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.primaryDarkBackground,
                              AppColors.primaryDarkSurface,
                            ]
                          : [
                              AppColors.primaryDark,
                              AppColors.primaryDarkSurface,
                            ],
                    ),
                  ),
                  padding: EdgeInsets.all(10.r),
                  child: Stack(
                    children: [
                      Positioned(
                        right: isAr ? null : 0,
                        left: isAr ? 0 : null,
                        bottom: 0,
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 48.sp,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              book.getDisplayTitle(isAr),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13.sp,
                                height: 1.3,
                              ),
                            ),
                            6.ver,
                            Text(
                              book.getDisplayAuthor(isAr),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.accentGoldLight,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              10.ver,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${book.hadithCount} ${context.strings.hadithWord}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    '${book.sizeMb} MB',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
              8.ver,
              if (isDownloading) ...[
                LinearProgressIndicator(
                  value: downloadProgress.progress > 0
                      ? downloadProgress.progress
                      : null,
                  color: AppColors.accentGold,
                  backgroundColor: isDark
                      ? AppColors.darkCardSelected
                      : AppColors.lightCardSelected,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                4.ver,
                Text(
                  '${(downloadProgress.progress * 100).toInt()}% ${context.strings.downloading}',
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppColors.accentGold,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else if (isDownloaded) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 14.sp,
                          color: isDark
                              ? AppColors.accentGold
                              : AppColors.primaryDark,
                        ),
                        4.hor,
                        Text(
                          context.strings.offlineAvailable,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.accentGold
                                : AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 16.sp,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                InkWell(
                  onTap: onDownload,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryDarkSurface
                          : AppColors.lightCardSelected,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.accentGold.withValues(alpha: 0.5)
                            : AppColors.primaryDark.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          size: 14.sp,
                          color: isDark
                              ? AppColors.accentGold
                              : AppColors.primaryDark,
                        ),
                        4.hor,
                        Text(
                          context.strings.download,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.accentGold
                                : AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
