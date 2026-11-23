import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/radio/data/datasources/local/radio_local_data_source.dart';
import 'package:hojaty/features/radio/data/datasources/local/radio_local_data_source_impl.dart';
import 'package:hojaty/features/radio/data/datasources/remote/radio_remote_data_source.dart';
import 'package:hojaty/features/radio/data/datasources/remote/radio_remote_data_source_impl.dart';
import 'package:hojaty/features/radio/data/repositories/radio_repository_impl.dart';
import 'package:hojaty/features/radio/domain/repositories/radio_repository.dart';
import 'package:hojaty/features/radio/domain/usecases/get_reciters_usecase.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';
import 'package:hojaty/features/radio/services/radio_download_service.dart';

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

