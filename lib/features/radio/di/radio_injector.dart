import '../../../core/di/injector.dart';
import '../data/datasources/local/radio_local_data_source.dart';
import '../data/datasources/local/radio_local_data_source_impl.dart';
import '../data/datasources/remote/radio_remote_data_source.dart';
import '../data/datasources/remote/radio_remote_data_source_impl.dart';
import '../data/repositories/radio_repository_impl.dart';
import '../domain/repositories/radio_repository.dart';
import '../domain/usecases/get_reciters_usecase.dart';
import '../presentation/bloc/radio_bloc.dart';
import '../services/radio_audio_player_service.dart';
import '../services/radio_download_service.dart';

Future<void> initRadioInjector() async {
  // Services
  injector.registerLazySingleton<RadioAudioPlayerService>(
    () => RadioAudioPlayerService(),
  );
  injector.registerLazySingleton<RadioDownloadService>(
    () => RadioDownloadService(injector()),
  );

  // Data Sources
  injector.registerLazySingleton<RadioRemoteDataSource>(
    () => RadioRemoteDataSourceImpl(dio:  injector()),
  );
  injector.registerLazySingleton<RadioLocalDataSource>(
    () => RadioLocalDataSourceImpl(),
  );

  // Repository
  injector.registerLazySingleton<RadioRepository>(
    () => RadioRepositoryImpl(
      remoteDataSource: injector(),
      localDataSource: injector(),
    ),
  );

  // UseCases
  injector.registerLazySingleton(
    () => GetRecitersUseCase(injector()),
  );

  // BLoC
  injector.registerLazySingleton(
    () => RadioBloc(
      getRecitersUseCase: injector(),
      repository: injector(),
    ),
  );
}

