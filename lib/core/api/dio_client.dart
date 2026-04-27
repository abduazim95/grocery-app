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
      // Allow all status codes through onResponse so Chucker can capture them
      validateStatus: (status) => true,
    ));
    dio.interceptors.addAll([
      AuthInterceptor(storage),
      if (kDebugMode) ChuckerDioInterceptor(),
      ErrorInterceptor(),
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _guard(() => dio.get(path, queryParameters: queryParameters, options: options));

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _guard(() => dio.post(path, data: data, queryParameters: queryParameters, options: options));

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _guard(() => dio.put(path, data: data, queryParameters: queryParameters, options: options));

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _guard(
          () => dio.patch(path, data: data, queryParameters: queryParameters, options: options));

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _guard(
          () => dio.delete(path, data: data, queryParameters: queryParameters, options: options));

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error! as AppException;
      rethrow;
    }
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
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      await _storage.deleteToken();
    }
    handler.next(response);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode ?? 0;
    if (status >= 400) {
      handler.reject(DioException(
        requestOptions: response.requestOptions,
        error: _parseServerError(response),
        response: response,
        type: DioExceptionType.badResponse,
      ));
    } else {
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError =>
        const AppException.network(),
      _ => AppException.server(
          code: 'internal',
          message: err.message ?? 'Ошибка сервера',
          status: err.response?.statusCode ?? 500,
        ),
    };
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: exception,
      response: err.response,
      type: err.type,
    ));
  }

  AppException _parseServerError(Response response) {
    final body = response.data as Map<String, dynamic>?;

    return AppException.server(
      code: body?['error']['code'] as String? ?? 'internal',
      message: body?['error']['message'] as String? ?? 'Ошибка сервера',
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

List<T> unwrapPagedList<T>(Response response, T Function(dynamic) fromJson) {
  final data = (response.data as Map<String, dynamic>)['data']['items'];
  return (data as List).map((e) => fromJson(e)).toList();
}

