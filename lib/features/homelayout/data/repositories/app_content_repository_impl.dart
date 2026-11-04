import 'package:hojaty/features/homelayout/data/models/app_content_model.dart';
import 'package:hojaty/features/homelayout/data/models/banner_model.dart';
import 'package:hojaty/features/homelayout/domain/repositories/app_content_repository.dart';

import '../../domain/datasources/app_content_remote_data_source.dart';

class AppContentRepositoryImpl implements AppContentRepository {
  final AppContentRemoteDataSource remote;

  AppContentRepositoryImpl({required this.remote});

  @override
  Future<AppContentModel> getPrivacyPolicy({required String language}) {
    return remote.fetchPrivacyPolicy(language: language);
  }

  @override
  Future<AppContentModel> getTermsAndConditions({required String language}) {
    return remote.fetchTermsAndConditions(language: language);
  }

  @override
  Future<List<BannerModel>> getBanners({required String language}) {
    return remote.fetchBanners(language: language);
  }
}
