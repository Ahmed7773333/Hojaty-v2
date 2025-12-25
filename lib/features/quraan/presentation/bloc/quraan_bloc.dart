import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/quraan_repository.dart';
import 'quraan_event.dart';
import 'quraan_state.dart';

class QuraanBloc extends Bloc<QuraanEvent, QuraanState> {
  final QuraanRepository repository;

  QuraanBloc(this.repository) : super(const QuraanState()) {
    on<LoadQuraanData>(_onLoadData);
    on<ToggleOverlay>(_onToggleOverlay);
    on<JumpToPage>(_onJumpToPage);
    on<PageChanged>(_onPageChanged);
  }

  Future<void> _onLoadData(
    LoadQuraanData event,
    Emitter<QuraanState> emit,
  ) async {
    emit(state.copyWith(status: QuraanStatus.loading));
    try {
      // Load data
      final pages = await repository.getQuranPages();
      // Load last saved page
      final lastPage = await repository.getLastPage();

      emit(
        state.copyWith(
          status: QuraanStatus.loaded,
          quranPages: pages,
          currentPage: lastPage,
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
    // We only update if it varies significantly or if needed for something specific.
    // Usually PageView updates this.
    emit(state.copyWith(currentPage: event.pageNumber));
    repository.saveLastPage(event.pageNumber);
  }
}
