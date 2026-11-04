import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/hadith_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HadithCardWidget extends StatelessWidget {
  final HadithItemModel hadith;
  final int index;

  const HadithCardWidget({
    super.key,
    required this.hadith,
    required this.index,
  });

  void _copyToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln(hadith.arabic);
    if (hadith.englishText.isNotEmpty) {
      buffer.writeln();
      if (hadith.englishNarrator.isNotEmpty) {
        buffer.writeln(hadith.englishNarrator);
      }
      buffer.writeln(hadith.englishText);
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.strings.hadithCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkSurface
                      : AppColors.lightCardSelected,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorderSelected
                        : AppColors.primaryDark.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${context.strings.hadithWord} ${hadith.idInBook > 0 ? hadith.idInBook : index}',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.accentGold
                        : AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.copy_rounded,
                  size: 18.sp,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
                onPressed: () => _copyToClipboard(context),
                tooltip: context.strings.copy,
              ),
            ],
          ),
          12.ver,
          Text(
            hadith.arabic,
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            style: context.textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontSize: 17.sp,
              height: 1.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hadith.englishText.isNotEmpty) ...[
            14.ver,
            Divider(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
            10.ver,
            if (hadith.englishNarrator.isNotEmpty) ...[
              Text(
                hadith.englishNarrator,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.accentGoldLight
                      : AppColors.primaryDark,
                  fontStyle: FontStyle.italic,
                  fontSize: 12.sp,
                ),
              ),
              6.ver,
            ],
            Text(
              hadith.englishText,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 13.sp,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
