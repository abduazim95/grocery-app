import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/sales/presentation/providers/sales_provider.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final _scrollCtrl = ScrollController();
  DateTime? _from;
  DateTime? _to;

  String get _storeId => ref.read(authStateProvider).valueOrNull?.storeId ?? '';

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
      ref.read(salesListProvider(_storeId).notifier).loadMore();
    }
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _from != null && _to != null
          ? DateTimeRange(start: _from!, end: _to!)
          : null,
    );
    if (range != null) {
      setState(() {
        _from = range.start;
        _to = range.end;
      });
      await ref
          .read(salesListProvider(_storeId).notifier)
          .applyFilter(from: _from, to: _to);
    }
  }

  Future<void> _clearFilter() async {
    setState(() {
      _from = null;
      _to = null;
    });
    await ref
        .read(salesListProvider(_storeId).notifier)
        .applyFilter(from: null, to: null);
  }

  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(salesListProvider(_storeId));
    final hasFilter = _from != null || _to != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Продажи'),
        actions: [
          if (hasFilter)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Сбросить фильтр',
              onPressed: _clearFilter,
            ),
          IconButton(
            icon: Icon(hasFilter ? Icons.date_range : Icons.date_range_outlined),
            tooltip: 'Фильтр по дате',
            onPressed: _pickDateRange,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.newSale),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (hasFilter)
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${formatDateOnly(_from!)} — ${formatDateOnly(_to!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          Expanded(
            child: salesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.read(salesListProvider(_storeId).notifier).refresh(),
              ),
              data: (data) {
                if (data.sales.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(salesListProvider(_storeId).notifier).refresh(),
                    child: const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 300,
                        child: Center(child: Text('Продажи отсутствуют')),
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(salesListProvider(_storeId).notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: data.sales.length + (data.isLoadingMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == data.sales.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final sale = data.sales[i];
                      return ListTile(
                        leading: const Icon(Icons.receipt_outlined),
                        title: Text(formatSum(sale.total)),
                        subtitle: Text(formatDate(sale.createdAt)),
                        trailing: Text(
                          '${sale.items.length} поз.',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () => context.push('/sales/${sale.id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
