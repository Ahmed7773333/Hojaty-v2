import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hojaty/features/quran/domain/entities/qirat_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/play_asset_delivery_service.dart';
import '../../constants/quran_text_helper.dart';
import '../../data/models/page_data_model.dart';
import '../../data/models/quran_search_result_model.dart';
import '../../domain/usecases/get_all_last_pages_usecase.dart';
import '../../domain/usecases/get_last_read_page_usecase.dart';
import '../../domain/usecases/get_quran_pages_usecase.dart';
import '../../domain/usecases/get_selected_qirat_usecase.dart';
import '../../domain/usecases/save_last_read_page_usecase.dart';
import '../../domain/usecases/save_selected_qirat_usecase.dart';
import 'quran_event.dart';
import 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final GetQuranPagesUseCase getQuranPagesUseCase;
  final GetLastReadPageUseCase getLastReadPageUseCase;
  final GetAllLastPagesUseCase getAllLastPagesUseCase;
  final SaveLastReadPageUseCase saveLastReadPageUseCase;
  final GetSelectedQiratUseCase getSelectedQiratUseCase;
  final SaveSelectedQiratUseCase saveSelectedQiratUseCase;

  StreamSubscription<AssetPackInfo>? _progressSubscription;

  QuranBloc({
    required this.getQuranPagesUseCase,
    required this.getLastReadPageUseCase,
    required this.getAllLastPagesUseCase,
    required this.saveLastReadPageUseCase,
    required this.getSelectedQiratUseCase,
    required this.saveSelectedQiratUseCase,
  }) : super(const QuranState()) {
    on<LoadQuranDataEvent>(_onLoadQuranData);
    on<ToggleOverlayEvent>(_onToggleOverlay);
    on<JumpToPageEvent>(_onJumpToPage);
    on<PageChangedEvent>(_onPageChanged);
    on<SearchQuranEvent>(_onSearchQuran);
    on<SelectQiratEvent>(_onSelectQirat);
    on<CheckQuranAssetStatusEvent>(_onCheckQuranAssetStatus);
    on<StartDownloadQuranAssetEvent>(_onStartDownloadQuranAsset);
    on<CancelDownloadQuranAssetEvent>(_onCancelDownloadQuranAsset);
    on<AssetDownloadProgressUpdatedEvent>(_onAssetDownloadProgressUpdated);
  }

  Future<void> _onLoadQuranData(
    LoadQuranDataEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(state.copyWith(status: QuranStatus.loading, clearError: true));
    try {
      final pagesList = await getQuranPagesUseCase();
      final selectedQirat = await getSelectedQiratUseCase();
      final allLastPages = await getAllLastPagesUseCase();
      final lastPage = allLastPages[selectedQirat] ?? 1;

      final Map<int, PageDataModel> pagesMap = {
        for (var page in pagesList) page.pageNumber ?? 0: page,
      };

      emit(
        state.copyWith(
          status: QuranStatus.loaded,
          quranPages: pagesMap,
          currentPage: lastPage,
          selectedQirat: selectedQirat,
          qiratLastPages: allLastPages,
        ),
      );
      add(const CheckQuranAssetStatusEvent());
    } catch (e) {
      emit(
        state.copyWith(status: QuranStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _onToggleOverlay(ToggleOverlayEvent event, Emitter<QuranState> emit) {
    emit(state.copyWith(isOverlayVisible: !state.isOverlayVisible));
  }

  Future<void> _onJumpToPage(
    JumpToPageEvent event,
    Emitter<QuranState> emit,
  ) async {
    final updatedLastPages = Map<QiratType, int>.from(state.qiratLastPages);
    updatedLastPages[state.selectedQirat] = event.pageNumber;
    emit(state.copyWith(
      currentPage: event.pageNumber,
      qiratLastPages: updatedLastPages,
    ));
    await saveLastReadPageUseCase(event.pageNumber, qirat: state.selectedQirat);
  }

  Future<void> _onPageChanged(
    PageChangedEvent event,
    Emitter<QuranState> emit,
  ) async {
    final updatedLastPages = Map<QiratType, int>.from(state.qiratLastPages);
    updatedLastPages[state.selectedQirat] = event.pageNumber;
    emit(state.copyWith(
      currentPage: event.pageNumber,
      qiratLastPages: updatedLastPages,
    ));
    await saveLastReadPageUseCase(event.pageNumber, qirat: state.selectedQirat);
  }

  void _onSearchQuran(SearchQuranEvent event, Emitter<QuranState> emit) {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(state.copyWith(searchResults: const []));
      return;
    }

    final normalizedQuery = QuranTextHelper.normalizeArabic(query);
    final List<QuranSearchResultModel> results = [];

    for (final page in state.quranPages.values) {
      final versesEmaly = page.versesContentEmaly ?? [];
      final versesContent = page.versesContent ?? [];
      final versesNumbers = page.versesNumbers ?? [];
      final surahsNames = page.surahsNames ?? [];
      final surahsNumbers = page.surahsNumber ?? [];
      final tafseers = page.tafseer ?? [];

      for (int i = 0; i < versesEmaly.length; i++) {
        final verseEmaly = versesEmaly[i];
        if (QuranTextHelper.normalizeArabic(
          verseEmaly,
        ).contains(normalizedQuery)) {
          final surahName = (i < surahsNames.length)
              ? surahsNames[i]
              : (surahsNames.isNotEmpty ? surahsNames.last : '');
          final verseContent = (i < versesContent.length)
              ? versesContent[i]
              : verseEmaly;
          final verseNum = (i < versesNumbers.length)
              ? versesNumbers[i]
              : (i + 1);
          final surahNum = (i < surahsNumbers.length) ? surahsNumbers[i] : 1;
          final tafseer = (i < tafseers.length) ? tafseers[i] : '';

          results.add(
            QuranSearchResultModel(
              surahNum: surahNum,
              verseNum: verseNum,
              pageNum: page.pageNumber ?? 1,
              surahName: surahName,
              content: verseContent,
              tafseer: tafseer,
            ),
          );
        }
      }
    }

    emit(state.copyWith(searchResults: results));
  }

  Future<void> _onSelectQirat(
    SelectQiratEvent event,
    Emitter<QuranState> emit,
  ) async {
    final lastPage = state.qiratLastPages[event.qirat] ??
        await getLastReadPageUseCase(qirat: event.qirat);
    emit(state.copyWith(
      selectedQirat: event.qirat,
      currentPage: lastPage,
    ));
    await saveSelectedQiratUseCase(event.qirat);
    add(const CheckQuranAssetStatusEvent());
  }

  Future<void> _onCheckQuranAssetStatus(
    CheckQuranAssetStatusEvent event,
    Emitter<QuranState> emit,
  ) async {
    emit(state.copyWith(assetStatus: QuranAssetStatus.checking));

    if (kDebugMode) {
      final Map<QiratType, QuranAssetStatus> statuses = {
        for (final q in QiratType.values) q: QuranAssetStatus.downloaded,
      };
      emit(
        state.copyWith(
          assetStatus: QuranAssetStatus.downloaded,
          assetsPath: null,
          downloadProgress: 1.0,
          qiratStatuses: statuses,
        ),
      );
      return;
    }

    try {
      final Map<QiratType, QuranAssetStatus> statuses = {};
      for (final q in QiratType.values) {
        final info = await PlayAssetDeliveryService.getAssetPackStatus(
          q.assetPackName,
        );
        if (info.isDownloaded && info.assetsPath != null) {
          statuses[q] = QuranAssetStatus.downloaded;
        } else {
          statuses[q] = QuranAssetStatus.requiresDownload;
        }
      }

      final activePackName = state.selectedQirat.assetPackName;
      final activeInfo = await PlayAssetDeliveryService.getAssetPackStatus(
        activePackName,
      );
      if (activeInfo.isDownloaded && activeInfo.assetsPath != null) {
        emit(
          state.copyWith(
            assetStatus: QuranAssetStatus.downloaded,
            assetsPath: activeInfo.assetsPath,
            bytesDownloaded: activeInfo.bytesDownloaded,
            totalBytes: activeInfo.totalBytes,
            downloadProgress: 1.0,
            qiratStatuses: statuses,
          ),
        );
      } else {
        emit(
          state.copyWith(
            assetStatus: QuranAssetStatus.requiresDownload,
            assetsPath: null,
            downloadProgress: 0.0,
            qiratStatuses: statuses,
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          assetStatus: QuranAssetStatus.requiresDownload,
          assetsPath: null,
        ),
      );
    }
  }

  Future<void> _onStartDownloadQuranAsset(
    StartDownloadQuranAssetEvent event,
    Emitter<QuranState> emit,
  ) async {
    if (kDebugMode) {
      final Map<QiratType, QuranAssetStatus> statuses = {
        for (final q in QiratType.values) q: QuranAssetStatus.downloaded,
      };
      emit(
        state.copyWith(
          assetStatus: QuranAssetStatus.downloaded,
          downloadProgress: 1.0,
          qiratStatuses: statuses,
        ),
      );
      return;
    }

    final targetQirat = event.qirat ?? state.selectedQirat;
    final packName = targetQirat.assetPackName;

    final updatedStatuses = Map<QiratType, QuranAssetStatus>.from(
      state.qiratStatuses,
    );
    updatedStatuses[targetQirat] = QuranAssetStatus.downloading;

    final updatedProgress = Map<QiratType, double>.from(state.qiratProgress);
    updatedProgress[targetQirat] = 0.0;

    final isSelected = targetQirat == state.selectedQirat;

    emit(
      state.copyWith(
        assetStatus: isSelected
            ? QuranAssetStatus.downloading
            : state.assetStatus,
        downloadProgress: isSelected ? 0.0 : state.downloadProgress,
        bytesDownloaded: isSelected ? 0 : state.bytesDownloaded,
        qiratStatuses: updatedStatuses,
        qiratProgress: updatedProgress,
        clearError: true,
      ),
    );

    await _progressSubscription?.cancel();
    _progressSubscription = PlayAssetDeliveryService.downloadProgressStream
        .listen((info) {
          add(
            AssetDownloadProgressUpdatedEvent(
              packName: info.packName,
              bytesDownloaded: info.bytesDownloaded,
              totalBytes: info.totalBytes,
              progress: info.progress,
              status: info.status.name,
              assetsPath: info.assetsPath,
              errorCode: info.errorCode,
            ),
          );
        });

    final started = await PlayAssetDeliveryService.startDownload(packName);
    if (!started) {
      updatedStatuses[targetQirat] = QuranAssetStatus.failed;
      emit(
        state.copyWith(
          assetStatus: isSelected ? QuranAssetStatus.failed : state.assetStatus,
          qiratStatuses: updatedStatuses,
          errorMessage: 'Failed to start download',
        ),
      );
    }
  }

  void _onAssetDownloadProgressUpdated(
    AssetDownloadProgressUpdatedEvent event,
    Emitter<QuranState> emit,
  ) {
    final targetQirat =
        QiratType.values
            .where((q) => q.assetPackName == event.packName)
            .firstOrNull ??
        state.selectedQirat;
    final isSelected = targetQirat == state.selectedQirat;

    final updatedStatuses = Map<QiratType, QuranAssetStatus>.from(
      state.qiratStatuses,
    );
    final updatedProgress = Map<QiratType, double>.from(state.qiratProgress);

    if (event.status == 'completed' ||
        (event.assetsPath != null && event.assetsPath!.isNotEmpty)) {
      updatedStatuses[targetQirat] = QuranAssetStatus.downloaded;
      updatedProgress[targetQirat] = 1.0;

      emit(
        state.copyWith(
          assetStatus: isSelected
              ? QuranAssetStatus.downloaded
              : state.assetStatus,
          assetsPath: isSelected ? event.assetsPath : state.assetsPath,
          downloadProgress: isSelected ? 1.0 : state.downloadProgress,
          bytesDownloaded: isSelected
              ? event.totalBytes
              : state.bytesDownloaded,
          totalBytes: isSelected ? event.totalBytes : state.totalBytes,
          qiratStatuses: updatedStatuses,
          qiratProgress: updatedProgress,
        ),
      );
    } else if (event.status == 'failed' ||
        (event.errorCode != null && event.errorCode != 0)) {
      updatedStatuses[targetQirat] = QuranAssetStatus.failed;
      emit(
        state.copyWith(
          assetStatus: isSelected ? QuranAssetStatus.failed : state.assetStatus,
          qiratStatuses: updatedStatuses,
          errorMessage: 'Download failed',
        ),
      );
    } else if (event.status == 'canceled') {
      updatedStatuses[targetQirat] = QuranAssetStatus.requiresDownload;
      updatedProgress[targetQirat] = 0.0;
      emit(
        state.copyWith(
          assetStatus: isSelected
              ? QuranAssetStatus.requiresDownload
              : state.assetStatus,
          downloadProgress: isSelected ? 0.0 : state.downloadProgress,
          qiratStatuses: updatedStatuses,
          qiratProgress: updatedProgress,
        ),
      );
    } else {
      updatedStatuses[targetQirat] = QuranAssetStatus.downloading;
      updatedProgress[targetQirat] = event.progress;
      emit(
        state.copyWith(
          assetStatus: isSelected
              ? QuranAssetStatus.downloading
              : state.assetStatus,
          bytesDownloaded: isSelected
              ? event.bytesDownloaded
              : state.bytesDownloaded,
          totalBytes: isSelected ? event.totalBytes : state.totalBytes,
          downloadProgress: isSelected
              ? event.progress
              : state.downloadProgress,
          qiratStatuses: updatedStatuses,
          qiratProgress: updatedProgress,
        ),
      );
    }
  }

  Future<void> _onCancelDownloadQuranAsset(
    CancelDownloadQuranAssetEvent event,
    Emitter<QuranState> emit,
  ) async {
    final packName = state.selectedQirat.assetPackName;
    await PlayAssetDeliveryService.cancelDownload(packName);
    emit(
      state.copyWith(
        assetStatus: QuranAssetStatus.requiresDownload,
        downloadProgress: 0.0,
      ),
    );
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    return super.close();
  }
}
