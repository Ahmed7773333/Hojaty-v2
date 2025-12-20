import '../../../core/di/injector.dart';
import '../data/datasources/local/radio_local_data_source_impl.dart';
import '../data/datasources/remote/radio_remote_data_source_impl.dart';
import '../data/repositories/radio_repository_impl.dart';
import '../domain/repositories/radio_repository.dart';
import '../domain/usecases/get_radio.dart';
import '../presentation/bloc/radio_bloc.dart';
import '../../radio/domain/datasources/radio_local_data_source.dart' as local_ds;
import '../../radio/domain/datasources/radio_remote_data_source.dart' as remote_ds;

Future<void> initRadioInjector() async {
  // BLoC
  injector.registerFactory(() => RadioBloc(
        getRadio: injector(),
      ));

  // UseCases
  injector.registerLazySingleton(() => GetRadioUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<RadioRepository>(() => RadioRepositoryImpl(
        remote: injector(),
        local: injector(),
      ));

  // DataSources
  // Register implementations for the interfaces
  injector.registerLazySingleton<remote_ds.RadioRemoteDataSource>(
      () => RadioRemoteDataSourceImpl());
  injector.registerLazySingleton<local_ds.RadioLocalDataSource>(
      () => RadioLocalDataSourceImpl());
}
