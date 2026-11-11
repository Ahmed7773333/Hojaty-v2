import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/books/di/books_injector.dart';
import '../../features/hojaty_ai/di/hojaty_ai_injector.dart';
import '../../features/homelayout/di/homelayout_injector.dart';
import '../../features/onboarding/di/onboarding_injector.dart';
import '../../features/quran/di/quran_injector.dart';
import '../../features/radio/di/radio_injector.dart';
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
  await initOnboardingInjector();
  await initHomelayoutInjector();
  await initQuranInjector();
  await initRadioInjector();
  await initBooksInjector();
  await initHojatyAiInjector();
}
