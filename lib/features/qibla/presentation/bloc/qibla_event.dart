import 'package:equatable/equatable.dart';
import '../../data/models/qibla_compass_data.dart';

abstract class QiblaEvent extends Equatable {
  const QiblaEvent();

  @override
  List<Object?> get props => [];
}

class StartCompassEvent extends QiblaEvent {
  const StartCompassEvent();
}

class CompassRawDataReceivedEvent extends QiblaEvent {
  final CompassRawData data;

  const CompassRawDataReceivedEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class ManualHeadingChangedEvent extends QiblaEvent {
  final double heading;

  const ManualHeadingChangedEvent(this.heading);

  @override
  List<Object?> get props => [heading];
}

class ChangeQiblaCityEvent extends QiblaEvent {
  final String cityName;

  const ChangeQiblaCityEvent(this.cityName);

  @override
  List<Object?> get props => [cityName];
}

class StopCompassEvent extends QiblaEvent {
  const StopCompassEvent();
}

