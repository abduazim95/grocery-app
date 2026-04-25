import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException implements Exception {
  const factory AppException.network() = NetworkException;
  const factory AppException.unauthorized() = UnauthorizedException;
  const factory AppException.server({
    required String code,
    required String message,
    required int status,
  }) = ServerException;
}
