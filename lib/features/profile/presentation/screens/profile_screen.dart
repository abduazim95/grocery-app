import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _chuckerEnabled = kDebugMode && ChuckerFlutter.isDebugMode;

  Future<void> _toggleChucker(bool value) async {
    ChuckerFlutter.isDebugMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('chucker_enabled', value);
    setState(() => _chuckerEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final host = ref.watch(serverConfigProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(user.name),
              subtitle: Text(user.phone),
              trailing: Text(
                user.roleLabel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
          ],
          if (host != null)
            ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: const Text('Адрес сервера'),
              subtitle: Text(host, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Изменить адрес сервера'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.serverSetup),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text('Очистить кэш'),
            onTap: () => _clearCache(context, ref),
          ),
          if (kDebugMode) ...[
            const Divider(),
            SwitchListTile(
              secondary: const Icon(Icons.bug_report_outlined),
              title: const Text('HTTP инспектор (Chucker)'),
              subtitle: const Text('Перехват и просмотр запросов'),
              value: _chuckerEnabled,
              onChanged: _toggleChucker,
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Выйти', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Очистить кэш?',
      content:
          'Данные будут заново загружены с сервера. Это может замедлить первое открытие разделов.',
      confirmText: 'Очистить',
      isDestructive: false,
    );
    if (!ok) return;
    try {
      await ref.read(appDatabaseProvider).clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Кэш очищен')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Выйти?',
      content: 'Вы будете перенаправлены на страницу входа.',
      confirmText: 'Выйти',
    );
    if (!ok) return;
    await ref.read(authStateProvider.notifier).logout();
  }
}
