import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/features/products/presentation/providers/barcode_lookup_provider.dart';
import 'package:grocery/features/products/presentation/providers/product_selection_provider.dart';
import 'package:grocery/features/products/presentation/providers/products_provider.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/amount_field.dart';
import 'package:grocery/shared/widgets/barcode_scanner_screen.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  String _query = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  String get _businessId => ref.read(authStateProvider).valueOrNull?.businessId ?? '';

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      ref
          .read(productsListNotifierProvider(_businessId, query: _query).notifier)
          .loadMore(_businessId, query: _query);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _query = value);
    });
  }

  Future<void> _onBarcodeScanned() async {
    final barcode = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
    if (barcode == null || !mounted) return;

    final result = await ref
        .read(barcodeLookupProvider.notifier)
        .lookup(_businessId, barcode);

    if (!mounted) return;
    result.when(
      data: (product) {
        if (product != null) {
          context.push('/products/${product.id}/edit');
        } else {
          _showNotFoundSheet(barcode);
        }
      },
      error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
      ),
      loading: () {},
    );
  }

  void _showNotFoundSheet(String barcode) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Товар с таким штрихкодом не найден',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.pop();
                context.push(AppRoutes.newProduct, extra: {'barcode': barcode});
              },
              icon: const Icon(Icons.add),
              label: const Text('Создать новый товар'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Отмена'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBatchPriceSheet(Set<String> selectedIds) async {
    final priceCtrl = TextEditingController();
    String? error;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Изменить цену (${selectedIds.length} тов.)',
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                AmountField(
                  controller: priceCtrl,
                  label: 'Новая цена',
                  errorText: error,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    final price = double.tryParse(priceCtrl.text.trim());
                    if (price == null || price <= 0) {
                      setSheetState(() => error = 'Введите корректную цену');
                      return;
                    }
                    Navigator.of(ctx).pop();
                    await _applyBatchPrice(selectedIds.toList(), price);
                  },
                  child: const Text('Применить'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _applyBatchPrice(List<String> ids, double price) async {
    try {
      final updated = await ref
          .read(productRepositoryProvider)
          .batchUpdatePrice(ids, price);
      if (!mounted) return;
      ref.read(productSelectionProvider.notifier).clear();
      ref
          .read(productsListNotifierProvider(_businessId, query: _query).notifier)
          .refresh(_businessId, query: _query);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Обновлено $updated товаров')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessId = _businessId;
    final productsAsync =
        ref.watch(productsListNotifierProvider(businessId, query: _query));
    final selected = ref.watch(productSelectionProvider);
    final isSelecting = selected.isNotEmpty;
    final loadedItems = productsAsync.valueOrNull?.items ?? [];
    final allLoaded = loadedItems.isNotEmpty &&
        loadedItems.every((p) => selected.contains(p.id));

    return Scaffold(
      appBar: isSelecting
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => ref.read(productSelectionProvider.notifier).clear(),
              ),
              title: Text('Выбрано: ${selected.length}'),
              actions: [
                TextButton(
                  onPressed: () {
                    if (allLoaded) {
                      ref.read(productSelectionProvider.notifier).clear();
                    } else {
                      ref
                          .read(productSelectionProvider.notifier)
                          .selectAll(loadedItems.map((p) => p.id));
                    }
                  },
                  child: Text(allLoaded ? 'Снять все' : 'Выбрать все'),
                ),
                TextButton(
                  onPressed: () => _showBatchPriceSheet(selected),
                  child: const Text('Изменить цену'),
                ),
              ],
            )
          : AppBar(
              title: const Text('Товары'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push(AppRoutes.settings),
                ),
              ],
            ),
      body: Column(
        children: [
          if (!isSelecting)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Поиск по названию',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref
                    .read(productsListNotifierProvider(businessId, query: _query).notifier)
                    .refresh(businessId, query: _query),
              ),
              data: (state) => RefreshIndicator(
                onRefresh: () => ref
                    .read(productsListNotifierProvider(businessId, query: _query).notifier)
                    .refresh(businessId, query: _query),
                child: state.items.isEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: constraints.maxHeight,
                            child: const Center(child: Text('Товары не найдены')),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollCtrl,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.items.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i == state.items.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final product = state.items[i];
                          return _ProductTile(
                            product: product,
                            isSelectionMode: isSelecting,
                            isSelected: selected.contains(product.id),
                            onTap: isSelecting
                                ? () => ref
                                    .read(productSelectionProvider.notifier)
                                    .toggle(product.id)
                                : () => context.push('/products/${product.id}/edit'),
                            onLongPress: () => ref
                                .read(productSelectionProvider.notifier)
                                .toggle(product.id),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isSelecting
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'scan',
                  onPressed: _onBarcodeScanned,
                  child: const Icon(Icons.qr_code_scanner),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () => context.push(AppRoutes.newProduct),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ProductTile({
    required this.product,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isSelectionMode
          ? Checkbox(value: isSelected, onChanged: (_) => onTap())
          : null,
      title: Text(product.name),
      subtitle: product.barcode != null ? Text(product.barcode!) : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatSum(product.price),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(product.unit, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
      selected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
