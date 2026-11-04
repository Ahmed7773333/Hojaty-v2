import 'package:equatable/equatable.dart';
import '../../data/models/book_download_state.dart';
import '../../data/models/book_info_model.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooksEvent extends BooksEvent {
  const LoadBooksEvent();
}

class FilterBooksByCategoryEvent extends BooksEvent {
  final BookCategory? category;

  const FilterBooksByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchBooksEvent extends BooksEvent {
  final String query;

  const SearchBooksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class DownloadBookEvent extends BooksEvent {
  final BookInfoModel book;

  const DownloadBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}

class BookDownloadProgressUpdatedEvent extends BooksEvent {
  final BookDownloadProgress progress;

  const BookDownloadProgressUpdatedEvent(this.progress);

  @override
  List<Object?> get props => [progress];
}

class DeleteBookEvent extends BooksEvent {
  final BookInfoModel book;

  const DeleteBookEvent(this.book);

  @override
  List<Object?> get props => [book];
}

