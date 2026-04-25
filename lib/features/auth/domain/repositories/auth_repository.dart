import 'package:grocery/features/auth/data/dtos/token_response.dart';

abstract interface class AuthRepository {
  Future<void> sendOtp({required String phone, required String purpose});
  Future<TokenResponse> login({required String phone, required String password});
  Future<TokenResponse> register({
    required String phone,
    required String otp,
    required String name,
    required String password,
  });
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  });
}
