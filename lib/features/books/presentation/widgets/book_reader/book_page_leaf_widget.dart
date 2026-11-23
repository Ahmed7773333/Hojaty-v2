import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_page_model.dart';
import 'package:hojaty/features/books/data/models/book_reader_theme_model.dart';
import 'package:hojaty/features/books/presentation/widgets/book_reader/book_page_chapter_header_widget.dart';
import 'package:hojaty/features/books/presentation/widgets/book_reader/book_page_hadith_item_widget.dart';

class BookPageLeafWidget extends StatelessWidget {
  final BookPageModel page;
  final int totalPages;
  final String bookTitle;
  final double fontSize;
  final BookReaderThemeModel theme;
  final bool showEnglish;
  final VoidCallback onTap;

  const BookPageLeafWidget({
    super.key,
    required this.page,
    required this.totalPages,
    required this.bookTitle,
    required this.fontSize,
    required this.theme,
    required this.showEnglish,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: theme.background,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        child: Container(
          decoration: BoxDecoration(
            color: theme.background,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: theme.border, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Page Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.border.withValues(alpha: 0.8),
                      width: 0.8,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        bookTitle,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: theme.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    8.hor,
                    Flexible(
                      child: Text(
                        page.chapterTitle,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: theme.secondaryText,
                          fontSize: 10.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Page Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (page.isChapterStart && page.chapterTitle.isNotEmpty)
                        BookPageChapterHeaderWidget(
                          title: page.chapterTitle,
                          theme: theme,
                        ),
                      ...List.generate(
                        page.hadiths.length,
                        (i) => BookPageHadithItemWidget(
                          hadith: page.hadiths[i],
                          index: i + 1,
                          fontSize: fontSize,
                          theme: theme,
                          showEnglish: showEnglish,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Page Footer
              Container(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.border.withValues(alpha: 0.8),
                      width: 0.8,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '— ${page.pageNumber} / $totalPages —',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: theme.secondaryText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
