import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:grocery/features/stores/data/repositories/store_repository_impl.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/models/store.dart';
import 'package:grocery/shared/utils/error_messages.dart';

class TransferStockScreen extends ConsumerStatefulWidget {
  const TransferStockScreen({super.key});

  @override
  ConsumerState<TransferStockScreen> createState() => _TransferStockScreenState();
}

class _TransferStockScreenState extends ConsumerState<TransferStockScreen> {
  String? _fromStoreId;
  String? _toStoreId;
  String? _productId;
  String? _productName;
  final _qtyCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  bool _isLoading = false;
  List<Product> _searchResults = [];

  String get _storeId => ref.read(authStateProvider).valueOrNull?.storeId ?? '';

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    if (q.isEmpty || _fromStoreId == null) return;
    final r = await ref
        .read(productRepositoryProvider)
        .listProducts(storeId: _fromStoreId!, query: q);
    setState(() => _searchResults = r.products);
  }

  Future<void> _transfer() async {
    if (_fromStoreId == null || _toStoreId == null || _productId == null) return;
    final qty = double.tryParse(_qtyCtrl.text);
    if (qty == null || qty <= 0) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(stockRepositoryProvider).transfer(
            fromStoreId: _fromStoreId!,
            toStoreId: _toStoreId!,
            productId: _productId!,
            quantity: qty,
          );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Перенос выполнен')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storesAsync = ref.watch(storesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Перенос остатков')),
      body: storesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(mapException(e))),
        data: (stores) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _fromStoreId,
                decoration: const InputDecoration(labelText: 'Из магазина'),
                items: stores
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                    .toList(),
                onChanged: (v) => setState(() {
                  _fromStoreId = v;
                  _productId = null;
                  _productName = null;
                  _searchCtrl.clear();
                }),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _toStoreId,
                decoration: const InputDecoration(labelText: 'В магазин'),
                items: stores
                    .where((s) => s.id != _fromStoreId)
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                    .toList(),
                onChanged: (v) => setState(() => _toStoreId = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchCtrl,
                onChanged: _search,
                decoration: const InputDecoration(
                  labelText: 'Поиск товара',
                  prefixIcon: Icon(Icons.search),
                ),
                enabled: _fromStoreId != null,
              ),
              if (_searchResults.isNotEmpty)
                Card(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (_, i) {
                        final p = _searchResults[i];
                        return ListTile(
                          dense: true,
                          title: Text(p.name),
                          selected: _productId == p.id,
                          onTap: () => setState(() {
                            _productId = p.id;
                            _productName = p.name;
                            _searchCtrl.text = p.name;
                            _searchResults = [];
                          }),
                        );
                      },
                    ),
                  ),
                ),
              if (_productName != null)
                Text('Товар: $_productName',
                    style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 12),
              TextField(
                controller: _qtyCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                decoration: const InputDecoration(labelText: 'Количество'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _transfer,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Перенести'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
