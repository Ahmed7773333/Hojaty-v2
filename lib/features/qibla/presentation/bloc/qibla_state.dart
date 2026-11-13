import 'package:equatable/equatable.dart';

enum QiblaStatus { initial, loading, success, failure }

class QiblaState extends Equatable {
  final QiblaStatus status;
  final double heading;
  final double smoothHeading;
  final double pitch;
  final double roll;
  final int accuracy;
  final double qiblaBearing;
  final double distanceKm;
  final String cityName;
  final bool hasSensor;
  final bool isLevel;
  final bool isAligned;
  final bool isClose;
  final double offsetToQibla;
  final String? errorMessage;

  const QiblaState({
    this.status = QiblaStatus.initial,
    this.heading = 0.0,
    this.smoothHeading = 0.0,
    this.pitch = 0.0,
    this.roll = 0.0,
    this.accuracy = 3,
    this.qiblaBearing = 136.14,
    this.distanceKm = 1288.0,
    this.cityName = 'القاهرة، مصر',
    this.hasSensor = true,
    this.isLevel = true,
    this.isAligned = false,
    this.isClose = false,
    this.offsetToQibla = 136.14,
    this.errorMessage,
  });

  QiblaState copyWith({
    QiblaStatus? status,
    double? heading,
    double? smoothHeading,
    double? pitch,
    double? roll,
    int? accuracy,
    double? qiblaBearing,
    double? distanceKm,
    String? cityName,
    bool? hasSensor,
    bool? isLevel,
    bool? isAligned,
    bool? isClose,
    double? offsetToQibla,
    String? errorMessage,
    bool clearError = false,
  }) {
    return QiblaState(
      status: status ?? this.status,
      heading: heading ?? this.heading,
      smoothHeading: smoothHeading ?? this.smoothHeading,
      pitch: pitch ?? this.pitch,
      roll: roll ?? this.roll,
      accuracy: accuracy ?? this.accuracy,
      qiblaBearing: qiblaBearing ?? this.qiblaBearing,
      distanceKm: distanceKm ?? this.distanceKm,
      cityName: cityName ?? this.cityName,
      hasSensor: hasSensor ?? this.hasSensor,
      isLevel: isLevel ?? this.isLevel,
      isAligned: isAligned ?? this.isAligned,
      isClose: isClose ?? this.isClose,
      offsetToQibla: offsetToQibla ?? this.offsetToQibla,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        heading,
        smoothHeading,
        pitch,
        roll,
        accuracy,
        qiblaBearing,
        distanceKm,
        cityName,
        hasSensor,
        isLevel,
        isAligned,
        isClose,
        offsetToQibla,
        errorMessage,
      ];
}

