import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../quran/domain/entities/qirat_type.dart';

class QuranDownloadConfirmDialogActionsWidget extends StatelessWidget {
  final QiratType qirat;

  const QuranDownloadConfirmDialogActionsWidget({
    super.key,
    required this.qirat,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = qirat.themeColor;

    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: context.strings.cancel,
            onPressed: () => Navigator.of(context).pop(false),
            backgroundColor:
                isDark ? AppColors.darkCardSelected : AppColors.lightCardSelected,
            foregroundColor:
                isDark ? AppColors.darkTextPrimary : AppColors.primaryDark,
            height: 46.h,
            borderRadius: 23.r,
          ),
        ),
        12.hor,
        Expanded(
          child: CustomElevatedButton(
            text: context.strings.download,
            onPressed: () => Navigator.of(context).pop(true),
            backgroundColor: color,
            foregroundColor: AppColors.white,
            height: 46.h,
            borderRadius: 23.r,
          ),
        ),
      ],
    );
  }
}

