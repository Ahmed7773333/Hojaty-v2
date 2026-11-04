import '../../data/models/banner_model.dart';
import '../repositories/app_content_repository.dart';

class GetBannersUseCase {
  final AppContentRepository repository;

  GetBannersUseCase(this.repository);

  Future<List<BannerModel>> call({required String language}) {
    return repository.getBanners(language: language);
  }
}
