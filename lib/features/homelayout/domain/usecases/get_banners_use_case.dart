import 'package:hojaty/features/homelayout/data/models/banner_model.dart';
import 'package:hojaty/features/homelayout/domain/repositories/app_content_repository.dart';

class GetBannersUseCase {
  final AppContentRepository repository;

  GetBannersUseCase(this.repository);

  Future<List<BannerModel>> call({required String language}) {
    return repository.getBanners(language: language);
  }
}
