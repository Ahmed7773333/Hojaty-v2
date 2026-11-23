import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';

class QuranVerseSheetActionsWidget extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onOpenTafseer;
  final VoidCallback onShare;
  final VoidCallback onToggleBookmark;
  final bool isBookmarked;

  const QuranVerseSheetActionsWidget({
    super.key,
    required this.onCopy,
    required this.onOpenTafseer,
    required this.onShare,
    required this.onToggleBookmark,
    required this.isBookmarked,
  });

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
            10.hor,
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
        ),
        8.ver,
        Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                text: context.strings.shareVerse,
                onPressed: onShare,
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
            10.hor,
            Expanded(
              child: CustomElevatedButton(
                text: isBookmarked
                    ? context.strings.removeBookmark
                    : context.strings.saveBookmark,
                onPressed: onToggleBookmark,
                backgroundColor: isBookmarked
                    ? (isDark
                        ? AppColors.accentGold.withValues(alpha: 0.25)
                        : AppColors.accentGold.withValues(alpha: 0.2))
                    : (isDark
                        ? AppColors.darkCardSelected
                        : AppColors.lightCardSelected),
                foregroundColor: isBookmarked
                    ? (isDark
                        ? AppColors.accentGoldLight
                        : AppColors.accentGold)
                    : (isDark
                        ? AppColors.accentGoldLight
                        : AppColors.primaryDark),
                height: 44.h,
                borderRadius: 22.r,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
