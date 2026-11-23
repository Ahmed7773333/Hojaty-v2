import 'package:hojaty/features/onboarding/domain/datasources/onboarding_local_data_source.dart';
import 'package:hojaty/features/onboarding/data/models/onboardingmodel.dart';

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
