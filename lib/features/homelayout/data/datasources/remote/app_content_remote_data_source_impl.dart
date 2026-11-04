import 'package:dio/dio.dart';
import '../../../../../core/network/endpoints.dart';
import '../../../domain/datasources/app_content_remote_data_source.dart';
import '../../models/app_content_model.dart';
import '../../models/banner_model.dart';

class AppContentRemoteDataSourceImpl implements AppContentRemoteDataSource {
  final Dio dio;

  AppContentRemoteDataSourceImpl({required this.dio});

  @override
  Future<AppContentModel> fetchPrivacyPolicy({required String language}) async {
    try {
      final response = await dio.get(
        Endpoints.privacyPolicy,
        options: Options(
          headers: {
            'Accept-Language': language,
            'app-lang': language,
            'accept': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return AppContentModel.fromJson(response.data as Map<String, dynamic>);
      }
      return AppContentModel.fallbackPrivacyPolicy(language: language);
    } catch (_) {
      return AppContentModel.fallbackPrivacyPolicy(language: language);
    }
  }

  @override
  Future<AppContentModel> fetchTermsAndConditions({required String language}) async {
    try {
      final response = await dio.get(
        Endpoints.termsAndConditions,
        options: Options(
          headers: {
            'Accept-Language': language,
            'app-lang': language,
            'accept': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return AppContentModel.fromJson(response.data as Map<String, dynamic>);
      }
      return AppContentModel.fallbackTermsAndConditions(language: language);
    } catch (_) {
      return AppContentModel.fallbackTermsAndConditions(language: language);
    }
  }

  @override
  Future<List<BannerModel>> fetchBanners({required String language}) async {
    try {
      final response = await dio.get(
        Endpoints.banners,
        options: Options(
          headers: {
            'Accept-Language': language,
            'app-lang': language,
            'accept': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is List) {
          return data
              .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } else if (response.data is List) {
        return (response.data as List)
            .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }
}

