import 'package:dio/dio.dart';
import '../../models/reciter_model.dart';
import 'radio_remote_data_source.dart';

class RadioRemoteDataSourceImpl implements RadioRemoteDataSource {
  final Dio dio;

  const RadioRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ReciterModel>> getReciters({required String language}) async {
    try {
      final response = await dio.get(
        'https://mp3quran.net/api/v3/reciters',
        queryParameters: {'language': language},
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final list = response.data['reciters'] as List<dynamic>?;
        if (list != null) {
          return list
              .map((e) => ReciterModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return const [];
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch reciters: $e');
    }
  }
}

