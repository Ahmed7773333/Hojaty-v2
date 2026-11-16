import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/azan_audio_item_model.dart';

class AdhanCardActionButtonsWidget extends StatelessWidget {
  final AzanAudioItemModel item;
  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback onDelete;
  final VoidCallback onSet;

  const AdhanCardActionButtonsWidget({
    super.key,
    required this.item,
    required this.isDownloading,
    required this.onDownload,
    required this.onDelete,
    required this.onSet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!item.isBuiltIn) ...[
          if (item.isDownloaded)
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 20.r,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: context.strings.deleteAdhanAction,
              onPressed: onDelete,
            )
          else if (!isDownloading)
            IconButton(
              icon: Icon(
                Icons.download_rounded,
                size: 20.r,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              tooltip: context.strings.downloadAdhanAction,
              onPressed: onDownload,
            ),
        ],
        8.hor,
        InkWell(
          onTap: onSet,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primaryDarkBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_rounded,
                  size: 16.r,
                  color: AppColors.white,
                ),
                6.hor,
                Text(
                  context.strings.setAdhanAction,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

