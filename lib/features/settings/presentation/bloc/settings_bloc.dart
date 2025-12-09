import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettings;

  SettingsBloc({required this.getSettings})
      : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
      LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      // final result = await getSettings();
      // result.fold(
      //   (failure) => emit(state.copyWith(
      //       status: SettingsStatus.error, message: failure.message)),
      //   (entity) => emit(state.copyWith(
      //       status: SettingsStatus.loaded, entity: entity)),
      // );
      
      await getSettings(); // simple version
      emit(state.copyWith(status: SettingsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.error, message: e.toString()));
    }
  }
}
