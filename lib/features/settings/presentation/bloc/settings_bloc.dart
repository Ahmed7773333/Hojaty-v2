import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_settings.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/notification_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettings;

  SettingsBloc({required this.getSettings}) : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoad);
    on<UpdateThemeEvent>(_onUpdateTheme);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateNotificationSettingsEvent>(_onUpdateNotificationSettings);
    on<RefreshLocationEvent>(_onRefreshLocation);
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

  FutureOr<void> _onUpdateNotificationSettings(
    UpdateNotificationSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.user != null) {
      if (event.showNotifications != null) {
        state.user!.uiShowNotifications = event.showNotifications;
      }
      if (event.isSoundEnabled != null) {
        state.user!.uiIsSoundEnabled = event.isSoundEnabled;
      }
      if (event.isVibrateEnabled != null) {
        state.user!.uiIsVibrateEnabled = event.isVibrateEnabled;
      }

      // Re-schedule notifications based on new settings
      if (state.user!.uiShowNotifications) {
        await NotificationService.schedulePrayerNotifications();
      } else {
        await NotificationService.cancelAll();
      }

      emit(
        state.copyWith(user: state.user, rebuildToggle: !state.rebuildToggle),
      );
    }
  }

  FutureOr<void> _onRefreshLocation(
    RefreshLocationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.user == null) return;

    // Show loading indicator via a temporary state if needed,
    // or just assume UI shows a spinner. For now, we rely on the button spinner.
    // Ideally, we'd emit a loading status for location, but let's keep it simple.

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permission denied
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final coordinates = Coordinates(position.latitude, position.longitude);
      state.user!.uiLastKnownLocation = coordinates;

      // Get City Name
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          state.user!.uiCityName =
              placemarks.first.locality ??
              placemarks.first.subAdministrativeArea ??
              'Unknown';
        }
      } catch (e) {
        // Ignore geocoding errors
      }

      // Refresh prayers based on new location
      await NotificationService.schedulePrayerNotifications();

      emit(
        state.copyWith(user: state.user, rebuildToggle: !state.rebuildToggle),
      );
    } catch (e) {
      // Handle error
    }
  }
}
