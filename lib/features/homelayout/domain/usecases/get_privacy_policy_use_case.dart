import 'package:hojaty/features/homelayout/data/models/app_content_model.dart';
import 'package:hojaty/features/homelayout/domain/repositories/app_content_repository.dart';

class GetPrivacyPolicyUseCase {
  final AppContentRepository repository;

  GetPrivacyPolicyUseCase(this.repository);

  Future<AppContentModel> call({required String language}) {
    return repository.getPrivacyPolicy(language: language);
  }
}
