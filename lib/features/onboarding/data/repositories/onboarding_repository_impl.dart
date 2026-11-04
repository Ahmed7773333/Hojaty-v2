import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/datasources/onboarding_remote_data_source.dart';
import '../../domain/datasources/onboarding_local_data_source.dart';
import '../models/onboardingmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remote;
  final OnboardingLocalDataSource local;

  OnboardingRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<OnboardingModel> getOnboarding() async {
    final cached = await local.load();
    if (cached != null) return cached;

    final data = await remote.fetch();
    await local.save(data);
    return data;
  }
}
