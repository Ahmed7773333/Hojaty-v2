import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_chapter_model.dart';

class BookReaderTocSheet extends StatefulWidget {
  final List<BookChapterModel> chapters;
  final Map<int, int> chapterStartPages;
  final int currentChapterId;
  final ValueChanged<int> onSelectChapterPage;

  const BookReaderTocSheet({
    super.key,
    required this.chapters,
    required this.chapterStartPages,
    required this.currentChapterId,
    required this.onSelectChapterPage,
  });

  @override
  State<BookReaderTocSheet> createState() => _BookReaderTocSheetState();
}

class _BookReaderTocSheetState extends State<BookReaderTocSheet> {
  late List<BookChapterModel> _filteredChapters;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredChapters = widget.chapters;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final trimmed = query.trim().toLowerCase();
    setState(() {
      if (trimmed.isEmpty) {
        _filteredChapters = widget.chapters;
      } else {
        _filteredChapters = widget.chapters.where((c) {
          return c.arabic.toLowerCase().contains(trimmed) ||
              c.english.toLowerCase().contains(trimmed);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.strings.tableOfContents,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          8.ver,
          TextField(
            controller: _searchController,
            onChanged: _filter,
            decoration: InputDecoration(
              hintText: context.strings.searchChaptersHint,
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 10.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          12.ver,
          Expanded(
            child: _filteredChapters.isEmpty
                ? Center(
                    child: Text(
                      context.strings.noChaptersFound,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredChapters.length,
                    separatorBuilder: (_, __) => 6.ver,
                    itemBuilder: (context, index) {
                      final chapter = _filteredChapters[index];
                      final isSelected = chapter.id == widget.currentChapterId;
                      final startPage =
                          widget.chapterStartPages[chapter.id] ?? 1;

                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(
                            color: isSelected
                                ? (isDark
                                      ? AppColors.darkBorderSelected
                                      : AppColors.primaryDark)
                                : Colors.transparent,
                          ),
                        ),
                        tileColor: isSelected
                            ? (isDark
                                  ? AppColors.primaryDarkSurface
                                  : AppColors.lightCardSelected)
                            : (isDark
                                  ? AppColors.darkCardUnselected
                                  : AppColors.lightBackground),
                        dense: true,
                        title: Text(
                          chapter.arabic,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13.sp,
                          ),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '${context.strings.pageWord} $startPage',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: isDark
                                  ? AppColors.accentGold
                                  : AppColors.primaryDark,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onSelectChapterPage(startPage);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
