import 'package:equatable/equatable.dart';
import '../../data/models/quraan_page_model.dart';

enum QuraanStatus { initial, loading, loaded, error }

class QuraanState extends Equatable {
  final QuraanStatus status;
  final String? message;
  final Map<int, QuraanPageModel> quranPages;
  final int currentPage;
  final bool isOverlayVisible;

  const QuraanState({
    this.status = QuraanStatus.initial,
    this.message,
    this.quranPages = const {},
    this.currentPage = 1,
    this.isOverlayVisible = true,
  });

  QuraanState copyWith({
    QuraanStatus? status,
    String? message,
    Map<int, QuraanPageModel>? quranPages,
    int? currentPage,
    bool? isOverlayVisible,
  }) {
    return QuraanState(
      status: status ?? this.status,
      message: message ?? this.message,
      quranPages: quranPages ?? this.quranPages,
      currentPage: currentPage ?? this.currentPage,
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    quranPages,
    currentPage,
    isOverlayVisible,
  ];
}
