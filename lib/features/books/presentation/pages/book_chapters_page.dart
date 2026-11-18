import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_chapter_model.dart';
import 'package:hojaty/features/books/data/models/book_collection_model.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:hojaty/features/books/data/repositories/books_repository.dart';
import 'package:hojaty/features/books/presentation/widgets/book_details/book_chapter_tile_widget.dart';
import 'package:hojaty/features/books/presentation/widgets/book_details/book_chapters_header_widget.dart';
import 'package:hojaty/features/books/presentation/widgets/book_details/book_read_mode_banner_widget.dart';

class BookChaptersPage extends StatefulWidget {
  final BookInfoModel book;
  final BookCollectionModel collection;

  const BookChaptersPage({
    super.key,
    required this.book,
    required this.collection,
  });

  @override
  State<BookChaptersPage> createState() => _BookChaptersPageState();
}

class _BookChaptersPageState extends State<BookChaptersPage> {
  late List<BookChapterModel> _filteredChapters;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredChapters = widget.collection.chapters;
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
        _filteredChapters = widget.collection.chapters;
      } else {
        _filteredChapters = widget.collection.chapters.where((c) {
          return c.arabic.toLowerCase().contains(trimmed) ||
              c.english.toLowerCase().contains(trimmed);
        }).toList();
      }
    });
  }

  void _openChapter(BookChapterModel chapter) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final hadiths = widget.collection.hadiths
        .where((h) => h.chapterId == chapter.id)
        .toList();

    context.pushNamed(
      AppRoutes.bookHadiths,
      extra: {
        'bookTitle': widget.book.getDisplayTitle(isAr),
        'chapterTitle': chapter.arabic,
        'hadiths': hadiths,
        'book': widget.book,
        'collection': widget.collection,
      },
    );
  }

  void _openFullBookReader() {
    context.pushNamed(
      AppRoutes.bookReader,
      extra: {'book': widget.book, 'collection': widget.collection},
    );
  }

  void _openChapterInReader(BookChapterModel chapter) {
    context.pushNamed(
      AppRoutes.bookReader,
      extra: {
        'book': widget.book,
        'collection': widget.collection,
        'initialChapterId': chapter.id,
      },
    );
  }

  Future<void> _openPdf() async {
    final repo = injector<BooksRepository>();
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final success = await repo.openBookPdf(widget.book);

      if (!mounted) return;
      Navigator.of(context).pop();

      if (!success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.strings.pdfNotFound)));
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.strings.pdfOpenError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          BookChaptersHeaderWidget(
            title: widget.book.getDisplayTitle(isAr),
            author: widget.book.getDisplayAuthor(isAr),
            totalHadiths: widget.collection.hadiths.length,
            onBack: () => context.pop(),
            onReadBook: _openFullBookReader,
            onOpenPdf: widget.book.hasPdf ? _openPdf : null,
          ),
          12.ver,
          BookReadModeBannerWidget(onTap: _openFullBookReader),
          12.ver,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filter,
                decoration: InputDecoration(
                  hintText: context.strings.searchChaptersHint,
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                    fontSize: 13.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark
                        ? AppColors.accentGold
                        : AppColors.primaryDark,
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    itemCount: _filteredChapters.length,
                    separatorBuilder: (_, __) => 8.ver,
                    itemBuilder: (context, index) {
                      final chapter = _filteredChapters[index];
                      final count = widget.collection.hadiths
                          .where((h) => h.chapterId == chapter.id)
                          .length;

                      return BookChapterTileWidget(
                        chapter: chapter,
                        index: index + 1,
                        hadithsCount: count,
                        onTap: () => _openChapter(chapter),
                        onReadBookTap: () => _openChapterInReader(chapter),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
