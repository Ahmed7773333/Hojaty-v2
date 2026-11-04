// fake model for Onboarding
class OnboardingModel {
  final String id;
  final String title;

  OnboardingModel({required this.id, required this.title});

  factory OnboardingModel.fake() {
    return OnboardingModel(id: '1', title: 'Fake Onboarding');
  }
}
