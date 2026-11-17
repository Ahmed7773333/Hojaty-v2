import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/onboarding/data/datasources/local/onboarding_local_data_source_impl.dart';
import 'package:hojaty/features/onboarding/data/datasources/remote/onboarding_remote_data_source_impl.dart';
import 'package:hojaty/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:hojaty/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:hojaty/features/onboarding/domain/usecases/get_onboarding.dart';
import 'package:hojaty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:hojaty/features/onboarding/domain/datasources/onboarding_local_data_source.dart' as local_ds;
import 'package:hojaty/features/onboarding/domain/datasources/onboarding_remote_data_source.dart' as remote_ds;

Future<void> initOnboardingInjector() async {
  // BLoC
  injector.registerFactory(() => OnboardingBloc(
        getOnboarding: injector(),
      ));

  // UseCases
  injector.registerLazySingleton(() => GetOnboardingUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(
        remote: injector(),
        local: injector(),
      ));

  // DataSources
  // Register implementations for the interfaces
  injector.registerLazySingleton<remote_ds.OnboardingRemoteDataSource>(
      () => OnboardingRemoteDataSourceImpl());
  injector.registerLazySingleton<local_ds.OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl());
}
