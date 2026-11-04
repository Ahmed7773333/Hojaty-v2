import '../../data/models/onboardingmodel.dart';

abstract class OnboardingRemoteDataSource {
  Future<OnboardingModel> fetch();
}
