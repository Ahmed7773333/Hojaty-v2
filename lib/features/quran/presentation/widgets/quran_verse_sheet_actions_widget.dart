import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';

class QuranVerseSheetActionsWidget extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onOpenTafseer;

  const QuranVerseSheetActionsWidget({
    super.key,
    required this.onCopy,
    required this.onOpenTafseer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: context.strings.copy,
            onPressed: onCopy,
            backgroundColor: isDark
                ? AppColors.darkCardSelected
                : AppColors.lightCardSelected,
            foregroundColor: isDark
                ? AppColors.accentGoldLight
                : AppColors.primaryDark,
            height: 44.h,
            borderRadius: 22.r,
          ),
        ),
        12.hor,
        Expanded(
          child: CustomElevatedButton(
            text: context.strings.quranTafseer,
            onPressed: onOpenTafseer,
            backgroundColor: isDark
                ? AppColors.primaryDarkSurface
                : AppColors.primaryDark,
            foregroundColor: AppColors.white,
            height: 44.h,
            borderRadius: 22.r,
          ),
        ),
      ],
    );
  }
}

