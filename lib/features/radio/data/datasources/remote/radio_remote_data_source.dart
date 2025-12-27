import 'package:dio/dio.dart';
import '../../models/readers_response.dart';

abstract class RadioRemoteDataSource {
  Future<ReadersResponseModel> getReciters({required String language});
}

class RadioRemoteDataSourceImpl implements RadioRemoteDataSource {
  final Dio dio;

  RadioRemoteDataSourceImpl({required this.dio});

  @override
  Future<ReadersResponseModel> getReciters({required String language}) async {
    try {
      final response = await dio.get(
        'https://mp3quran.net/api/v3/reciters',
        queryParameters: {'language': language},
      );

      // The API returns { "reciters": [...] }
      if (response.data is Map<String, dynamic>) {
        return ReadersResponseModel.fromJson(response.data);
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      rethrow;
    }
  }
}
