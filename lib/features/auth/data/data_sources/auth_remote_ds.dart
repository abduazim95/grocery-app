import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/features/auth/data/dtos/login_request.dart';
import 'package:grocery/features/auth/data/dtos/register_request.dart';
import 'package:grocery/features/auth/data/dtos/reset_password_request.dart';
import 'package:grocery/features/auth/data/dtos/send_otp_request.dart';
import 'package:grocery/features/auth/data/dtos/token_response.dart';

class AuthRemoteDs {
  final DioClient _client;

  AuthRemoteDs(this._client);

  Future<void> sendOtp({required String phone, required String purpose}) async {
    await _client.dio.post(
      Endpoints.sendOtp,
      data: SendOtpRequest(phone: phone, purpose: purpose).toJson(),
    );
  }

  Future<TokenResponse> login({
    required String phone,
    required String password,
  }) async {
    final response = await _client.dio.post(
      Endpoints.login,
      data: LoginRequest(phone: phone, password: password).toJson(),
    );
    return unwrapData(response, (d) => TokenResponse.fromJson(d as Map<String, dynamic>));
  }

  Future<TokenResponse> register({
    required String phone,
    required String otp,
    required String name,
    required String password,
  }) async {
    final response = await _client.dio.post(
      Endpoints.register,
      data: RegisterRequest(phone: phone, otp: otp, name: name, password: password)
          .toJson(),
    );
    return unwrapData(response, (d) => TokenResponse.fromJson(d as Map<String, dynamic>));
  }

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    await _client.dio.post(
      Endpoints.resetPassword,
      data: ResetPasswordRequest(phone: phone, otp: otp, newPassword: newPassword)
          .toJson(),
    );
  }
}
