import '../../../core/di/injector.dart';
import '../data/datasources/local/onboarding_local_data_source_impl.dart';
import '../data/datasources/remote/onboarding_remote_data_source_impl.dart';
import '../data/repositories/onboarding_repository_impl.dart';
import '../domain/repositories/onboarding_repository.dart';
import '../domain/usecases/get_onboarding.dart';
import '../presentation/bloc/onboarding_bloc.dart';
import '../../onboarding/domain/datasources/onboarding_local_data_source.dart' as local_ds;
import '../../onboarding/domain/datasources/onboarding_remote_data_source.dart' as remote_ds;

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
