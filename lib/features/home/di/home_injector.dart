import '../../../core/di/injector.dart';
import '../data/datasources/local/home_local_data_source.dart';
import '../data/datasources/remote/home_remote_data_source.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_home.dart';
import '../presentation/bloc/home_bloc.dart';

Future<void> initHomeInjector() async {
  // BLoC
  injector.registerFactory(() => HomeBloc(
        getHome: injector(),
      ));

  // UseCases
  injector.registerLazySingleton(() => GetHomeUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        remote: injector(),
        local: injector(),
      ));

  // DataSources
  // Note: Registering as RemoteDataSourceImpl/LocalDataSourceImpl
  // If they required dependencies (like ApiConsumer), they would be passed here.
  injector.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSource());
  injector.registerLazySingleton<HomeLocalDataSource>(
      () => HomeLocalDataSource());
}
