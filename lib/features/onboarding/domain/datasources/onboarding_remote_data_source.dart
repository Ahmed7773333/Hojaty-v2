import 'package:hojaty/features/onboarding/data/models/onboardingmodel.dart';

abstract class OnboardingRemoteDataSource {
  Future<OnboardingModel> fetch();
}
