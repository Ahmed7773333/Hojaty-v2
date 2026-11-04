import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';

class ExitAppDialogActionsWidget extends StatelessWidget {
  const ExitAppDialogActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: context.strings.exitAppCancel,
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
            text: context.strings.exitAppConfirm,
            onPressed: () => Navigator.of(context).pop(true),
            backgroundColor:
                isDark ? AppColors.accentGold : AppColors.primaryDark,
            foregroundColor:
                isDark ? AppColors.primaryDarkBackground : AppColors.white,
            height: 46.h,
            borderRadius: 23.r,
          ),
        ),
      ],
    );
  }
}
