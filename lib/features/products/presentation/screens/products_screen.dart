import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/core/router/app_routes.dart';
import 'package:grocery/features/products/presentation/providers/barcode_lookup_provider.dart';
import 'package:grocery/features/products/presentation/providers/products_provider.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/utils/formatters.dart';
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

  @override
  Widget build(BuildContext context) {
    final businessId = _businessId;
    final productsAsync =
        ref.watch(productsListNotifierProvider(businessId, query: _query));

    return Scaffold(
      appBar: AppBar(
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
                          return _ProductTile(product: state.items[i]);
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
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

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      onTap: () => context.push('/products/${product.id}/edit'),
    );
  }
}
