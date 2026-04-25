import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_setup_provider.freezed.dart';
part 'server_setup_provider.g.dart';

@freezed
class ServerSetupState with _$ServerSetupState {
  const factory ServerSetupState({
    @Default('') String url,
    @Default(false) bool isTesting,
    @Default(false) bool isVerified,
    String? errorMessage,
  }) = _ServerSetupState;
}

@riverpod
class ServerSetupNotifier extends _$ServerSetupNotifier {
  @override
  ServerSetupState build() => const ServerSetupState();

  void setUrl(String value) =>
      state = state.copyWith(url: value, isVerified: false, errorMessage: null);

  Future<void> testConnection() async {
    final url = state.url.trim();
    if (url.isEmpty) {
      state = state.copyWith(errorMessage: 'Введите адрес сервера');
      return;
    }
    state = state.copyWith(isTesting: true, isVerified: false, errorMessage: null);
    try {
      final normalized = _normalize(url);
      final dio = Dio(BaseOptions(
        baseUrl: normalized,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));
      final response = await dio.get('/health');
      if (response.statusCode == 200) {
        state = state.copyWith(isTesting: false, isVerified: true);
      } else {
        state = state.copyWith(
          isTesting: false,
          errorMessage: 'Сервер ответил с ошибкой',
        );
      }
    } on DioException catch (e) {
      final msg = switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.connectionError =>
          'Сервер недоступен — проверьте адрес и сеть',
        DioExceptionType.receiveTimeout => 'Сервер не отвечает',
        _ => 'Ошибка соединения: ${e.message}',
      };
      state = state.copyWith(isTesting: false, isVerified: false, errorMessage: msg);
    } catch (e) {
      state = state.copyWith(
        isTesting: false,
        isVerified: false,
        errorMessage: 'Некорректный адрес',
      );
    }
  }

  Future<void> save() async {
    await ref.read(serverConfigProvider.notifier).setHost(state.url);
  }

  String _normalize(String input) {
    var h = input.trim();
    if (!h.startsWith('http://') && !h.startsWith('https://')) h = 'http://$h';
    return h.replaceAll(RegExp(r'/+$'), '');
  }
}
