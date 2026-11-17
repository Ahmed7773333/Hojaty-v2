import 'package:hojaty/features/onboarding/data/models/onboardingmodel.dart';

abstract class OnboardingLocalDataSource {
  Future<void> save(OnboardingModel model);
  Future<OnboardingModel?> load();
}
