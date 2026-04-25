import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery/shared/models/user.dart';

class SecureStorage {
  static const _tokenKey = 'jwt_token';
  static const _userKey = 'user_data';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> setToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  Future<User?> getUser() async {
    final json = await _storage.read(key: _userKey);
    if (json == null) return null;
    return User.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> setUser(User user) =>
      _storage.write(key: _userKey, value: jsonEncode(user.toJson()));

  Future<void> deleteUser() => _storage.delete(key: _userKey);

  Future<void> clear() async {
    await deleteToken();
    await deleteUser();
  }
}
