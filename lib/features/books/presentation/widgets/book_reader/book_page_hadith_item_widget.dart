import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_reader_theme_model.dart';
import 'package:hojaty/features/books/data/models/hadith_item_model.dart';

class BookPageHadithItemWidget extends StatelessWidget {
  final HadithItemModel hadith;
  final int index;
  final double fontSize;
  final BookReaderThemeModel theme;
  final bool showEnglish;

  const BookPageHadithItemWidget({
    super.key,
    required this.hadith,
    required this.index,
    required this.fontSize,
    required this.theme,
    required this.showEnglish,
  });

  void _copyHadith(BuildContext context) {
    Clipboard.setData(ClipboardData(text: hadith.arabic));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.strings.hadithCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.border.withValues(alpha: 0.7), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: theme.badgeBackground,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '${context.strings.hadithWord} ${hadith.idInBook > 0 ? hadith.idInBook : index}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: theme.badgeText,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.copy_rounded,
                  size: 16.sp,
                  color: theme.secondaryText,
                ),
                onPressed: () => _copyHadith(context),
                tooltip: context.strings.copy,
              ),
            ],
          ),
          10.ver,
          Text(
            hadith.arabic,
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            style: context.textTheme.bodyLarge?.copyWith(
              color: theme.primaryText,
              fontSize: fontSize.sp,
              height: 1.85,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showEnglish && hadith.englishText.isNotEmpty) ...[
            12.ver,
            Divider(color: theme.border, height: 1),
            8.ver,
            if (hadith.englishNarrator.isNotEmpty) ...[
              Text(
                hadith.englishNarrator,
                style: context.textTheme.bodySmall?.copyWith(
                  color: theme.accent,
                  fontSize: (fontSize - 4).clamp(10, 16).sp,
                  fontStyle: FontStyle.italic,
                ),
              ),
              4.ver,
            ],
            Text(
              hadith.englishText,
              style: context.textTheme.bodyMedium?.copyWith(
                color: theme.secondaryText,
                fontSize: (fontSize - 3).clamp(11, 18).sp,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

