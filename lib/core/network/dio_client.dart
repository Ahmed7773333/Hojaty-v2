import 'package:dio/dio.dart';
import 'api_consumer.dart';
import '../error/exceptions.dart';
import '../constants/app_constants.dart';

class DioClient implements ApiConsumer {
  final Dio dio;

  DioClient(this.dio) {
    dio.options
      ..baseUrl = AppConstants.baseUrl
      ..responseType = ResponseType.json
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30);
    
    // Add interceptors for logging, auth, etc.
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> delete(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.delete(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw NetworkException(message: 'Network error, please check your connection.');
    }

    if (e.type == DioExceptionType.badResponse) {
      final message = e.response?.data?['message'] ?? 'Server error';
      throw ServerException(message: message);
    }

    throw ServerException(message: e.message ?? 'An unknown error occurred.');
  }
}
