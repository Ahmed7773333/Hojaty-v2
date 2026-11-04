import 'package:dio/dio.dart';
import '../../../core/di/injector.dart';
import '../data/datasources/local/homelayout_local_data_source_impl.dart';
import '../data/datasources/local/occasions_local_data_source_impl.dart';
import '../data/datasources/remote/app_content_remote_data_source_impl.dart';
import '../data/datasources/remote/homelayout_remote_data_source_impl.dart';
import '../data/datasources/remote/occasions_remote_data_source_impl.dart';
import '../data/repositories/app_content_repository_impl.dart';
import '../data/repositories/homelayout_repository_impl.dart';
import '../data/repositories/occasions_repository_impl.dart';
import '../domain/datasources/app_content_remote_data_source.dart';
import '../domain/datasources/occasions_local_data_source.dart';
import '../domain/datasources/occasions_remote_data_source.dart';
import '../domain/repositories/app_content_repository.dart';
import '../domain/repositories/homelayout_repository.dart';
import '../domain/repositories/occasions_repository.dart';
import '../domain/usecases/get_banners_use_case.dart';
import '../domain/usecases/get_homelayout.dart';
import '../domain/usecases/get_privacy_policy_use_case.dart';
import '../domain/usecases/get_terms_and_conditions_use_case.dart';
import '../domain/usecases/occasions_use_cases.dart';
import '../presentation/bloc/homelayout_bloc.dart';
import '../../homelayout/domain/datasources/homelayout_local_data_source.dart'
    as local_ds;
import '../../homelayout/domain/datasources/homelayout_remote_data_source.dart'
    as remote_ds;

Future<void> initHomelayoutInjector() async {
  // BLoC
  injector.registerFactory(
    () => HomelayoutBloc(
      getHomelayout: injector(),
      getRamadanCheck: injector(),
      getOccasionsList: injector(),
      syncOccasionsData: injector(),
      getBanners: injector(),
    ),
  );

  // UseCases
  injector.registerLazySingleton(() => GetHomelayoutUseCase(injector()));
  injector.registerLazySingleton(() => GetRamadanCheckUseCase(injector()));
  injector.registerLazySingleton(() => GetOccasionsListUseCase(injector()));
  injector.registerLazySingleton(() => SyncOccasionsDataUseCase(injector()));
  injector.registerLazySingleton(() => GetPrivacyPolicyUseCase(injector()));
  injector.registerLazySingleton(() => GetTermsAndConditionsUseCase(injector()));
  injector.registerLazySingleton(() => GetBannersUseCase(injector()));

  // Repositories
  injector.registerLazySingleton<HomelayoutRepository>(
    () => HomelayoutRepositoryImpl(
      remote: injector(),
      local: injector(),
    ),
  );
  injector.registerLazySingleton<OccasionsRepository>(
    () => OccasionsRepositoryImpl(
      remote: injector(),
      local: injector(),
    ),
  );
  injector.registerLazySingleton<AppContentRepository>(
    () => AppContentRepositoryImpl(
      remote: injector(),
    ),
  );

  // DataSources
  injector.registerLazySingleton<remote_ds.HomelayoutRemoteDataSource>(
    () => HomelayoutRemoteDataSourceImpl(),
  );
  injector.registerLazySingleton<local_ds.HomelayoutLocalDataSource>(
    () => HomelayoutLocalDataSourceImpl(),
  );

  injector.registerLazySingleton<OccasionsRemoteDataSource>(
    () => OccasionsRemoteDataSourceImpl(dio: injector<Dio>()),
  );
  injector.registerLazySingleton<OccasionsLocalDataSource>(
    () => OccasionsLocalDataSourceImpl(),
  );

  injector.registerLazySingleton<AppContentRemoteDataSource>(
    () => AppContentRemoteDataSourceImpl(dio: injector<Dio>()),
  );
}
