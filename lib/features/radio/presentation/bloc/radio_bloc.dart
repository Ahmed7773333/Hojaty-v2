import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_radio.dart';
import 'radio_event.dart';
import 'radio_state.dart';

class RadioBloc extends Bloc<RadioEvent, RadioState> {
  final GetRadioUseCase getRadio;

  RadioBloc({required this.getRadio})
      : super(const RadioState()) {
    on<LoadRadioEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
      LoadRadioEvent event, Emitter<RadioState> emit) async {
    emit(state.copyWith(status: RadioStatus.loading));
    try {
      await getRadio(); // simple version
      emit(state.copyWith(status: RadioStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: RadioStatus.error, message: e.toString()));
    }
  }
}
