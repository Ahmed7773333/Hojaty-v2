import 'package:equatable/equatable.dart';
import '../../data/models/book_download_state.dart';
import '../../data/models/book_info_model.dart';

enum BooksStatus {
  initial,
  loading,
  loaded,
  error,
}

class BooksState extends Equatable {
  final BooksStatus status;
  final List<BookInfoModel> allBooks;
  final List<BookInfoModel> filteredBooks;
  final Map<String, BookDownloadProgress> downloadStatuses;
  final BookCategory? selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const BooksState({
    this.status = BooksStatus.initial,
    this.allBooks = const [],
    this.filteredBooks = const [],
    this.downloadStatuses = const {},
    this.selectedCategory,
    this.searchQuery = '',
    this.errorMessage,
  });

  BookDownloadProgress getDownloadStatus(String bookId) {
    return downloadStatuses[bookId] ??
        BookDownloadProgress(
          bookId: bookId,
          status: BookDownloadStatus.notDownloaded,
        );
  }

  BooksState copyWith({
    BooksStatus? status,
    List<BookInfoModel>? allBooks,
    List<BookInfoModel>? filteredBooks,
    Map<String, BookDownloadProgress>? downloadStatuses,
    BookCategory? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BooksState(
      status: status ?? this.status,
      allBooks: allBooks ?? this.allBooks,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      downloadStatuses: downloadStatuses ?? this.downloadStatuses,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        allBooks,
        filteredBooks,
        downloadStatuses,
        selectedCategory,
        searchQuery,
        errorMessage,
      ];
}

