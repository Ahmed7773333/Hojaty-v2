import '../../data/models/app_content_model.dart';
import '../../data/models/banner_model.dart';

abstract class AppContentRepository {
  Future<AppContentModel> getPrivacyPolicy({required String language});
  Future<AppContentModel> getTermsAndConditions({required String language});
  Future<List<BannerModel>> getBanners({required String language});
}
