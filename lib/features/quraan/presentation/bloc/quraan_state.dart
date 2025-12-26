import 'package:equatable/equatable.dart';
import '../../data/models/page_data.dart';
import '../../data/models/search_model.dart';

enum QuraanStatus { initial, loading, loaded, error }

class QuraanState extends Equatable {
  final QuraanStatus status;
  final String? message;
  final Map<int, PageData> quranPages;
  final int currentPage;
  final bool isOverlayVisible;
  final List<SearchModel> searchResults;

  const QuraanState({
    this.status = QuraanStatus.initial,
    this.message,
    this.quranPages = const {},
    this.currentPage = 1,
    this.isOverlayVisible = true,
    this.searchResults = const [],
  });

  QuraanState copyWith({
    QuraanStatus? status,
    String? message,
    Map<int, PageData>? quranPages,
    int? currentPage,
    bool? isOverlayVisible,
    List<SearchModel>? searchResults,
  }) {
    return QuraanState(
      status: status ?? this.status,
      message: message ?? this.message,
      quranPages: quranPages ?? this.quranPages,
      currentPage: currentPage ?? this.currentPage,
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    quranPages,
    currentPage,
    isOverlayVisible,
    searchResults,
  ];
}
