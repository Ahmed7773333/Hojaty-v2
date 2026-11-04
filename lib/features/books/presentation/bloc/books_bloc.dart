import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/book_download_state.dart';
import '../../data/models/book_info_model.dart';
import '../../data/repositories/books_repository.dart';
import 'books_event.dart';
import 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final BooksRepository repository;
  final Map<String, StreamSubscription> _downloadSubscriptions = {};

  BooksBloc({required this.repository}) : super(const BooksState()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<FilterBooksByCategoryEvent>(_onFilterByCategory);
    on<SearchBooksEvent>(_onSearchBooks);
    on<DownloadBookEvent>(_onDownloadBook);
    on<BookDownloadProgressUpdatedEvent>(_onProgressUpdated);
    on<DeleteBookEvent>(_onDeleteBook);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(state.copyWith(status: BooksStatus.loading));
    try {
      final all = BookInfoModel.allBooks;
      final statuses = await repository.checkAllBooksStatus();

      emit(
        state.copyWith(
          status: BooksStatus.loaded,
          allBooks: all,
          filteredBooks: all,
          downloadStatuses: statuses,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BooksStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onFilterByCategory(
    FilterBooksByCategoryEvent event,
    Emitter<BooksState> emit,
  ) {
    final filtered = _applyFilters(
      allBooks: state.allBooks,
      category: event.category,
      query: state.searchQuery,
    );

    emit(
      state.copyWith(
        selectedCategory: event.category,
        clearCategory: event.category == null,
        filteredBooks: filtered,
      ),
    );
  }

  void _onSearchBooks(
    SearchBooksEvent event,
    Emitter<BooksState> emit,
  ) {
    final filtered = _applyFilters(
      allBooks: state.allBooks,
      category: state.selectedCategory,
      query: event.query,
    );

    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredBooks: filtered,
      ),
    );
  }

  Future<void> _onDownloadBook(
    DownloadBookEvent event,
    Emitter<BooksState> emit,
  ) async {
    final book = event.book;
    final updatedStatuses = Map<String, BookDownloadProgress>.from(state.downloadStatuses);
    updatedStatuses[book.id] = BookDownloadProgress(
      bookId: book.id,
      status: BookDownloadStatus.downloading,
      progress: 0.0,
    );

    emit(state.copyWith(downloadStatuses: updatedStatuses));

    await _downloadSubscriptions[book.id]?.cancel();
    _downloadSubscriptions[book.id] = repository.downloadBook(book).listen(
      (progress) {
        add(BookDownloadProgressUpdatedEvent(progress));
      },
      onError: (err) {
        add(
          BookDownloadProgressUpdatedEvent(
            BookDownloadProgress(
              bookId: book.id,
              status: BookDownloadStatus.failed,
              errorMessage: err.toString(),
            ),
          ),
        );
      },
    );
  }

  void _onProgressUpdated(
    BookDownloadProgressUpdatedEvent event,
    Emitter<BooksState> emit,
  ) {
    final updatedStatuses = Map<String, BookDownloadProgress>.from(state.downloadStatuses);
    updatedStatuses[event.progress.bookId] = event.progress;
    emit(state.copyWith(downloadStatuses: updatedStatuses));
  }

  Future<void> _onDeleteBook(
    DeleteBookEvent event,
    Emitter<BooksState> emit,
  ) async {
    final book = event.book;
    await repository.deleteBook(book);

    final updatedStatuses = Map<String, BookDownloadProgress>.from(state.downloadStatuses);
    updatedStatuses[book.id] = BookDownloadProgress(
      bookId: book.id,
      status: BookDownloadStatus.notDownloaded,
      progress: 0.0,
    );

    emit(state.copyWith(downloadStatuses: updatedStatuses));
  }

  List<BookInfoModel> _applyFilters({
    required List<BookInfoModel> allBooks,
    required BookCategory? category,
    required String query,
  }) {
    var result = allBooks;

    if (category != null) {
      result = result.where((b) => b.category == category).toList();
    }

    final trimmed = query.trim().toLowerCase();
    if (trimmed.isNotEmpty) {
      result = result.where((b) {
        final titleMatch = b.titleAr.toLowerCase().contains(trimmed) ||
            b.titleEn.toLowerCase().contains(trimmed);
        final authorMatch = b.authorAr.toLowerCase().contains(trimmed) ||
            b.authorEn.toLowerCase().contains(trimmed);
        return titleMatch || authorMatch;
      }).toList();
    }

    return result;
  }

  @override
  Future<void> close() {
    for (final sub in _downloadSubscriptions.values) {
      sub.cancel();
    }
    return super.close();
  }
}

