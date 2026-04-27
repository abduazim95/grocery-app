import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/core/db/app_database.dart';
import 'package:grocery/core/storage/secure_storage.dart';
import 'package:grocery/shared/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) => SecureStorage();

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

@Riverpod(keepAlive: true)
class ServerConfig extends _$ServerConfig {
  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('server_host');
  }

  Future<void> setHost(String host) async {
    final normalized = _normalize(host);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_host', normalized);
    ref.invalidateSelf();
    await ref.read(secureStorageProvider).clear();
    ref.invalidate(authStateProvider);
  }

  Future<void> clearHost() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('server_host');
    ref.invalidateSelf();
  }

  String _normalize(String input) {
    var host = input.trim();
    if (!host.startsWith('http://') && !host.startsWith('https://')) {
      host = 'http://$host';
    }
    return host.replaceAll(RegExp(r'/+$'), '');
  }
}

@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  final host = ref.watch(serverConfigProvider).valueOrNull ?? '';
  return DioClient(
    baseUrl: host,
    storage: ref.watch(secureStorageProvider),
  );
}

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  Future<User?> build() async {
    final storage = ref.watch(secureStorageProvider);
    final token = await storage.getToken();
    if (token == null) return null;
    return storage.getUser();
  }

  Future<void> setUser(User user, String token) async {
    final storage = ref.read(secureStorageProvider);
    await storage.setToken(token);
    await storage.setUser(user);
    state = AsyncData(user);
  }

  Future<void> updateUser(User user) async {
    final storage = ref.read(secureStorageProvider);
    await storage.setUser(user);
    state = AsyncData(user);
  }

  Future<void> logout() async {
    await ref.read(secureStorageProvider).clear();
    state = const AsyncData(null);
  }
}
