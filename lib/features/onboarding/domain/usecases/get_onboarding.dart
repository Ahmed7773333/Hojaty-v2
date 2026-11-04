import '../repositories/onboarding_repository.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/onboarding.dart';

class GetOnboardingUseCase {
  final OnboardingRepository repository;

  GetOnboardingUseCase(this.repository);

  Future call() => repository.getOnboarding();
}
