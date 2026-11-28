import 'package:dio/dio.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/hifz/data/datasources/audio_cache_manager.dart';
import 'package:hojaty/features/hifz/data/datasources/curated_tracks_loader.dart';
import 'package:hojaty/features/hifz/data/datasources/hifz_local_dao.dart';
import 'package:hojaty/features/hifz/data/datasources/hifz_quran_text_resolver.dart';
import 'package:hojaty/features/hifz/data/repositories/hifz_repository_impl.dart';
import 'package:hojaty/features/hifz/domain/repositories/hifz_repository.dart';
import 'package:hojaty/features/hifz/domain/usecases/calculate_spaced_review.dart';
import 'package:hojaty/features/hifz/domain/usecases/generate_playback_queue.dart';
import 'package:hojaty/features/hifz/engine/hifz_audio_handler.dart';
import 'package:hojaty/features/hifz/engine/hifz_session_orchestrator.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_hub_cubit.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_cubit.dart';
import 'package:hojaty/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:hojaty/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';

Future<void> initHifzInjector() async {
  // Data Sources
  injector.registerLazySingleton<HifzLocalDao>(() => HifzLocalDao());
  injector.registerLazySingleton<CuratedTracksLoader>(
    () => CuratedTracksLoader(),
  );
  injector.registerLazySingleton<HifzQuranTextResolver>(
    () => HifzQuranTextResolver(
      quranBloc: injector<QuranBloc>(),
      quranLocalDataSource: injector<QuranLocalDataSource>(),
    ),
  );
  injector.registerLazySingleton<AudioCacheManager>(
    () => AudioCacheManager(
      dio: injector<Dio>(),
      localDao: injector<HifzLocalDao>(),
    ),
  );

  // Repository
  injector.registerLazySingleton<HifzRepository>(
    () => HifzRepositoryImpl(
      localDao: injector<HifzLocalDao>(),
      curatedTracksLoader: injector<CuratedTracksLoader>(),
    ),
  );

  // UseCases
  injector.registerLazySingleton<GeneratePlaybackQueue>(
    () => const GeneratePlaybackQueue(),
  );
  injector.registerLazySingleton<CalculateSpacedReview>(
    () => const CalculateSpacedReview(),
  );

  // Audio Engine
  injector.registerLazySingleton<HifzAudioHandler>(
    () => HifzAudioHandler(
      radioPlayerService: injector<RadioAudioPlayerService>(),
    ),
  );
  injector.registerLazySingleton<HifzSessionOrchestrator>(
    () => HifzSessionOrchestrator(
      audioHandler: injector<HifzAudioHandler>(),
      cacheManager: injector<AudioCacheManager>(),
    ),
  );

  // Cubits
  injector.registerLazySingleton<HifzHubCubit>(
    () => HifzHubCubit(
      repository: injector<HifzRepository>(),
      cacheManager: injector<AudioCacheManager>(),
      calculateSpacedReview: injector<CalculateSpacedReview>(),
    ),
  );
  injector.registerLazySingleton<HifzSessionCubit>(
    () => HifzSessionCubit(
      repository: injector<HifzRepository>(),
      textResolver: injector<HifzQuranTextResolver>(),
      cacheManager: injector<AudioCacheManager>(),
      generatePlaybackQueue: injector<GeneratePlaybackQueue>(),
      calculateSpacedReview: injector<CalculateSpacedReview>(),
      orchestrator: injector<HifzSessionOrchestrator>(),
    ),
  );
}

