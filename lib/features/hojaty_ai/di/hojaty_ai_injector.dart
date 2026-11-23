import 'package:dio/dio.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/gemini_key_pool.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_chat_history_local_data_source.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/rag_database_service.dart';
import 'package:hojaty/features/hojaty_ai/data/repositories/hojaty_ai_repository.dart';
import 'package:hojaty/features/hojaty_ai/presentation/bloc/hojaty_ai_cubit.dart';

Future<void> initHojatyAiInjector() async {
  // Services & DataSources
  injector.registerLazySingleton<GeminiKeyPool>(() => GeminiKeyPool());
  injector.registerLazySingleton<RagDatabaseService>(() => RagDatabaseService());
  injector.registerLazySingleton<HojatyChatHistoryLocalDataSource>(
    () => HojatyChatHistoryLocalDataSource(),
  );

  // Repository
  injector.registerLazySingleton<HojatyAiRepository>(
    () => HojatyAiRepository(
      dio: Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 10),
        ),
      ),
      keyPool: injector<GeminiKeyPool>(),
      ragDbService: injector<RagDatabaseService>(),
    ),
  );

  // Cubit / State
  injector.registerFactory<HojatyAiCubit>(
    () => HojatyAiCubit(
      injector<HojatyAiRepository>(),
      injector<HojatyChatHistoryLocalDataSource>(),
    ),
  );
}

