import '../../../core/di/injector.dart';
import '../data/datasources/local/settings_local_data_source.dart';
import '../data/datasources/remote/settings_remote_data_source.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/usecases/get_settings.dart';
import '../presentation/bloc/settings_bloc.dart';

Future<void> initSettingsInjector() async {
  // BLoC
  injector.registerFactory(() => SettingsBloc(
        getSettings: injector(),
      ));

  // UseCases
  injector.registerLazySingleton(() => GetSettingsUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(
        remote: injector(),
        local: injector(),
      ));

  // DataSources
  // Note: Registering as RemoteDataSourceImpl/LocalDataSourceImpl
  // If they required dependencies (like ApiConsumer), they would be passed here.
  injector.registerLazySingleton<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSource());
  injector.registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSource());
}
