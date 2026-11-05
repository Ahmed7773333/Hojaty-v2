import '../../../core/di/injector.dart';
import '../data/datasources/quran_local_data_source.dart';
import '../data/repositories/quran_repository_impl.dart';
import '../domain/repositories/quran_repository.dart';
import '../domain/usecases/get_all_last_pages_usecase.dart';
import '../domain/usecases/get_last_read_page_usecase.dart';
import '../domain/usecases/get_quran_pages_usecase.dart';
import '../domain/usecases/get_selected_qirat_usecase.dart';
import '../domain/usecases/save_last_read_page_usecase.dart';
import '../domain/usecases/save_selected_qirat_usecase.dart';
import '../presentation/bloc/quran_bloc.dart';

Future<void> initQuranInjector() async {
  // Data Source
  injector.registerLazySingleton<QuranLocalDataSource>(
    () => const QuranLocalDataSource(),
  );

  // Repository
  injector.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(localDataSource: injector()),
  );

  // UseCases
  injector.registerLazySingleton(
    () => GetQuranPagesUseCase(injector()),
  );
  injector.registerLazySingleton(
    () => GetLastReadPageUseCase(injector()),
  );
  injector.registerLazySingleton(
    () => GetAllLastPagesUseCase(injector()),
  );
  injector.registerLazySingleton(
    () => SaveLastReadPageUseCase(injector()),
  );
  injector.registerLazySingleton(
    () => GetSelectedQiratUseCase(injector()),
  );
  injector.registerLazySingleton(
    () => SaveSelectedQiratUseCase(injector()),
  );

  // BLoC
  injector.registerLazySingleton(
    () => QuranBloc(
      getQuranPagesUseCase: injector(),
      getLastReadPageUseCase: injector(),
      getAllLastPagesUseCase: injector(),
      saveLastReadPageUseCase: injector(),
      getSelectedQiratUseCase: injector(),
      saveSelectedQiratUseCase: injector(),
    ),
  );
}
