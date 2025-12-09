import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_quraan.dart';
import 'quraan_event.dart';
import 'quraan_state.dart';

class QuraanBloc extends Bloc<QuraanEvent, QuraanState> {
  final GetQuraanUseCase getQuraan;

  QuraanBloc({required this.getQuraan})
      : super(const QuraanState()) {
    on<LoadQuraanEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
      LoadQuraanEvent event, Emitter<QuraanState> emit) async {
    emit(state.copyWith(status: QuraanStatus.loading));
    try {
      // final result = await getQuraan();
      // result.fold(
      //   (failure) => emit(state.copyWith(
      //       status: QuraanStatus.error, message: failure.message)),
      //   (entity) => emit(state.copyWith(
      //       status: QuraanStatus.loaded, entity: entity)),
      // );
      
      await getQuraan(); // simple version
      emit(state.copyWith(status: QuraanStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: QuraanStatus.error, message: e.toString()));
    }
  }
}
