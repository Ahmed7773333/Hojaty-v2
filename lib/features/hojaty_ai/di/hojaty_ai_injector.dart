import 'package:dio/dio.dart';
import '../../../core/di/injector.dart';
import '../data/datasources/gemini_key_pool.dart';
import '../data/datasources/rag_database_service.dart';
import '../data/repositories/hojaty_ai_repository.dart';
import '../presentation/bloc/hojaty_ai_cubit.dart';

Future<void> initHojatyAiInjector() async {
  // Services & DataSources
  injector.registerLazySingleton<GeminiKeyPool>(() => GeminiKeyPool());
  injector.registerLazySingleton<RagDatabaseService>(() => RagDatabaseService());

  // Repository
  injector.registerLazySingleton<HojatyAiRepository>(
    () => HojatyAiRepository(
      dio: injector<Dio>(),
      keyPool: injector<GeminiKeyPool>(),
      ragDbService: injector<RagDatabaseService>(),
    ),
  );

  // Cubit / State
  injector.registerFactory<HojatyAiCubit>(
    () => HojatyAiCubit(injector<HojatyAiRepository>()),
  );
}

