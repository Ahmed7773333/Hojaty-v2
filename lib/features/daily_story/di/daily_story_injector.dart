import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/daily_story/data/datasources/daily_story_local_data_source.dart';
import 'package:hojaty/features/daily_story/data/repositories/daily_story_repository_impl.dart';
import 'package:hojaty/features/daily_story/data/services/daily_story_share_service.dart';
import 'package:hojaty/features/daily_story/domain/repositories/daily_story_repository.dart';
import 'package:hojaty/features/daily_story/domain/usecases/get_daily_stories_use_case.dart';
import 'package:hojaty/features/daily_story/domain/usecases/select_daily_story_use_case.dart';
import 'package:hojaty/features/daily_story/domain/usecases/story_palette_use_case.dart';
import 'package:hojaty/features/daily_story/presentation/bloc/daily_story_bloc.dart';

Future<void> initDailyStoryInjector() async {
  // DataSources & Services
  injector.registerLazySingleton<DailyStoryLocalDataSource>(
    () => const DailyStoryLocalDataSource(),
  );
  injector.registerLazySingleton<DailyStoryShareService>(
    () => const DailyStoryShareService(),
  );

  // Repositories
  injector.registerLazySingleton<DailyStoryRepository>(
    () => DailyStoryRepositoryImpl(local: injector()),
  );

  // UseCases
  injector.registerLazySingleton(() => GetDailyStoriesUseCase(injector()));
  injector.registerLazySingleton(() => SelectDailyStoryUseCase(injector()));
  injector.registerLazySingleton(() => StoryPaletteUseCase(injector()));

  // BLoC
  injector.registerFactory<DailyStoryBloc>(
    () => DailyStoryBloc(
      getStories: injector(),
      selectStory: injector(),
      palette: injector(),
    ),
  );
}

