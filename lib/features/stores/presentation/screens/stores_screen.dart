import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/stores/data/repositories/store_repository_impl.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class StoresScreen extends ConsumerWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(storesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Магазины')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(AppRoutes.createStore);
          ref.invalidate(storesListProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: storesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(storesListProvider),
        ),
        data: (stores) {
          if (stores.isEmpty) {
            return const Center(child: Text('Нет магазинов'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(storesListProvider),
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (_, i) {
                final s = stores[i];
                return ListTile(
                  leading: const Icon(Icons.store_outlined),
                  title: Text(s.name),
                  subtitle: s.address != null ? Text(s.address!) : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.inventory_2_outlined),
                        tooltip: 'Склад',
                        onPressed: () => context.push('/stores/${s.id}/stock'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.people_outline),
                        tooltip: 'Продавцы',
                        onPressed: () => context.push('/stores/${s.id}',
                            extra: s.name),
                      ),
                    ],
                  ),
                  onTap: () => context.push('/stores/${s.id}', extra: s.name),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
