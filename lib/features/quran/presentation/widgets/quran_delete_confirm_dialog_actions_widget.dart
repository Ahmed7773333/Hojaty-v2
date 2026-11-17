import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';

class QuranDeleteConfirmDialogActionsWidget extends StatelessWidget {
  const QuranDeleteConfirmDialogActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final errorColor = Theme.of(context).colorScheme.error;

    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: context.strings.cancel,
            onPressed: () => Navigator.of(context).pop(false),
            backgroundColor: isDark
                ? AppColors.darkCardSelected
                : AppColors.lightCardSelected,
            foregroundColor: isDark
                ? AppColors.darkTextPrimary
                : AppColors.primaryDark,
            height: 46.h,
            borderRadius: 23.r,
          ),
        ),
        12.hor,
        Expanded(
          child: CustomElevatedButton(
            text: context.strings.delete,
            onPressed: () => Navigator.of(context).pop(true),
            backgroundColor: errorColor,
            foregroundColor: AppColors.white,
            height: 46.h,
            borderRadius: 23.r,
          ),
        ),
      ],
    );
  }
}
