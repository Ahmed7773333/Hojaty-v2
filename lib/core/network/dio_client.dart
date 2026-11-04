import 'dart:developer';
import 'package:dio/dio.dart';
import '../../config/routes/app_router.dart';
import '../../main.dart';
import '../utils/extensions/context_extensions.dart';
import '../utils/flutter_secure_storage_helper.dart';
import 'api_consumer.dart';
import '../error/exceptions.dart';
import '../constants/app_constants.dart';
import '../utils/snackbar_helper.dart';
import '../local/user_hive_helper.dart';

class DioClient implements ApiConsumer {
  final Dio dio;

  DioClient(this.dio) {
    dio.options
      ..baseUrl = AppConstants.baseUrl
      ..responseType = ResponseType.json
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..headers = {
        'accept': 'application/json',
        'content-type': 'application/json',
        'app-lang': UserHiveHelper.getUser()?.language ?? 'en',
      };

    // --- ADVANCED LOGGING & AUTH INTERCEPTOR ---
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await FlutterSecureStorageHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            log('🚀 [AUTH] Bearer $token');
          }

          log('🚀 [REQUEST] [${options.method}] URL: ${options.uri}');
          if (options.data != null) {
            if (options.data is Future<FormData> || options.data is FormData) {
              final formData = await options.data as FormData;
              final fields = formData.fields
                  .map((e) => '${e.key}: ${e.value}')
                  .toList();
              final files = formData.files
                  .map((e) => '${e.key}: ${e.value.filename}')
                  .toList();

              log('📦 [FORM DATA FIELDS]: $fields');
              log('📂 [FORM DATA FILES]: $files');
            } else {
              log('📦 [BODY]: ${options.data}');
            }
          }
          if (options.queryParameters.isNotEmpty) {
            log('❓ [QUERY PARAMS]: ${options.queryParameters}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          log(
            '✅ [RESPONSE] [${response.statusCode}] FROM: ${response.requestOptions.path}',
          );
          log('📄 [DATA]: ${response.data}');

          // Show global success snackbar if a valid string 'message' is present
          if (response.data is Map && response.data['message'] != null) {
            final message = response.data['message'];
            if (message is String && message.isNotEmpty) {
              final context = AnaOsalyApp.navigatorKey.currentContext;
              if (context != null && response.requestOptions.method != 'GET') {
                // SnackbarHelper.showSuccess(context, message: message);
              }
            }
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('❌ [ERROR] [${e.response?.statusCode ?? 'NO STATUS'}]');
          log('🔗 PATH: ${e.requestOptions.path}');
          log('⚠️ TYPE: ${e.type}');
          log('💬 MESSAGE: ${e.message}');
          if (e.response?.data != null) {
            log('📥 ERROR DATA: ${e.response?.data}');
          }

          final context = AnaOsalyApp.navigatorKey.currentContext;
          if (context != null) {
            if (e.type == DioExceptionType.badResponse) {
              final statusCode = e.response?.statusCode;
              final String errorMessage = e.response?.data is Map
                  ? (e.response?.data['message'] ??
                        'Server error ($statusCode)')
                  : 'Server error ($statusCode)';
              // SnackbarHelper.showError(context, message: errorMessage);
            } else if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.connectionError) {
              // SnackbarHelper.showError(
              //   context,
              //   message: 'Network error, please check your connection.',
              // );
            } else {
              // SnackbarHelper.showError(
              //   context,
              //   message: e.message ?? 'An unknown error occurred.',
              // );
            }
          }

          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            log(
              '🚫 [AUTH] 401 Unauthorized - Consider triggering logout here.',
            );
            final context = AnaOsalyApp.navigatorKey.currentContext;

            if (context != null) {
              final String location = context.currentRouteName.toString();
              final authRoutes = [
                AppRoutes.login,
                AppRoutes
                    .home, // wait, should authRoutes contain home? Normally not, let's keep it general
              ];

              if (location != AppRoutes.login) {
                log('🚀 Redirecting to Login from $location');
                context.go(AppRoutes.login);
              }
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
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
      throw NetworkException(
        message: 'Network error, please check your connection.',
      );
    }

    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data is Map
          ? (e.response?.data['message'] ?? 'Server error')
          : 'Server error';
      throw ServerException(message: message, statusCode: statusCode ?? 0);
    }

    throw ServerException(
      message: e.message ?? 'An unknown error occurred.',
      statusCode: 0,
    );
  }
}
