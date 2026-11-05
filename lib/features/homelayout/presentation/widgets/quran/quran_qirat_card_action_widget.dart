import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../quran/domain/entities/qirat_type.dart';
import '../../../../quran/presentation/bloc/quran_state.dart';
import 'quran_qirat_download_progress_widget.dart';

class QuranQiratCardActionWidget extends StatelessWidget {
  final QiratType qirat;
  final QuranAssetStatus assetStatus;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onOpen;

  const QuranQiratCardActionWidget({
    super.key,
    required this.qirat,
    required this.assetStatus,
    required this.downloadProgress,
    required this.onDownload,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = qirat.themeColor;

    if (assetStatus == QuranAssetStatus.downloading) {
      return QuranQiratDownloadProgressWidget(
        progress: downloadProgress,
        color: color,
      );
    }

    if (assetStatus == QuranAssetStatus.downloaded) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.2 : 0.12),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.4 : 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: color,
                  size: 13.sp,
                ),
                4.hor,
                Text(
                  context.strings.offlineAvailable,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isDark ? color : color.withValues(alpha: 0.95),
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          8.hor,
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: color.withValues(alpha: 0.8),
            size: 14.sp,
          ),
        ],
      );
    }

    return InkWell(
      onTap: onDownload,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.18 : 0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.6 : 0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_rounded,
              size: 14.sp,
              color: color,
            ),
            4.hor,
            Text(
              '${qirat.approximateSizeMb} MB',
              style: context.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

