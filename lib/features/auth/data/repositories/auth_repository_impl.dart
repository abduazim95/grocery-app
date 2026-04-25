import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/auth/data/data_sources/auth_remote_ds.dart';
import 'package:grocery/features/auth/data/dtos/token_response.dart';
import 'package:grocery/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  return _AuthRepositoryImpl(AuthRemoteDs(client));
}

class _AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDs _ds;

  _AuthRepositoryImpl(this._ds);

  @override
  Future<void> sendOtp({required String phone, required String purpose}) =>
      _ds.sendOtp(phone: phone, purpose: purpose);

  @override
  Future<TokenResponse> login({required String phone, required String password}) =>
      _ds.login(phone: phone, password: password);

  @override
  Future<TokenResponse> register({
    required String phone,
    required String otp,
    required String name,
    required String password,
  }) =>
      _ds.register(phone: phone, otp: otp, name: name, password: password);

  @override
  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) =>
      _ds.resetPassword(phone: phone, otp: otp, newPassword: newPassword);
}
