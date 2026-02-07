import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hojaty/features/home/di/home_injector.dart';
import 'package:hojaty/features/prayers/di/prayers_injector.dart';

import '../../features/quraan/di/quraan_injector.dart';
import 'package:hojaty/features/radio/di/radio_injector.dart';
import 'package:hojaty/features/settings/di/settings_injector.dart';
import '../network/api_consumer.dart';
import '../network/dio_client.dart';
import 'package:audio_service/audio_service.dart';
import '../services/audio_player_handler.dart';
import '../services/json_data_service.dart';

final injector = GetIt.instance;

Future<void> setupInjector() async {
  // External
  injector.registerSingleton<Dio>(Dio());
  injector.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(),
  );

  // Audio Handler - Lazy initialization for faster startup
  // Audio service is only initialized when first accessed (e.g., opening audio player)
  injector.registerSingletonAsync<AudioHandler>(() async {
    return await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.wolfdev.hojaty.channel.audio',
        androidNotificationChannelName: 'Hojaty Audio',
        androidNotificationOngoing: true,
        androidNotificationIcon: 'mipmap/launcher_icon',
      ),
    );
  });
  // Also register concrete type for easier access to custom methods if needed,
  // though casting AudioHandler is safer pattern, but here we registered the instance.

  // Repositories
  // injector.registerLazySingleton<QuraanRepository>(() => QuraanRepository());

  // BLoCs
  // injector.registerFactory(() => QuraanBloc(injector()));

  // Core
  injector.registerSingleton<ApiConsumer>(DioClient(injector<Dio>()));
  injector.registerSingleton<JsonDataService>(JsonDataService());
  initHomeInjector();
  initPrayersInjector();
  initRadioInjector();
  initSettingsInjector();
  initQuraanInjector(); // Replaced by manual registration above

  // Features
  // await initAuthInjector();
  // await initHomeInjector();
  // ... add other feature injectors
}
