import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/user_hive_helper.dart';
import '../../data/models/qibla_compass_data.dart';
import '../../data/services/qibla_sensor_service.dart';
import 'qibla_event.dart';
import 'qibla_state.dart';

class QiblaBloc extends Bloc<QiblaEvent, QiblaState> {
  final QiblaSensorService sensorService;
  StreamSubscription<CompassRawData>? _sensorSubscription;

  QiblaBloc({required this.sensorService}) : super(const QiblaState()) {
    on<StartCompassEvent>(_onStartCompass);
    on<CompassRawDataReceivedEvent>(_onCompassRawDataReceived);
    on<ManualHeadingChangedEvent>(_onManualHeadingChanged);
    on<ChangeQiblaCityEvent>(_onChangeQiblaCity);
    on<StopCompassEvent>(_onStopCompass);
  }

  Future<void> _onStartCompass(
    StartCompassEvent event,
    Emitter<QiblaState> emit,
  ) async {
    emit(state.copyWith(
      status: QiblaStatus.loading,
      clearError: true,
    ));

    final cachedCity = UserHiveHelper.getCachedPrayerCityName();
    final resolved = QiblaMath.resolveCoordinates(cachedCity);
    final bearing = QiblaMath.calculateBearing(
      lat: resolved.lat,
      lon: resolved.lon,
    );
    final distance = QiblaMath.calculateDistanceKm(
      lat: resolved.lat,
      lon: resolved.lon,
    );

    emit(state.copyWith(
      status: QiblaStatus.success,
      cityName: resolved.name,
      qiblaBearing: bearing,
      distanceKm: distance,
      offsetToQibla: QiblaMath.getAngularDifference(
        currentHeading: state.heading,
        targetBearing: bearing,
      ),
    ));

    await _sensorSubscription?.cancel();
    _sensorSubscription = sensorService.compassStream.listen(
      (data) {
        add(CompassRawDataReceivedEvent(data));
      },
      onError: (_) {
        add(CompassRawDataReceivedEvent(CompassRawData.fallback()));
      },
    );
  }

  void _onCompassRawDataReceived(
    CompassRawDataReceivedEvent event,
    Emitter<QiblaState> emit,
  ) {
    final raw = event.data;
    final targetBearing = state.qiblaBearing;

    final smooth = QiblaMath.smoothAngle(
      current: state.smoothHeading,
      target: raw.heading,
      factor: 0.25,
    );

    final offset = QiblaMath.getAngularDifference(
      currentHeading: raw.heading,
      targetBearing: targetBearing,
    );

    final isLevel = raw.pitch.abs() < 25.0 && raw.roll.abs() < 25.0;
    final isAligned = offset.abs() <= 3.0 && isLevel;
    final isClose = offset.abs() <= 15.0;

    // Haptic feedback trigger when snapping into accurate alignment
    if (isAligned && !state.isAligned) {
      HapticFeedback.mediumImpact();
    }

    emit(state.copyWith(
      status: QiblaStatus.success,
      heading: raw.heading,
      smoothHeading: smooth,
      pitch: raw.pitch,
      roll: raw.roll,
      accuracy: raw.accuracy,
      hasSensor: raw.hasSensor,
      isLevel: isLevel,
      isAligned: isAligned,
      isClose: isClose,
      offsetToQibla: offset,
    ));
  }

  void _onManualHeadingChanged(
    ManualHeadingChangedEvent event,
    Emitter<QiblaState> emit,
  ) {
    final heading = (event.heading % 360.0 + 360.0) % 360.0;
    final targetBearing = state.qiblaBearing;

    final offset = QiblaMath.getAngularDifference(
      currentHeading: heading,
      targetBearing: targetBearing,
    );

    final isAligned = offset.abs() <= 3.0;
    final isClose = offset.abs() <= 15.0;

    if (isAligned && !state.isAligned) {
      HapticFeedback.lightImpact();
    }

    emit(state.copyWith(
      heading: heading,
      smoothHeading: heading,
      offsetToQibla: offset,
      isAligned: isAligned,
      isClose: isClose,
    ));
  }

  void _onChangeQiblaCity(
    ChangeQiblaCityEvent event,
    Emitter<QiblaState> emit,
  ) {
    final resolved = QiblaMath.resolveCoordinates(event.cityName);
    final bearing = QiblaMath.calculateBearing(
      lat: resolved.lat,
      lon: resolved.lon,
    );
    final distance = QiblaMath.calculateDistanceKm(
      lat: resolved.lat,
      lon: resolved.lon,
    );

    final offset = QiblaMath.getAngularDifference(
      currentHeading: state.heading,
      targetBearing: bearing,
    );

    emit(state.copyWith(
      cityName: resolved.name,
      qiblaBearing: bearing,
      distanceKm: distance,
      offsetToQibla: offset,
      isAligned: offset.abs() <= 3.0 && state.isLevel,
      isClose: offset.abs() <= 15.0,
    ));
  }

  Future<void> _onStopCompass(
    StopCompassEvent event,
    Emitter<QiblaState> emit,
  ) async {
    await _sensorSubscription?.cancel();
    _sensorSubscription = null;
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel();
    sensorService.dispose();
    return super.close();
  }
}

