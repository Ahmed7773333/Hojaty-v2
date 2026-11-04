import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/book_info_model.dart';
import '../../data/repositories/books_repository.dart';
import '../bloc/books_bloc.dart';
import '../bloc/books_event.dart';
import '../bloc/books_state.dart';
import '../widgets/books/book_card_widget.dart';
import '../widgets/books/books_category_filter_widget.dart';
import '../widgets/books/books_header_widget.dart';
import '../widgets/books/books_search_bar_widget.dart';

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
          extra: {
            'book': book,
            'collection': collection,
          },
        );
      } else {
        context.pushNamed(
          AppRoutes.bookHadiths,
          extra: {
            'bookTitle': book.getDisplayTitle(isAr),
            'chapterTitle': collection.chapters.isNotEmpty ? collection.chapters.first.arabic : '',
            'hadiths': collection.hadiths,
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _onDownload(BookInfoModel book) {
    _booksBloc.add(DownloadBookEvent(book));
  }

  void _onDelete(BookInfoModel book) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = ctx.isDark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            context.strings.deleteDownload,
            style: ctx.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            '${context.strings.deleteDownloadConfirm} (${book.getDisplayTitle(Localizations.localeOf(context).languageCode == 'ar')})',
            style: ctx.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.strings.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(ctx);
                _booksBloc.add(DeleteBookEvent(book));
              },
              child: Text(context.strings.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocProvider.value(
      value: _booksBloc,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Column(
          children: [
            BooksHeaderWidget(
              onBack: () => context.pop(),
            ),
            12.ver,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BooksSearchBarWidget(
                onChanged: (q) => _booksBloc.add(SearchBooksEvent(q)),
              ),
            ),
            12.ver,
            BlocBuilder<BooksBloc, BooksState>(
              buildWhen: (prev, curr) => prev.selectedCategory != curr.selectedCategory,
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: BooksCategoryFilterWidget(
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: (cat) => _booksBloc.add(FilterBooksByCategoryEvent(cat)),
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
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: books.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final progress = state.getDownloadStatus(book.id);

                      return BookCardWidget(
                        book: book,
                        downloadProgress: progress,
                        onTap: () => _handleBookTap(context, book),
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

