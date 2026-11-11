import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/rate_app_helper.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';

class RateAppDialogActionsWidget extends StatelessWidget {
  const RateAppDialogActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                text: context.strings.rateAppLater,
                onPressed: () => Navigator.of(context).pop(),
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
                text: context.strings.rateAppNow,
                onPressed: () {
                  Navigator.of(context).pop();
                  RateAppHelper.openStoreForRating();
                },
                backgroundColor: isDark
                    ? AppColors.accentGold
                    : AppColors.primaryDark,
                foregroundColor: isDark
                    ? AppColors.primaryDarkBackground
                    : AppColors.white,
                height: 46.h,
                borderRadius: 23.r,
              ),
            ),
          ],
        ),
        8.ver,
        TextButton(
          onPressed: () {
            RateAppHelper.markAsRated();
            Navigator.of(context).pop();
          },
          child: Text(
            context.strings.rateAppAlreadyRated,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}

