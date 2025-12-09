import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_consumer.dart';
import '../network/dio_client.dart';

final injector = GetIt.instance;

Future<void> setupInjector() async {
  // External
  injector.registerSingleton<Dio>(Dio());
  injector.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // Core
  injector.registerSingleton<ApiConsumer>(DioClient(injector<Dio>()));

  // Features
  // await initAuthInjector();
  // await initHomeInjector();
  // ... add other feature injectors
}
