import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/models/stock_item.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class StockScreen extends ConsumerStatefulWidget {
  final String storeId;

  const StockScreen({super.key, required this.storeId});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockAsync = ref.watch(stockListProvider(widget.storeId));

    return Scaffold(
      appBar: AppBar(title: const Text('Остатки')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStockSheet(context),
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
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: stockAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(stockListProvider(widget.storeId)),
              ),
              data: (items) {
                final filtered = _query.isEmpty
                    ? items
                    : items.where((item) {
                        final name =
                            (item.product?.name ?? item.productId).toLowerCase();
                        return name.contains(_query);
                      }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Нет товаров'));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(stockListProvider(widget.storeId)),
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _StockTile(
                      item: filtered[i],
                      storeId: widget.storeId,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStockSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddStockSheet(storeId: widget.storeId),
    );
  }
}

class _StockTile extends ConsumerStatefulWidget {
  final StockItem item;
  final String storeId;

  const _StockTile({required this.item, required this.storeId});

  @override
  ConsumerState<_StockTile> createState() => _StockTileState();
}

class _StockTileState extends ConsumerState<_StockTile> {
  bool _editing = false;
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.item.quantity.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _saveInventory() async {
    final qty = double.tryParse(_ctrl.text);
    if (qty == null || qty < 0) return;
    try {
      await ref.read(stockRepositoryProvider).updateStock(
            storeId: widget.storeId,
            productId: widget.item.productId,
            quantity: qty,
          );
      ref.invalidate(stockListProvider(widget.storeId));
      if (mounted) setState(() => _editing = false);
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
    final name = widget.item.product?.name ?? widget.item.productId;
    final unit = widget.item.product?.unit ?? '';

    return ListTile(
      title: Text(name),
      subtitle: _editing
          ? Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _ctrl,
                    autofocus: true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                    decoration: InputDecoration(suffixText: unit, isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: _saveInventory),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    _ctrl.text = widget.item.quantity.toStringAsFixed(0);
                    setState(() => _editing = false);
                  },
                ),
              ],
            )
          : Text('${widget.item.quantity} $unit'),
      trailing: !_editing
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                  tooltip: 'Приход',
                  onPressed: () => _showArrivalSheet(context),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Инвентаризация',
                  onPressed: () => setState(() => _editing = true),
                ),
              ],
            )
          : null,
    );
  }

  void _showArrivalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ArrivalSheet(storeId: widget.storeId, item: widget.item),
    );
  }
}

class _ArrivalSheet extends ConsumerStatefulWidget {
  final String storeId;
  final StockItem item;

  const _ArrivalSheet({required this.storeId, required this.item});

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
      ref.invalidate(stockListProvider(widget.storeId));
      if (mounted) Navigator.pop(context);
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
      padding:
          EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
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
            decoration: InputDecoration(
              labelText: 'Количество к добавлению',
              suffixText: unit,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _add,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
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

  const _AddStockSheet({required this.storeId});

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
      ref.invalidate(stockListProvider(widget.storeId));
      if (mounted) Navigator.pop(context);
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
      padding:
          EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
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
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Добавить на склад'),
          ),
        ],
      ),
    );
  }
}
