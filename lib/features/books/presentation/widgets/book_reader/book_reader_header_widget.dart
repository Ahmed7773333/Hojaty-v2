import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/features/books/data/models/book_reader_theme_model.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class BookReaderHeaderWidget extends StatelessWidget {
  final String title;
  final String chapterTitle;
  final BookReaderThemeModel theme;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onToc;
  final VoidCallback onSettings;
  final VoidCallback onShare;

  const BookReaderHeaderWidget({
    super.key,
    required this.title,
    required this.chapterTitle,
    required this.theme,
    required this.onBack,
    required this.onSearch,
    required this.onToc,
    required this.onSettings,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 10.h,
        left: 12.w,
        right: 12.w,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkHeader : AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (chapterTitle.isNotEmpty) ...[
                  2.ver,
                  Text(
                    chapterTitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color:  AppColors.accentGoldLight,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onSearch,
            icon: Icon(Icons.search_rounded, color: Colors.white, size: 20.sp),
            tooltip: context.strings.searchBooksHint,
          ),
          IconButton(
            onPressed: onToc,
            icon: Icon(Icons.menu_book_rounded, color: Colors.white, size: 20.sp),
            tooltip: context.strings.tableOfContents,
          ),
          IconButton(
            onPressed: onSettings,
            icon: Icon(Icons.format_size_rounded, color: Colors.white, size: 20.sp),
            tooltip: context.strings.readerSettings,
          ),
          IconButton(
            onPressed: onShare,
            icon: Icon(Icons.share_rounded, color: Colors.white, size: 20.sp),
            tooltip: context.strings.sharePdf,
          ),
        ],
      ),
    );
  }
}

