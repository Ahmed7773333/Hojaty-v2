import '../../../core/di/injector.dart';
import '../data/datasources/local/prayers_local_data_source.dart';
import '../data/datasources/remote/prayers_remote_data_source.dart';
import '../data/repositories/prayers_repository_impl.dart';
import '../domain/repositories/prayers_repository.dart';
import '../domain/usecases/get_prayers.dart';
import '../presentation/bloc/prayers_bloc.dart';

Future<void> initPrayersInjector() async {
  // BLoC
  injector.registerFactory(() => PrayersBloc(
        getPrayers: injector(),
      ));

  // UseCases
  injector.registerLazySingleton(() => GetPrayersUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<PrayersRepository>(() => PrayersRepositoryImpl(
        remote: injector(),
        local: injector(),
      ));

  // DataSources
  // Note: Registering as RemoteDataSourceImpl/LocalDataSourceImpl
  // If they required dependencies (like ApiConsumer), they would be passed here.
  injector.registerLazySingleton<PrayersRemoteDataSource>(
      () => PrayersRemoteDataSource());
  injector.registerLazySingleton<PrayersLocalDataSource>(
      () => PrayersLocalDataSource());
}
