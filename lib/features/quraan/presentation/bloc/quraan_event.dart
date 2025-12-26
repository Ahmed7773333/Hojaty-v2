import 'package:equatable/equatable.dart';

abstract class QuraanEvent extends Equatable {
  const QuraanEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuraanData extends QuraanEvent {}

class ToggleOverlay extends QuraanEvent {}

class JumpToPage extends QuraanEvent {
  final int pageNumber;
  const JumpToPage(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

class PageChanged extends QuraanEvent {
  final int pageNumber;
  const PageChanged(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

class SearchQuraan extends QuraanEvent {
  final String query;
  const SearchQuraan(this.query);

  @override
  List<Object?> get props => [query];
}
