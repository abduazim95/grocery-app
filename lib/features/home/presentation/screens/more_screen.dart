import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ещё'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        children: [
          if (user?.isManager == true || user?.isSuperAdmin == true)
            ListTile(
              leading: const Icon(Icons.store_outlined),
              title: const Text('Магазины'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.stores),
            ),
          if (user?.isManager == true || user?.isSuperAdmin == true)
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Перенос остатков'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.stockTransfer),
            ),
          if (user?.isSuperAdmin ?? false)
            ListTile(
              leading: const Icon(Icons.person_add_outlined),
              title: const Text('Создать руководителя'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.newManager),
            ),
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: const Text('Профиль'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
    );
  }
}
