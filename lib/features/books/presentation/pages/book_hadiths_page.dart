import 'package:flutter/material.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_collection_model.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:hojaty/features/books/data/models/hadith_item_model.dart';
import 'package:hojaty/features/books/data/repositories/books_repository.dart';
import 'package:hojaty/features/books/presentation/widgets/book_details/book_hadiths_header_widget.dart';
import 'package:hojaty/features/books/presentation/widgets/book_details/hadith_card_widget.dart';

class BookHadithsPage extends StatefulWidget {
  final String bookTitle;
  final String chapterTitle;
  final List<HadithItemModel> hadiths;
  final BookInfoModel? book;
  final BookCollectionModel? collection;

  const BookHadithsPage({
    super.key,
    required this.bookTitle,
    required this.chapterTitle,
    required this.hadiths,
    this.book,
    this.collection,
  });

  @override
  State<BookHadithsPage> createState() => _BookHadithsPageState();
}

class _BookHadithsPageState extends State<BookHadithsPage> {
  late List<HadithItemModel> _filteredHadiths;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredHadiths = widget.hadiths;
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
        _filteredHadiths = widget.hadiths;
      } else {
        _filteredHadiths = widget.hadiths.where((h) {
          return h.arabic.toLowerCase().contains(trimmed) ||
              h.englishText.toLowerCase().contains(trimmed) ||
              h.englishNarrator.toLowerCase().contains(trimmed) ||
              h.idInBook.toString().contains(trimmed);
        }).toList();
      }
    });
  }

  void _openReader() {
    if (widget.book == null || widget.collection == null) return;
    final firstHadith = widget.hadiths.isNotEmpty ? widget.hadiths.first : null;
    context.pushNamed(
      AppRoutes.bookReader,
      extra: {
        'book': widget.book,
        'collection': widget.collection,
        'initialChapterId': firstHadith?.chapterId,
        'initialHadithId': firstHadith?.id,
      },
    );
  }

  Future<void> _openPdf() async {
    if (widget.book == null) return;
    final repo = injector<BooksRepository>();
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final success = await repo.openBookPdf(widget.book!);

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

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          BookHadithsHeaderWidget(
            bookTitle: widget.bookTitle,
            chapterTitle: widget.chapterTitle,
            count: _filteredHadiths.length,
            onBack: () => context.pop(),
            onReadBook: (widget.book != null && widget.collection != null)
                ? _openReader
                : null,
            onOpenPdf: (widget.book?.hasPdf == true) ? _openPdf : null,
          ),
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
                  hintText: context.strings.searchHadithsHint,
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
            child: _filteredHadiths.isEmpty
                ? Center(
                    child: Text(
                      context.strings.noHadithsFound,
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
                    itemCount: _filteredHadiths.length,
                    separatorBuilder: (_, __) => 12.ver,
                    itemBuilder: (context, index) {
                      final hadith = _filteredHadiths[index];
                      return HadithCardWidget(hadith: hadith, index: index + 1);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
