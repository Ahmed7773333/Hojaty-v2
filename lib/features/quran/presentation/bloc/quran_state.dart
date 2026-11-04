import 'package:equatable/equatable.dart';
import '../../data/models/page_data_model.dart';
import '../../data/models/quran_search_result_model.dart';
import '../../domain/entities/qirat_type.dart';

enum QuranStatus { initial, loading, loaded, error }

enum QuranAssetStatus {
  checking,
  downloaded,
  requiresDownload,
  downloading,
  failed,
}

class QuranState extends Equatable {
  final QuranStatus status;
  final String? errorMessage;
  final Map<int, PageDataModel> quranPages;
  final int currentPage;
  final bool isOverlayVisible;
  final List<QuranSearchResultModel> searchResults;
  final QiratType selectedQirat;
  final QuranAssetStatus assetStatus;
  final String? assetsPath;
  final int bytesDownloaded;
  final int totalBytes;
  final double downloadProgress;
  final Map<QiratType, QuranAssetStatus> qiratStatuses;
  final Map<QiratType, double> qiratProgress;

  const QuranState({
    this.status = QuranStatus.initial,
    this.errorMessage,
    this.quranPages = const {},
    this.currentPage = 1,
    this.isOverlayVisible = true,
    this.searchResults = const [],
    this.selectedQirat = QiratType.hafs,
    this.assetStatus = QuranAssetStatus.checking,
    this.assetsPath,
    this.bytesDownloaded = 0,
    this.totalBytes = 0,
    this.downloadProgress = 0.0,
    this.qiratStatuses = const {},
    this.qiratProgress = const {},
  });

  QuranState copyWith({
    QuranStatus? status,
    String? errorMessage,
    Map<int, PageDataModel>? quranPages,
    int? currentPage,
    bool? isOverlayVisible,
    List<QuranSearchResultModel>? searchResults,
    QiratType? selectedQirat,
    QuranAssetStatus? assetStatus,
    String? assetsPath,
    int? bytesDownloaded,
    int? totalBytes,
    double? downloadProgress,
    Map<QiratType, QuranAssetStatus>? qiratStatuses,
    Map<QiratType, double>? qiratProgress,
    bool clearError = false,
  }) {
    return QuranState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      quranPages: quranPages ?? this.quranPages,
      currentPage: currentPage ?? this.currentPage,
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
      searchResults: searchResults ?? this.searchResults,
      selectedQirat: selectedQirat ?? this.selectedQirat,
      assetStatus: assetStatus ?? this.assetStatus,
      assetsPath: assetsPath ?? this.assetsPath,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      qiratStatuses: qiratStatuses ?? this.qiratStatuses,
      qiratProgress: qiratProgress ?? this.qiratProgress,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        quranPages,
        currentPage,
        isOverlayVisible,
        searchResults,
        selectedQirat,
        assetStatus,
        assetsPath,
        bytesDownloaded,
        totalBytes,
        downloadProgress,
        qiratStatuses,
        qiratProgress,
      ];
}
