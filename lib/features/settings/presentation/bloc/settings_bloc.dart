import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettings;

  SettingsBloc({required this.getSettings}) : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoad);
    on<UpdateThemeEvent>(_onUpdateTheme);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
  }

  FutureOr<void> _onLoad(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final user = await getSettings();
      emit(state.copyWith(status: SettingsStatus.loaded, user: user));
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.error, message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateTheme(
    UpdateThemeEvent event,
    Emitter<SettingsState> emit,
  ) {
    if (state.user != null) {
      state.user!.uiThemeMode = event.themeMode;
      emit(
        state.copyWith(user: state.user, rebuildToggle: !state.rebuildToggle),
      );
    }
  }

  FutureOr<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) {
    if (state.user != null) {
      state.user!.uiIsEnglish = event.isEnglish;
      emit(
        state.copyWith(user: state.user, rebuildToggle: !state.rebuildToggle),
      );
    }
  }
}
