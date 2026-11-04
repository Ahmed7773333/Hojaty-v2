import '../../data/models/app_content_model.dart';
import '../repositories/app_content_repository.dart';

class GetTermsAndConditionsUseCase {
  final AppContentRepository repository;

  GetTermsAndConditionsUseCase(this.repository);

  Future<AppContentModel> call({required String language}) {
    return repository.getTermsAndConditions(language: language);
  }
}
