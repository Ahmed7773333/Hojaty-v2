import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';
import 'package:material_ui/material_ui.dart';

class HifzWirdCompletionDialog extends StatelessWidget {
  final VoidCallback onDone;

  const HifzWirdCompletionDialog({
    super.key,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_rounded,
              color: AppColors.accentGold,
              size: 36.r,
            ),
          ),
          14.ver,
          Text(
            context.strings.hifzCompletionTitle,
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          8.ver,
          Text(
            context.strings.hifzCompletionSubtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          18.ver,
          CustomElevatedButton(
            text: context.strings.hifzSkipPause == 'تخطي' ? 'حسناً' : 'Done',
            height: 44.h,
            borderRadius: 14.r,
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}

