import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/purchases/data/repositories/purchase_repository_impl.dart';
import 'package:grocery/features/purchases/presentation/providers/purchases_provider.dart';
import 'package:grocery/shared/models/purchase.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class PurchasesScreen extends ConsumerStatefulWidget {
  const PurchasesScreen({super.key});

  @override
  ConsumerState<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends ConsumerState<PurchasesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  String get _storeId => ref.read(authStateProvider).valueOrNull?.storeId ?? '';

  Future<void> _createPurchase() async {
    try {
      final order = await ref
          .read(purchaseRepositoryProvider)
          .create(storeId: _storeId);
      if (mounted) {
        ref.invalidate(purchasesListProvider());
        context.push('/purchases/${order.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(purchasesListProvider(storeId: _storeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Закуп'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [Tab(text: 'Открытые'), Tab(text: 'Закрытые')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPurchase,
        child: const Icon(Icons.add),
      ),
      body: purchasesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(purchasesListProvider(storeId: _storeId)),
        ),
        data: (purchases) => TabBarView(
          controller: _tabCtrl,
          children: [
            _PurchaseList(
              purchases: purchases
                  .where((p) => p.status == PurchaseStatus.open)
                  .toList(),
            ),
            _PurchaseList(
              purchases: purchases
                  .where((p) => p.status == PurchaseStatus.closed)
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseList extends StatelessWidget {
  final List<PurchaseOrder> purchases;

  const _PurchaseList({required this.purchases});

  @override
  Widget build(BuildContext context) {
    if (purchases.isEmpty) {
      return const Center(child: Text('Нет заявок'));
    }
    return ListView.builder(
      itemCount: purchases.length,
      itemBuilder: (_, i) {
        final p = purchases[i];
        return ListTile(
          title: Text('Заявка от ${formatDate(p.createdAt)}'),
          subtitle: Text('${p.items.length} позиций'),
          trailing: Chip(
            label: Text(
              p.status == PurchaseStatus.open ? 'открыта' : 'закрыта',
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: p.status == PurchaseStatus.open
                ? Colors.green[100]
                : Colors.grey[200],
          ),
          onTap: () => context.push('/purchases/${p.id}'),
        );
      },
    );
  }
}
