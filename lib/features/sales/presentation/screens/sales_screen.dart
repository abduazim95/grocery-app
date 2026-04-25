import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/sales/presentation/providers/sales_provider.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final storeId = user?.storeId ?? '';
    final salesAsync = ref.watch(salesListProvider(storeId));

    return Scaffold(
      appBar: AppBar(title: const Text('Продажи')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.newSale),
        child: const Icon(Icons.add),
      ),
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(salesListProvider(storeId)),
        ),
        data: (sales) {
          if (sales.isEmpty) {
            return const Center(child: Text('Продажи отсутствуют'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(salesListProvider(storeId)),
            child: ListView.builder(
              itemCount: sales.length,
              itemBuilder: (_, i) {
                final sale = sales[sales.length - 1 - i]; // newest first
                return ListTile(
                  leading: const Icon(Icons.receipt_outlined),
                  title: Text(formatSum(sale.total)),
                  subtitle: Text(formatDate(sale.createdAt)),
                  trailing: Text(
                    '${sale.items.length} поз.',
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
