import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';

class ShareDownloadConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmDownload;

  const ShareDownloadConfirmationDialog({
    super.key,
    required this.onConfirmDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        context.strings.shareRecitation,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      content: Text(
        context.strings.downloadAudioPrompt,
        style: context.textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            context.strings.cancel,
            style: context.textTheme.labelLarge?.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
        CustomElevatedButton(
          text: context.strings.downloadAndShare,
          width: 150.w,
          height: 40.h,
          onPressed: () {
            context.pop();
            onConfirmDownload();
          },
        ),
      ],
    );
  }
}

