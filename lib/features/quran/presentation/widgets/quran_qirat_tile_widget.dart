import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../domain/entities/qirat_type.dart';
import '../bloc/quran_state.dart';

class QuranQiratTileWidget extends StatelessWidget {
  final QiratType qirat;
  final bool isSelected;
  final QuranAssetStatus assetStatus;
  final double downloadProgress;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const QuranQiratTileWidget({
    super.key,
    required this.qirat,
    required this.isSelected,
    required this.assetStatus,
    required this.downloadProgress,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isDownloaded = assetStatus == QuranAssetStatus.downloaded;
    final isDownloading = assetStatus == QuranAssetStatus.downloading;

    Widget trailingWidget;
    if (isDownloading) {
      final percent = (downloadProgress * 100).clamp(0, 100).toInt();
      trailingWidget = SizedBox(
        width: 70.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$percent%',
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.accentGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            4.ver,
            LinearProgressIndicator(
              value: downloadProgress > 0 ? downloadProgress : null,
              color: AppColors.accentGold,
              backgroundColor: isDark ? AppColors.darkCardUnselected : AppColors.lightCardSelected,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ],
        ),
      );
    } else if (isDownloaded) {
      trailingWidget = Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.primaryDarkSurface : AppColors.lightCardSelected,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: isDark ? AppColors.accentGold : AppColors.primaryDark,
              size: 14.sp,
            ),
            4.hor,
            Text(
              context.strings.offlineAvailable,
              style: context.textTheme.labelSmall?.copyWith(
                color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      );
    } else {
      trailingWidget = InkWell(
        onTap: onDownload,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isDark ? AppColors.darkBorderSelected : AppColors.primaryDark,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download_rounded,
                size: 14.sp,
                color: isDark ? AppColors.accentGold : AppColors.primaryDark,
              ),
              4.hor,
              Text(
                '${qirat.approximateSizeMb} MB',
                style: context.textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected)
            : (isDark ? AppColors.darkCardUnselected : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected
              ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
              : (isDark ? AppColors.darkBorderUnselected : AppColors.lightBorderUnselected),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        onTap: isDownloaded ? onTap : onDownload,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        leading: Icon(
          isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
          color: isSelected
              ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
              : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        ),
        title: Text(
          qirat.label(context),
          style: context.textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 15.sp,
          ),
        ),
        trailing: trailingWidget,
      ),
    );
  }
}
