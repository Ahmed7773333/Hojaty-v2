import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_prayers.dart';
import 'prayers_event.dart';
import 'prayers_state.dart';

class PrayersBloc extends Bloc<PrayersEvent, PrayersState> {
  final GetPrayersUseCase getPrayers;

  PrayersBloc({required this.getPrayers})
      : super(const PrayersState()) {
    on<LoadPrayersEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
      LoadPrayersEvent event, Emitter<PrayersState> emit) async {
    emit(state.copyWith(status: PrayersStatus.loading));
    try {
      // final result = await getPrayers();
      // result.fold(
      //   (failure) => emit(state.copyWith(
      //       status: PrayersStatus.error, message: failure.message)),
      //   (entity) => emit(state.copyWith(
      //       status: PrayersStatus.loaded, entity: entity)),
      // );
      
      await getPrayers(); // simple version
      emit(state.copyWith(status: PrayersStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: PrayersStatus.error, message: e.toString()));
    }
  }
}
