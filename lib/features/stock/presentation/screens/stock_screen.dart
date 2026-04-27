import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/models/stock_item.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/barcode_scanner_screen.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class StockScreen extends ConsumerStatefulWidget {
  final String storeId;

  const StockScreen({super.key, required this.storeId});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  final List<StockItem> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String _query = '';
  String? _error;

  String get _businessId => ref.read(authStateProvider).valueOrNull?.businessId ?? '';

  @override
  void initState() {
    super.initState();
    _load();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _load({bool reset = false}) async {
    if (_isLoading) return;
    if (!reset && !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
      if (reset) {
        _items.clear();
        _page = 1;
        _hasMore = true;
      }
    });

    try {
      final result = await ref.read(stockRepositoryProvider).getStock(
            widget.storeId,
            query: _query.isEmpty ? null : _query,
            page: _page,
          );
      setState(() {
        _items.addAll(result.items);
        _hasMore = result.hasMore;
        _page++;
      });
    } catch (e) {
      setState(() => _error = mapException(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() => _load();

  Future<void> _refresh() => _load(reset: true);

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _query = q);
      _load(reset: true);
    });
  }

  Future<void> _onBarcodeScanned() async {
    final barcode = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
    if (barcode == null || !mounted) return;

    try {
      final product = await ref
          .read(productRepositoryProvider)
          .getByBarcode(businessId: _businessId, barcode: barcode);
      _showStockByProduct(product);
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

  void _showStockByProduct(Product product) {
    final item = _items.where((i) => i.productId == product.id).firstOrNull;
    if (item != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => _InventoryEditSheet(
          storeId: widget.storeId,
          item: item,
          onSaved: _refresh,
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => _AddStockSheet(
          storeId: widget.storeId,
          preselected: product,
          onSaved: _refresh,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Остатки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Найти по штрихкоду',
            onPressed: _onBarcodeScanned,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => _AddStockSheet(storeId: widget.storeId, onSaved: _refresh),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Поиск по названию',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_error != null && _items.isEmpty)
            Expanded(
              child: ErrorView(
                error: _error!,
                onRetry: _refresh,
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: _items.isEmpty && !_isLoading
                    ? const Center(child: Text('Нет товаров'))
                    : ListView.builder(
                        controller: _scrollCtrl,
                        itemCount: _items.length + (_hasMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i == _items.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return _StockTile(
                            item: _items[i],
                            storeId: widget.storeId,
                            onChanged: _refresh,
                          );
                        },
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StockTile extends StatelessWidget {
  final StockItem item;
  final String storeId;
  final VoidCallback onChanged;

  const _StockTile({
    required this.item,
    required this.storeId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final name = item.product?.name ?? item.productId;
    final unit = item.product?.unit ?? '';

    return ListTile(
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${item.quantity} $unit'),
          if (item.minQuantity > 0)
            Text(
              'Мин: ${item.minQuantity} $unit',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
            tooltip: 'Приход',
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => _ArrivalSheet(storeId: storeId, item: item, onSaved: onChanged),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Инвентаризация',
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => _InventoryEditSheet(storeId: storeId, item: item, onSaved: onChanged),
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryEditSheet extends ConsumerStatefulWidget {
  final String storeId;
  final StockItem item;
  final VoidCallback onSaved;

  const _InventoryEditSheet({
    required this.storeId,
    required this.item,
    required this.onSaved,
  });

  @override
  ConsumerState<_InventoryEditSheet> createState() => _InventoryEditSheetState();
}

class _InventoryEditSheetState extends ConsumerState<_InventoryEditSheet> {
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _minCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(text: widget.item.quantity.toStringAsFixed(0));
    _minCtrl = TextEditingController(
      text: widget.item.minQuantity > 0
          ? widget.item.minQuantity.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final qty = double.tryParse(_qtyCtrl.text);
    if (qty == null || qty < 0) return;
    final minQty = _minCtrl.text.isEmpty ? null : double.tryParse(_minCtrl.text);

    setState(() => _isLoading = true);
    try {
      await ref.read(stockRepositoryProvider).updateStock(
            storeId: widget.storeId,
            productId: widget.item.productId,
            quantity: qty,
            minQuantity: minQty,
          );
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
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
    final name = widget.item.product?.name ?? widget.item.productId;
    final unit = widget.item.product?.unit ?? '';

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Инвентаризация: $name',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _qtyCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: InputDecoration(labelText: 'Точное количество', suffixText: unit),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _minCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: InputDecoration(
              labelText: 'Минимальный остаток (необязательно)',
              suffixText: unit,
              helperText: 'Порог для автозаявки на закуп',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

class _ArrivalSheet extends ConsumerStatefulWidget {
  final String storeId;
  final StockItem item;
  final VoidCallback onSaved;

  const _ArrivalSheet({required this.storeId, required this.item, required this.onSaved});

  @override
  ConsumerState<_ArrivalSheet> createState() => _ArrivalSheetState();
}

class _ArrivalSheetState extends ConsumerState<_ArrivalSheet> {
  final _qtyCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final qty = double.tryParse(_qtyCtrl.text);
    if (qty == null || qty <= 0) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(stockRepositoryProvider).addStock(
            storeId: widget.storeId,
            productId: widget.item.productId,
            quantity: qty,
          );
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
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
    final name = widget.item.product?.name ?? widget.item.productId;
    final unit = widget.item.product?.unit ?? '';

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Приход: $name',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Текущий остаток: ${widget.item.quantity} $unit',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(
            controller: _qtyCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: InputDecoration(labelText: 'Количество к добавлению', suffixText: unit),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _add,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}

class _AddStockSheet extends ConsumerStatefulWidget {
  final String storeId;
  final Product? preselected;
  final VoidCallback onSaved;

  const _AddStockSheet({
    required this.storeId,
    this.preselected,
    required this.onSaved,
  });

  @override
  ConsumerState<_AddStockSheet> createState() => _AddStockSheetState();
}

class _AddStockSheetState extends ConsumerState<_AddStockSheet> {
  final _searchCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  List<Product> _results = [];
  Product? _selected;
  bool _isLoading = false;

  String get _businessId =>
      ref.read(authStateProvider).valueOrNull?.businessId ?? '';

  @override
  void initState() {
    super.initState();
    if (widget.preselected != null) {
      _selected = widget.preselected;
      _searchCtrl.text = widget.preselected!.name;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }
    final r = await ref
        .read(productRepositoryProvider)
        .listProducts(businessId: _businessId, query: q);
    setState(() => _results = r.products);
  }

  Future<void> _add() async {
    if (_selected == null) return;
    final qty = double.tryParse(_qtyCtrl.text);
    if (qty == null || qty <= 0) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(stockRepositoryProvider).addStock(
            storeId: widget.storeId,
            productId: _selected!.id,
            quantity: qty,
          );
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
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
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Добавить товар на склад',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _searchCtrl,
            onChanged: _search,
            decoration: const InputDecoration(
              labelText: 'Поиск товара',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          if (_results.isNotEmpty)
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (_, i) {
                  final p = _results[i];
                  return ListTile(
                    dense: true,
                    title: Text(p.name),
                    selected: _selected?.id == p.id,
                    onTap: () => setState(() {
                      _selected = p;
                      _searchCtrl.text = p.name;
                      _results = [];
                    }),
                  );
                },
              ),
            ),
          if (_selected != null)
            Text('Выбрано: ${_selected!.name}',
                style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 12),
          TextField(
            controller: _qtyCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: const InputDecoration(labelText: 'Количество'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading || _selected == null ? null : _add,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Добавить на склад'),
          ),
        ],
      ),
    );
  }
}
