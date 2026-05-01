import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/purchases/data/repositories/purchase_repository_impl.dart';
import 'package:grocery/features/purchases/presentation/providers/purchases_provider.dart';
import 'package:grocery/features/stores/data/repositories/store_repository_impl.dart';
import 'package:grocery/shared/models/purchase.dart';
import 'package:grocery/shared/models/store.dart';
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
  Store? _selectedStore;

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

  bool get _isManager =>
      ref.read(authStateProvider).valueOrNull?.isManager == true ||
      ref.read(authStateProvider).valueOrNull?.isSuperAdmin == true;

  String? get _storeId {
    if (_isManager) return _selectedStore?.id;
    return ref.read(authStateProvider).valueOrNull?.storeId;
  }

  Future<void> _createPurchase() async {
    if (_isManager) {
      await _createPurchaseAsManager();
    } else {
      await _createPurchaseAsSeller();
    }
  }

  Future<void> _createPurchaseAsSeller() async {
    final storeId = _storeId ?? '';
    if (storeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Магазин не определён'), backgroundColor: Colors.red),
      );
      return;
    }
    try {
      final order = await ref.read(purchaseRepositoryProvider).create(storeId: storeId);
      if (mounted) {
        _invalidateAllLists();
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

  Future<void> _createPurchaseAsManager() async {
    List<Store> stores;
    try {
      stores = await ref.read(storesListProvider.future);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
      return;
    }
    if (stores.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Нет доступных магазинов'), backgroundColor: Colors.red),
        );
      }
      return;
    }
    if (!mounted) return;

    final selectedStoreId = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => _StorePickerSheet(stores: stores),
    );
    if (selectedStoreId == null || !mounted) return;

    try {
      final order =
          await ref.read(purchaseRepositoryProvider).create(storeId: selectedStoreId);
      if (mounted) {
        _invalidateAllLists();
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

  void _invalidateAllLists() {
    ref.invalidate(purchasesListProvider(storeId: _storeId, status: 'open'));
    ref.invalidate(purchasesListProvider(storeId: _storeId, status: 'closed'));
  }

  Future<void> _pickStoreFilter() async {
    List<Store> stores;
    try {
      stores = await ref.read(storesListProvider.future);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
      return;
    }
    if (!mounted) return;

    final result = await showModalBottomSheet<_StorePick?>(
      context: context,
      builder: (_) => _StoreFilterPickerSheet(stores: stores, selected: _selectedStore),
    );
    if (!mounted || result == null) return;

    setState(() => _selectedStore = result.store);
    _invalidateAllLists();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          if (_isManager)
            _StoreFilterBar(
              selected: _selectedStore,
              onTap: _pickStoreFilter,
            ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _PaginatedPurchaseList(storeId: _storeId, status: 'open'),
                _PaginatedPurchaseList(storeId: _storeId, status: 'closed'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreFilterBar extends StatelessWidget {
  final Store? selected;
  final VoidCallback onTap;

  const _StoreFilterBar({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.store_outlined, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selected?.name ?? 'Все магазины',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }
}

class _PaginatedPurchaseList extends ConsumerStatefulWidget {
  final String? storeId;
  final String? status;

  const _PaginatedPurchaseList({this.storeId, this.status});

  @override
  ConsumerState<_PaginatedPurchaseList> createState() => _PaginatedPurchaseListState();
}

class _PaginatedPurchaseListState extends ConsumerState<_PaginatedPurchaseList> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      ref
          .read(purchasesListProvider(storeId: widget.storeId, status: widget.status).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
        purchasesListProvider(storeId: widget.storeId, status: widget.status));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref
            .read(purchasesListProvider(storeId: widget.storeId, status: widget.status)
                .notifier)
            .refresh(),
      ),
      data: (data) {
        if (data.purchases.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => ref
                .read(purchasesListProvider(
                        storeId: widget.storeId, status: widget.status)
                    .notifier)
                .refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 300,
                child: Center(
                  child: Text(widget.status == 'open' ? 'Нет открытых заявок' : 'Нет закрытых заявок'),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref
              .read(purchasesListProvider(storeId: widget.storeId, status: widget.status)
                  .notifier)
              .refresh(),
          child: ListView.builder(
            controller: _scrollCtrl,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.purchases.length + (data.isLoadingMore ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == data.purchases.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final p = data.purchases[i];
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
          ),
        );
      },
    );
  }
}

class _StorePick {
  final Store? store;
  const _StorePick(this.store);
}

class _StorePickerSheet extends StatelessWidget {
  final List<Store> stores;

  const _StorePickerSheet({required this.stores});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Выберите магазин',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(height: 0),
        ...stores.map(
          (s) => ListTile(
            title: Text(s.name),
            subtitle: (s.address != null && s.address!.isNotEmpty) ? Text(s.address!) : null,
            onTap: () => Navigator.pop(context, s.id),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _StoreFilterPickerSheet extends StatelessWidget {
  final List<Store> stores;
  final Store? selected;

  const _StoreFilterPickerSheet({required this.stores, this.selected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Фильтр по магазину',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(height: 0),
        ListTile(
          leading: const Icon(Icons.store_outlined),
          title: const Text('Все магазины'),
          selected: selected == null,
          onTap: () => Navigator.pop(context, const _StorePick(null)),
        ),
        ...stores.map(
          (s) => ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(s.name),
            subtitle: (s.address != null && s.address!.isNotEmpty) ? Text(s.address!) : null,
            selected: selected?.id == s.id,
            onTap: () => Navigator.pop(context, _StorePick(s)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
