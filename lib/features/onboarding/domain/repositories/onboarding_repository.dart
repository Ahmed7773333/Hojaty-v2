import 'package:hojaty/features/onboarding/data/models/onboardingmodel.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';

abstract class OnboardingRepository {
  // Future<Either<Failure, OnboardingModel>> getOnboarding();
  Future<OnboardingModel> getOnboarding();
}
