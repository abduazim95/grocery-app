import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _ctrl;
  bool _isTesting = false;
  bool _isVerified = false;
  String? _errorMessage;
  bool _chuckerEnabled = kDebugMode && ChuckerFlutter.isDebugMode;

  @override
  void initState() {
    super.initState();
    final currentHost = ref.read(serverConfigProvider).valueOrNull ?? '';
    _ctrl = TextEditingController(text: currentHost);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    final url = _ctrl.text.trim();
    if (url.isEmpty) {
      setState(() => _errorMessage = 'Введите адрес сервера');
      return;
    }
    setState(() {
      _isTesting = true;
      _isVerified = false;
      _errorMessage = null;
    });
    try {
      final normalized = _normalize(url);
      final dio = Dio(BaseOptions(
        baseUrl: normalized,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));
      final response = await dio.get('/health');
      if ((response.statusCode ?? 0) < 400) {
        setState(() {
          _isTesting = false;
          _isVerified = true;
        });
      } else {
        setState(() {
          _isTesting = false;
          _errorMessage = 'Сервер ответил с ошибкой';
        });
      }
    } on DioException catch (e) {
      final msg = switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.connectionError =>
          'Сервер недоступен — проверьте адрес и сеть',
        DioExceptionType.receiveTimeout => 'Сервер не отвечает',
        _ => 'Ошибка соединения: ${e.message}',
      };
      setState(() {
        _isTesting = false;
        _isVerified = false;
        _errorMessage = msg;
      });
    } catch (_) {
      setState(() {
        _isTesting = false;
        _isVerified = false;
        _errorMessage = 'Некорректный адрес';
      });
    }
  }

  Future<void> _saveHost() async {
    final url = _ctrl.text.trim();
    if (url.isEmpty) {
      setState(() => _errorMessage = 'Введите адрес сервера');
      return;
    }
    await ref.read(serverConfigProvider.notifier).setHost(url);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Адрес сервера сохранён')),
      );
      setState(() => _isVerified = false);
    }
  }

  Future<void> _toggleChucker(bool value) async {
    ChuckerFlutter.isDebugMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('chucker_enabled', value);
    setState(() => _chuckerEnabled = value);
  }

  String _normalize(String input) {
    var h = input.trim();
    if (!h.startsWith('http://') && !h.startsWith('https://')) h = 'http://$h';
    return h.replaceAll(RegExp(r'/+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Адрес сервера',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ctrl,
            keyboardType: TextInputType.url,
            onChanged: (_) => setState(() {
              _isVerified = false;
              _errorMessage = null;
            }),
            decoration: InputDecoration(
              hintText: '192.168.1.100:8080',
              errorText: _errorMessage,
              suffixIcon: _isVerified
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Примеры:\n• 192.168.1.100:8080\n• https://grocery.company.com',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _ctrl.text.isEmpty || _isTesting
                      ? null
                      : _testConnection,
                  child: _isTesting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Проверить'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _isVerified ? _saveHost : null,
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
          if (_isVerified) ...[
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 6),
                Text('Сервер доступен', style: TextStyle(color: Colors.green)),
              ],
            ),
          ],
          if (kDebugMode) ...[
            const SizedBox(height: 24),
            const Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.bug_report_outlined),
              title: const Text('HTTP инспектор (Chucker)'),
              subtitle: const Text('Перехват и просмотр запросов'),
              value: _chuckerEnabled,
              onChanged: _toggleChucker,
            ),
          ],
        ],
      ),
    );
  }
}
