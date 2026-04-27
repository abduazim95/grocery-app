import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/sales/presentation/providers/sales_provider.dart';
import 'package:grocery/shared/models/sale.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class SaleDetailScreen extends ConsumerWidget {
  final String id;

  const SaleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleAsync = ref.watch(saleDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text('Продажа')),
      body: saleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e),
        data: (sale) => _SaleBody(sale: sale),
      ),
    );
  }
}

class _SaleBody extends StatelessWidget {
  final Sale sale;

  const _SaleBody({required this.sale});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDate(sale.createdAt),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${sale.id}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Позиции',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...sale.items.map((item) {
          final name = item.product?.name ?? item.productId;
          final subtotal = item.quantity * item.price;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(name),
              subtitle: Text('${item.quantity} × ${formatSum(item.price)}'),
              trailing: Text(
                formatSum(subtotal),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ИТОГО',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              formatSum(sale.total),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
