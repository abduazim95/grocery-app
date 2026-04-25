import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/confirm_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

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
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: const Text('Очистить кэш'),
            onTap: () => _clearCache(context, ref),
          ),
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
