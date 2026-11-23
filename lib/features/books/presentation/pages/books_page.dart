import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_download_state.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:hojaty/features/books/data/repositories/books_repository.dart';
import 'package:hojaty/features/books/presentation/bloc/books_bloc.dart';
import 'package:hojaty/features/books/presentation/bloc/books_event.dart';
import 'package:hojaty/features/books/presentation/bloc/books_state.dart';
import 'package:hojaty/features/books/presentation/widgets/books/book_card_widget.dart';
import 'package:hojaty/features/books/presentation/widgets/books/book_delete_confirm_dialog.dart';
import 'package:hojaty/features/books/presentation/widgets/books/book_open_options_sheet.dart';
import 'package:hojaty/features/books/presentation/widgets/books/books_category_filter_widget.dart';
import 'package:hojaty/features/books/presentation/widgets/books/books_header_widget.dart';
import 'package:hojaty/features/books/presentation/widgets/books/books_search_bar_widget.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late final BooksBloc _booksBloc;

  @override
  void initState() {
    super.initState();
    _booksBloc = injector<BooksBloc>();
    _booksBloc.add(const LoadBooksEvent());
  }

  Future<void> _handleBookTap(BuildContext context, BookInfoModel book) async {
    final repo = injector<BooksRepository>();
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final collection = await repo.getBookContent(book);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loading

      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      final showChapters = collection.chapters.length > 1;

      if (showChapters) {
        context.pushNamed(
          AppRoutes.bookChapters,
          extra: {'book': book, 'collection': collection},
        );
      } else {
        context.pushNamed(
          AppRoutes.bookHadiths,
          extra: {
            'bookTitle': book.getDisplayTitle(isAr),
            'chapterTitle': collection.chapters.isNotEmpty
                ? collection.chapters.first.arabic
                : '',
            'hadiths': collection.hadiths,
            'book': book,
            'collection': collection,
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _onBookCardTap(BuildContext context, BookInfoModel book) {
    if (book.hasPdf) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => BookOpenOptionsSheet(
          book: book,
          onReadText: () {
            Navigator.of(sheetContext).pop();
            _handleBookTap(context, book);
          },
          onOpenPdf: () {
            Navigator.of(sheetContext).pop();
            _handleOpenPdf(context, book);
          },
        ),
      );
    } else {
      _handleBookTap(context, book);
    }
  }

  Future<void> _handleOpenPdf(BuildContext context, BookInfoModel book) async {
    final repo = injector<BooksRepository>();
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final success = await repo.openBookPdf(book);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loading

      if (!success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.strings.pdfNotFound)));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.strings.pdfOpenError)));
      }
    }
  }

  void _onDownload(BookInfoModel book) {
    _booksBloc.add(DownloadBookEvent(book));
  }

  Future<void> _onDelete(BookInfoModel book) async {
    if (kDebugMode) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => BookDeleteConfirmDialog(book: book),
    );
    if (confirmed == true && mounted) {
      _booksBloc.add(DeleteBookEvent(book));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocProvider.value(
      value: _booksBloc,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Column(
          children: [
            BooksHeaderWidget(onBack: () => context.pop()),
            12.ver,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BooksSearchBarWidget(
                onChanged: (q) => _booksBloc.add(SearchBooksEvent(q)),
              ),
            ),
            12.ver,
            BlocBuilder<BooksBloc, BooksState>(
              buildWhen: (prev, curr) =>
                  prev.selectedCategory != curr.selectedCategory,
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: BooksCategoryFilterWidget(
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: (cat) =>
                        _booksBloc.add(FilterBooksByCategoryEvent(cat)),
                  ),
                );
              },
            ),
            12.ver,
            Expanded(
              child: BlocBuilder<BooksBloc, BooksState>(
                builder: (context, state) {
                  if (state.status == BooksStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final books = state.filteredBooks;
                  if (books.isEmpty) {
                    return Center(
                      child: Text(
                        context.strings.noBooksFound,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    itemCount: books.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final progress = kDebugMode
                          ? BookDownloadProgress(
                              bookId: book.id,
                              status: BookDownloadStatus.downloaded,
                              progress: 1.0,
                              localFilePath:
                                  book.category == BookCategory.ibnBaz
                                  ? 'assets/debug/elbaz/${book.assetName}'
                                  : 'assets/debug/${book.assetName}',
                            )
                          : state.getDownloadStatus(book.id);

                      return BookCardWidget(
                        book: book,
                        downloadProgress: progress,
                        onTap: () => _onBookCardTap(context, book),
                        onDownload: () => _onDownload(book),
                        onDelete: () => _onDelete(book),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
