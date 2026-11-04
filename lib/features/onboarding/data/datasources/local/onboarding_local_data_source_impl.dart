import '../../../domain/datasources/onboarding_local_data_source.dart';
import '../../models/onboardingmodel.dart';

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  // final FlutterSecureStorage storage;
  // OnboardingLocalDataSourceImpl({required this.storage});
  
  OnboardingModel? _cache;

  @override
  Future<void> save(OnboardingModel model) async {
    _cache = model;
  }

  @override
  Future<OnboardingModel?> load() async {
    return _cache;
  }
}
