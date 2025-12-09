import '../../../core/di/injector.dart';
import '../data/datasources/local/azkar_local_data_source.dart';
import '../data/datasources/remote/azkar_remote_data_source.dart';
import '../data/repositories/azkar_repository_impl.dart';
import '../domain/repositories/azkar_repository.dart';
import '../domain/usecases/get_azkar.dart';
import '../presentation/bloc/azkar_bloc.dart';

Future<void> initAzkarInjector() async {
  // BLoC
  injector.registerFactory(() => AzkarBloc(
        getAzkar: injector(),
      ));

  // UseCases
  injector.registerLazySingleton(() => GetAzkarUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<AzkarRepository>(() => AzkarRepositoryImpl(
        remote: injector(),
        local: injector(),
      ));

  // DataSources
  // Note: Registering as RemoteDataSourceImpl/LocalDataSourceImpl
  // If they required dependencies (like ApiConsumer), they would be passed here.
  injector.registerLazySingleton<AzkarRemoteDataSource>(
      () => AzkarRemoteDataSource());
  injector.registerLazySingleton<AzkarLocalDataSource>(
      () => AzkarLocalDataSource());
}
