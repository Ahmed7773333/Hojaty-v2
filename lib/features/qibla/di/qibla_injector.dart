import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/qibla/data/services/qibla_sensor_service.dart';
import 'package:hojaty/features/qibla/presentation/bloc/qibla_bloc.dart';

Future<void> initQiblaInjector() async {
  injector.registerLazySingleton<QiblaSensorService>(
    () => QiblaSensorServiceImpl(),
  );

  injector.registerFactory<QiblaBloc>(
    () => QiblaBloc(sensorService: injector()),
  );
}

