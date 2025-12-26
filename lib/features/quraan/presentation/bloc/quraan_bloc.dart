import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/helper.dart';
import '../../data/models/page_data.dart';
import '../../data/models/search_model.dart';
import '../../domain/repositories/quraan_repository.dart';
import 'quraan_event.dart';
import 'quraan_state.dart';

class QuraanBloc extends Bloc<QuraanEvent, QuraanState> {
  final QuraanRepository repository;

  QuraanBloc(this.repository) : super(const QuraanState()) {
    on<LoadQuraanData>(_onLoadData);
    on<ToggleOverlay>(_onToggleOverlay);
    on<JumpToPage>(_onJumpToPage);
    on<PageChanged>(_onPageChanged);
    on<SearchQuraan>(_onSearchQuraan);
  }

  Future<void> _onLoadData(
    LoadQuraanData event,
    Emitter<QuraanState> emit,
  ) async {
    emit(state.copyWith(status: QuraanStatus.loading));
    try {
      // Load data
      final List<PageData> pagesList = await repository.getQuranPages();

      // Convert to Map for easier access by pageNumber
      final Map<int, PageData> pagesMap = {
        for (var page in pagesList) page.pageNumber ?? 0: page,
      };

      // Load last saved page
      final lastPage = await repository.getLastPage();

      emit(
        state.copyWith(
          status: QuraanStatus.loaded,
          quranPages: pagesMap,
          currentPage: lastPage,
          // Clear search results on load or keep them? Clear seems safe.
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: QuraanStatus.error, message: e.toString()));
    }
  }

  void _onToggleOverlay(ToggleOverlay event, Emitter<QuraanState> emit) {
    emit(state.copyWith(isOverlayVisible: !state.isOverlayVisible));
  }

  void _onJumpToPage(JumpToPage event, Emitter<QuraanState> emit) {
    emit(state.copyWith(currentPage: event.pageNumber));
    repository.saveLastPage(event.pageNumber);
  }

  void _onPageChanged(PageChanged event, Emitter<QuraanState> emit) {
    emit(state.copyWith(currentPage: event.pageNumber));
    repository.saveLastPage(event.pageNumber);
  }

  Future<void> _onSearchQuraan(
    SearchQuraan event,
    Emitter<QuraanState> emit,
  ) async {
    final query = event.query;
    if (query.isEmpty) {
      emit(state.copyWith(searchResults: []));
      return;
    }

    final normalizedQuery = Helper.normalizeArabic(query);
    List<SearchModel> results = [];

    // Iterate through all pages
    for (var page in state.quranPages.values) {
      final verses = page.versesContentEmaly ?? [];
      for (int i = 0; i < verses.length; i++) {
        final verseText = verses[i];
        if (Helper.normalizeArabic(verseText).contains(normalizedQuery)) {
          results.add(
            SearchModel(
              surahNum: page.surahsNumber?[i] ?? 0,
              verseNum: page.versesNumbers?[i] ?? 0,
              surahName:
                  page.surahsNames != null && i < page.surahsNames!.length
                  ? page.surahsNames![i]
                  : (page.surahsNames?.isNotEmpty == true
                        ? page.surahsNames!.last
                        : ''),
              content: page.versesContent?[i] ?? '',
              pageNum: page.pageNumber ?? 0,
              tafseer: page.tafseer?[i] ?? '',
            ),
          );
        }
      }
    }

    emit(state.copyWith(searchResults: results));
  }
}
