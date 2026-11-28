import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hojaty/features/books/di/books_injector.dart';
import 'package:hojaty/features/daily_story/di/daily_story_injector.dart';
import 'package:hojaty/features/hifz/di/hifz_injector.dart';
import 'package:hojaty/features/hojaty_ai/di/hojaty_ai_injector.dart';
import 'package:hojaty/features/homelayout/di/homelayout_injector.dart';
import 'package:hojaty/features/onboarding/di/onboarding_injector.dart';
import 'package:hojaty/features/qibla/di/qibla_injector.dart';
import 'package:hojaty/features/quran/di/quran_injector.dart';
import 'package:hojaty/features/radio/di/radio_injector.dart';
import 'package:hojaty/core/network/api_consumer.dart';
import 'package:hojaty/core/network/dio_client.dart';

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
  await initQiblaInjector();
  await initDailyStoryInjector();
  await initHifzInjector();
}
