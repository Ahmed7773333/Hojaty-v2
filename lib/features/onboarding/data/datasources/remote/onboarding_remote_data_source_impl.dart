import '../../../domain/datasources/onboarding_remote_data_source.dart';
import '../../models/onboardingmodel.dart';

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  // final ApiConsumer apiConsumer;
  // OnboardingRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OnboardingModel> fetch() async {
    // final response = await apiConsumer.get('/onboarding');
    // return OnboardingModel.fromJson(response);
    await Future.delayed(const Duration(milliseconds: 300));
    return OnboardingModel.fake();
  }
}
