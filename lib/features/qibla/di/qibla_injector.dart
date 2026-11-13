import '../../../core/di/injector.dart';
import '../data/services/qibla_sensor_service.dart';
import '../presentation/bloc/qibla_bloc.dart';

Future<void> initQiblaInjector() async {
  injector.registerLazySingleton<QiblaSensorService>(
    () => QiblaSensorServiceImpl(),
  );

  injector.registerFactory<QiblaBloc>(
    () => QiblaBloc(sensorService: injector()),
  );
}

