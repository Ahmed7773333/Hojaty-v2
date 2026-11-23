import 'package:hojaty/features/homelayout/data/models/app_content_model.dart';
import 'package:hojaty/features/homelayout/data/models/banner_model.dart';

abstract class AppContentRemoteDataSource {
  Future<AppContentModel> fetchPrivacyPolicy({required String language});
  Future<AppContentModel> fetchTermsAndConditions({required String language});
  Future<List<BannerModel>> fetchBanners({required String language});
}
