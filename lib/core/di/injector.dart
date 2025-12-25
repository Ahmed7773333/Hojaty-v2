import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hojaty/features/azkar/di/azkar_injector.dart';
import 'package:hojaty/features/home/di/home_injector.dart';
import 'package:hojaty/features/prayers/di/prayers_injector.dart';
import '../../features/quraan/data/repositories/quraan_repository.dart';

import '../../features/quraan/presentation/bloc/quraan_bloc.dart';
import 'package:hojaty/features/radio/di/radio_injector.dart';
import 'package:hojaty/features/settings/di/settings_injector.dart';
import '../network/api_consumer.dart';
import '../network/dio_client.dart';

final injector = GetIt.instance;

Future<void> setupInjector() async {
  // External
  injector.registerSingleton<Dio>(Dio());
  injector.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(),
  );

  // Repositories
  injector.registerLazySingleton<QuraanRepository>(() => QuraanRepository());

  // BLoCs
  injector.registerFactory(() => QuraanBloc(injector()));

  // Core
  injector.registerSingleton<ApiConsumer>(DioClient(injector<Dio>()));
  initHomeInjector();
  initAzkarInjector();
  initPrayersInjector();
  initRadioInjector();
  initSettingsInjector();
  initSettingsInjector();
  // initQuraanInjector(); // Replaced by manual registration above

  // Features
  // await initAuthInjector();
  // await initHomeInjector();
  // ... add other feature injectors
}
