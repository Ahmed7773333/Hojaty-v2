import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../quran/domain/entities/qirat_type.dart';
import 'quran_download_confirm_dialog_actions_widget.dart';

class QuranDownloadConfirmDialog extends StatelessWidget {
  final QiratType qirat;

  const QuranDownloadConfirmDialog({
    super.key,
    required this.qirat,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = qirat.themeColor;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: isDark
                    ? color.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_download_rounded,
                color: color,
                size: 28.r,
              ),
            ),
            16.ver,
            Text(
              context.strings.downloadQiratConfirmTitle,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            8.ver,
            Text(
              context.strings.downloadQiratConfirmDesc(
                qirat.label(context),
                qirat.approximateSizeMb,
              ),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            24.ver,
            QuranDownloadConfirmDialogActionsWidget(qirat: qirat),
          ],
        ),
      ),
    );
  }
}

