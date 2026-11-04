import 'package:dio/dio.dart';
import '../../../domain/datasources/occasions_remote_data_source.dart';
import '../../models/ramadan_check_response_model.dart';

class OccasionsRemoteDataSourceImpl implements OccasionsRemoteDataSource {
  final Dio dio;

  OccasionsRemoteDataSourceImpl({required this.dio});

  @override
  Future<RamadanCheckResponseModel> fetchRamadanCheck({
    required String language,
  }) async {
    try {
      final response = await dio.get(
        'https://ramadan.munafio.com/api/check',
        options: Options(
          headers: {
            'Accept-Language': language,
            'accept': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return RamadanCheckResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return RamadanCheckResponseModel.fallback(language: language);
    } catch (_) {
      rethrow;
    }
  }
}
