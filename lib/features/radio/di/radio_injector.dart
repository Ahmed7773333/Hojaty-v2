import 'package:dio/dio.dart';
import '../../../core/di/injector.dart';
import '../data/datasources/local/radio_local_data_source.dart';
import '../data/datasources/remote/radio_remote_data_source.dart';
import '../data/repositories/radio_repository_impl.dart';
import '../domain/repositories/radio_repository.dart';
import '../domain/usecases/get_reciters_usecase.dart';
import '../presentation/bloc/radio_bloc.dart';

import '../data/datasources/local/playlists_local_data_source.dart';

Future<void> initRadioInjector() async {
  // BLoC
  injector.registerFactory(
    () => RadioBloc(getReciters: injector(), playlistsDataSource: injector()),
  );

  // UseCases
  injector.registerLazySingleton(() => GetRecitersUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<RadioRepository>(
    () => RadioRepositoryImpl(
      remoteDataSource: injector(),
      localDataSource: injector(),
    ),
  );

  // DataSources
  injector.registerLazySingleton<RadioRemoteDataSource>(
    () => RadioRemoteDataSourceImpl(dio: injector<Dio>()),
  );
  injector.registerLazySingleton<RadioLocalDataSource>(
    () => RadioLocalDataSourceImpl(),
  );
  injector.registerLazySingleton<PlaylistsLocalDataSource>(
    () => PlaylistsLocalDataSource(),
  );
}
