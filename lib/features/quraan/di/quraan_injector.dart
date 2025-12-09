import '../../../core/di/injector.dart';
import '../data/datasources/local/quraan_local_data_source.dart';
import '../data/datasources/remote/quraan_remote_data_source.dart';
import '../data/repositories/quraan_repository_impl.dart';
import '../domain/repositories/quraan_repository.dart';
import '../domain/usecases/get_quraan.dart';
import '../presentation/bloc/quraan_bloc.dart';

Future<void> initQuraanInjector() async {
  // BLoC
  injector.registerFactory(() => QuraanBloc(
        getQuraan: injector(),
      ));

  // UseCases
  injector.registerLazySingleton(() => GetQuraanUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<QuraanRepository>(() => QuraanRepositoryImpl(
        remote: injector(),
        local: injector(),
      ));

  // DataSources
  // Note: Registering as RemoteDataSourceImpl/LocalDataSourceImpl
  // If they required dependencies (like ApiConsumer), they would be passed here.
  injector.registerLazySingleton<QuraanRemoteDataSource>(
      () => QuraanRemoteDataSource());
  injector.registerLazySingleton<QuraanLocalDataSource>(
      () => QuraanLocalDataSource());
}
