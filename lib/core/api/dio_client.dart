import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery/core/api/app_exception.dart';
import 'package:grocery/core/storage/secure_storage.dart';

class DioClient {
  late final Dio dio;

  DioClient({required String baseUrl, required SecureStorage storage}) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));
    dio.interceptors.addAll([
      AuthInterceptor(storage),
      ErrorInterceptor(),
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
      if (kDebugMode) ChuckerDioInterceptor(),
    ]);
  }
}

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _storage.deleteToken();
    }
    handler.next(err);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        const AppException.network(),
      _ => _parseServerError(err.response),
    };
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: exception,
      response: err.response,
      type: err.type,
    ));
  }

  AppException _parseServerError(Response? response) {
    if (response == null) return const AppException.network();
    final body = response.data as Map<String, dynamic>?;
    return AppException.server(
      code: body?['code'] as String? ?? 'internal',
      message: body?['message'] as String? ?? 'Ошибка сервера',
      status: response.statusCode ?? 500,
    );
  }
}

T unwrapData<T>(Response response, T Function(dynamic) fromJson) =>
    fromJson((response.data as Map<String, dynamic>)['data']);

List<T> unwrapList<T>(Response response, T Function(dynamic) fromJson) {
  final data = (response.data as Map<String, dynamic>)['data'];
  return (data as List).map((e) => fromJson(e)).toList();
}
