import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/db/app_database.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/features/sales/presentation/providers/create_sale_provider.dart';
import 'package:grocery/features/sales/presentation/providers/sales_provider.dart';
import 'package:grocery/features/stores/data/repositories/store_repository_impl.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/models/sale.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/barcode_scanner_screen.dart';

class CreateSaleScreen extends ConsumerStatefulWidget {
  const CreateSaleScreen({super.key});

  @override
  ConsumerState<CreateSaleScreen> createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends ConsumerState<CreateSaleScreen> {
  final _searchCtrl = TextEditingController();
  bool _isSubmitting = false;
  bool _isSearching = false;
  List<Product> _searchResults = [];
  Timer? _debounce;
  String? _selectedStoreId;

  bool get _isManager => ref.read(authStateProvider).valueOrNull?.isManager ?? false;
  String get _storeId => _isManager ? (_selectedStoreId ?? '') : (ref.read(authStateProvider).valueOrNull?.storeId ?? '');
  String get _businessId => ref.read(authStateProvider).valueOrNull?.businessId ?? '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onBarcodeScanned() async {
    final barcode = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
    if (barcode == null || !mounted) return;
    await _addByBarcode(barcode);
  }

  Future<void> _addByBarcode(String barcode) async {
    try {
      final cached = await ref.read(appDatabaseProvider).findByBarcode(_businessId, barcode);
      if (cached != null) {
        ref.read(createSaleProvider.notifier).addOrIncrement(cached.toProduct());
        return;
      }
      final product = await ref
          .read(productRepositoryProvider)
          .getByBarcode(businessId: _businessId, barcode: barcode);
      ref.read(createSaleProvider.notifier).addOrIncrement(product);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Товар не найден: $barcode'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    if (q.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _isSearching = true);
      try {
        final result = await ref
            .read(productRepositoryProvider)
            .listProducts(businessId: _businessId, query: q);
        if (mounted) setState(() => _searchResults = result.products);
      } finally {
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

  Future<void> _submit() async {
    final items = ref.read(createSaleProvider);
    if (items.isEmpty) return;
    if (_storeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите магазин'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final sale = await ref.read(createSaleProvider.notifier).submit(_storeId);
      ref.invalidate(salesListProvider(_storeId));
      if (mounted) _showReceiptDialog(sale);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showReceiptDialog(Sale sale) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Чек'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Итого: ${formatSum(sale.total)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('${sale.items.length} позиций'),
            Text(formatDate(sale.createdAt)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Закрыть'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(createSaleProvider.notifier).clear();
            },
            child: const Text('Новая продажа'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(createSaleProvider);
    final notifier = ref.read(createSaleProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Касса'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => notifier.clear(),
              child: const Text('Очистить'),
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isManager)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: _StoreSelector(
                selectedStoreId: _selectedStoreId,
                onChanged: (id) => setState(() => _selectedStoreId = id),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Поиск по названию',
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                      suffixIcon: _isSearching
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _onBarcodeScanned,
                  icon: const Icon(Icons.qr_code_scanner),
                  style: IconButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ),
          if (_searchResults.isNotEmpty)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (_, i) {
                    final p = _searchResults[i];
                    return ListTile(
                      dense: true,
                      title: Text(p.name),
                      trailing: Text(formatSum(p.price)),
                      onTap: () {
                        notifier.addOrIncrement(p);
                        _searchCtrl.clear();
                        setState(() => _searchResults = []);
                      },
                    );
                  },
                ),
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('Добавьте товары для продажи',
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => _SaleItemTile(
                      item: items[i],
                      onQtyChanged: (q) =>
                          notifier.updateQuantity(items[i].product.id, q),
                      onRemove: () => notifier.remove(items[i].product.id),
                    ),
                  ),
          ),
          if (items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ИТОГО:', style: TextStyle(fontSize: 18)),
                        Text(
                          formatSum(notifier.total),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('ОФОРМИТЬ ПРОДАЖУ',
                                style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Units that support fractional quantities.
bool _isDecimalUnit(String unit) => unit == 'кг' || unit == 'л';

String _formatQty(double q, String unit) {
  if (!_isDecimalUnit(unit)) return q.toStringAsFixed(0);
  // Show up to 3 decimal places, strip trailing zeros.
  return q.toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}

class _SaleItemTile extends StatefulWidget {
  final SaleItemDraft item;
  final void Function(double) onQtyChanged;
  final VoidCallback onRemove;

  const _SaleItemTile({
    required this.item,
    required this.onQtyChanged,
    required this.onRemove,
  });

  @override
  State<_SaleItemTile> createState() => _SaleItemTileState();
}

class _SaleItemTileState extends State<_SaleItemTile> {
  late final TextEditingController _ctrl;
  bool _hasFocus = false;

  String get _unit => widget.item.product.unit;
  bool get _decimal => _isDecimalUnit(_unit);
  // Step: 0.5 for weight/volume, 1 for countable units.
  double get _step => _decimal ? 0.5 : 1;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _formatQty(widget.item.quantity, _unit));
  }

  @override
  void didUpdateWidget(_SaleItemTile old) {
    super.didUpdateWidget(old);
    // Only update text when not focused to avoid cursor jump while typing.
    if (!_hasFocus && old.item.quantity != widget.item.quantity) {
      _ctrl.text = _formatQty(widget.item.quantity, _unit);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _decrement() {
    final q = double.parse(
      (widget.item.quantity - _step).toStringAsFixed(3),
    );
    if (q <= 0) {
      widget.onRemove();
    } else {
      widget.onQtyChanged(q);
    }
  }

  void _increment() {
    final q = double.parse(
      (widget.item.quantity + _step).toStringAsFixed(3),
    );
    widget.onQtyChanged(q);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.item.product.name),
      subtitle: Text('${formatSum(widget.item.product.price)} / $_unit'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _decrement,
          ),
          Focus(
            onFocusChange: (focused) => setState(() => _hasFocus = focused),
            child: SizedBox(
              width: _decimal ? 64 : 48,
              child: TextField(
                controller: _ctrl,
                textAlign: TextAlign.center,
                keyboardType: _decimal
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.number,
                inputFormatters: [
                  _decimal
                      ? FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      : FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
                onChanged: (v) {
                  final q = double.tryParse(v);
                  if (q != null && q > 0) widget.onQtyChanged(q);
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _increment,
          ),
          Text(
            formatSum(widget.item.subtotal),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}

class _StoreSelector extends ConsumerWidget {
  final String? selectedStoreId;
  final void Function(String?) onChanged;

  const _StoreSelector({required this.selectedStoreId, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(storesListProvider);
    return storesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const SizedBox.shrink(),
      data: (stores) => DropdownButtonFormField<String>(
        value: selectedStoreId,
        decoration: const InputDecoration(
          labelText: 'Магазин *',
          isDense: true,
        ),
        items: stores
            .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
