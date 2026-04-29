import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/models/stock_batch.dart';
import 'package:grocery/shared/models/stock_item.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/barcode_scanner_screen.dart';
import 'package:grocery/shared/widgets/error_view.dart';
import 'package:intl/intl.dart';

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
      if (item.product?.isPerishable == true) {
        _showBatchList(item);
      } else {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => _InventoryEditSheet(
            storeId: widget.storeId,
            item: item,
            onSaved: _refresh,
          ),
        );
      }
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

  void _showBatchList(StockItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => _BatchListSheet(
          storeId: widget.storeId,
          item: item,
          scrollController: scrollController,
          onChanged: _refresh,
        ),
      ),
    );
  }

  void _showAddBatchForItem(StockItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddBatchSheet(
        storeId: widget.storeId,
        productId: item.productId,
        productName: item.product?.name ?? item.productId,
        onSaved: _refresh,
      ),
    );
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
                            onShowBatches: () => _showBatchList(_items[i]),
                            onAddBatch: () => _showAddBatchForItem(_items[i]),
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
  final VoidCallback onShowBatches;
  final VoidCallback onAddBatch;

  const _StockTile({
    required this.item,
    required this.storeId,
    required this.onChanged,
    required this.onShowBatches,
    required this.onAddBatch,
  });

  bool get _isPerishable => item.product?.isPerishable == true;

  @override
  Widget build(BuildContext context) {
    final name = item.product?.name ?? item.productId;
    final unit = item.product?.unit ?? '';

    return ListTile(
      leading: _isPerishable
          ? const Icon(Icons.timer_outlined, color: Colors.orange)
          : null,
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
      onTap: _isPerishable ? onShowBatches : null,
      trailing: _isPerishable
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                  tooltip: 'Приход партии',
                  onPressed: onAddBatch,
                ),
                IconButton(
                  icon: const Icon(Icons.layers_outlined),
                  tooltip: 'Партии',
                  onPressed: onShowBatches,
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                  tooltip: 'Приход',
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) =>
                        _ArrivalSheet(storeId: storeId, item: item, onSaved: onChanged),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Инвентаризация',
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) =>
                        _InventoryEditSheet(storeId: storeId, item: item, onSaved: onChanged),
                  ),
                ),
              ],
            ),
    );
  }
}

// ─── Batch list (perishable) ────────────────────────────────────────────────

class _BatchListSheet extends ConsumerStatefulWidget {
  final String storeId;
  final StockItem item;
  final ScrollController scrollController;
  final VoidCallback onChanged;

  const _BatchListSheet({
    required this.storeId,
    required this.item,
    required this.scrollController,
    required this.onChanged,
  });

  @override
  ConsumerState<_BatchListSheet> createState() => _BatchListSheetState();
}

class _BatchListSheetState extends ConsumerState<_BatchListSheet> {
  List<StockBatch> _batches = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final batches = await ref
          .read(stockRepositoryProvider)
          .getBatches(widget.storeId, widget.item.productId);
      setState(() => _batches = batches);
    } catch (e) {
      setState(() => _error = mapException(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showAddBatch() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddBatchSheet(
        storeId: widget.storeId,
        productId: widget.item.productId,
        productName: widget.item.product?.name ?? widget.item.productId,
        onSaved: () {
          _load();
          widget.onChanged();
        },
      ),
    );
  }

  Future<void> _showEditBatch(StockBatch batch) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditBatchSheet(
        storeId: widget.storeId,
        batch: batch,
        unit: widget.item.product?.unit ?? '',
        onSaved: () {
          _load();
          widget.onChanged();
        },
      ),
    );
  }

  Future<void> _showWriteOff(StockBatch batch) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _WriteOffSheet(
        storeId: widget.storeId,
        batch: batch,
        unit: widget.item.product?.unit ?? '',
        onSaved: () {
          _load();
          widget.onChanged();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.item.product?.name ?? widget.item.productId;
    final unit = widget.item.product?.unit ?? '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Партии: $name',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Всего: ${widget.item.quantity} $unit',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Добавить партию',
                onPressed: _showAddBatch,
              ),
            ],
          ),
        ),
        const Divider(),
        if (_isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_error != null)
          Expanded(
            child: ErrorView(error: _error!, onRetry: _load),
          )
        else if (_batches.isEmpty)
          const Expanded(child: Center(child: Text('Партий нет')))
        else
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: _batches.length,
              itemBuilder: (_, i) => _BatchTile(
                batch: _batches[i],
                unit: unit,
                onEdit: () => _showEditBatch(_batches[i]),
                onWriteOff: () => _showWriteOff(_batches[i]),
              ),
            ),
          ),
      ],
    );
  }
}

class _BatchTile extends StatelessWidget {
  final StockBatch batch;
  final String unit;
  final VoidCallback onEdit;
  final VoidCallback onWriteOff;

  const _BatchTile({
    required this.batch,
    required this.unit,
    required this.onEdit,
    required this.onWriteOff,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd.MM.yyyy').format(batch.expiresAt);
    final Color expiryColor;
    final String badge;
    if (batch.isExpired) {
      expiryColor = Colors.red;
      badge = 'Просрочена';
    } else if (batch.isExpiring) {
      expiryColor = Colors.orange;
      badge = 'Истекает (${batch.daysLeft} дн.)';
    } else {
      expiryColor = Colors.grey;
      badge = '';
    }

    return ListTile(
      title: Row(
        children: [
          Text('${batch.quantity} $unit'),
          const SizedBox(width: 8),
          if (badge.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: expiryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: TextStyle(fontSize: 11, color: expiryColor),
              ),
            ),
        ],
      ),
      subtitle: Text(
        'Срок: $dateStr',
        style: TextStyle(color: expiryColor, fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Корректировать',
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
            tooltip: 'Списать',
            onPressed: onWriteOff,
          ),
        ],
      ),
    );
  }
}

// ─── Add batch sheet ─────────────────────────────────────────────────────────

class _AddBatchSheet extends ConsumerStatefulWidget {
  final String storeId;
  final String productId;
  final String productName;
  final VoidCallback onSaved;

  const _AddBatchSheet({
    required this.storeId,
    required this.productId,
    required this.productName,
    required this.onSaved,
  });

  @override
  ConsumerState<_AddBatchSheet> createState() => _AddBatchSheetState();
}

class _AddBatchSheetState extends ConsumerState<_AddBatchSheet> {
  final _qtyCtrl = TextEditingController();
  DateTime? _expiresAt;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _expiresAt = picked);
  }

  Future<void> _save() async {
    final qty = double.tryParse(_qtyCtrl.text.trim());
    if (qty == null || qty <= 0) {
      setState(() => _error = 'Введите корректное количество');
      return;
    }
    if (_expiresAt == null) {
      setState(() => _error = 'Выберите срок годности');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await ref.read(stockRepositoryProvider).addBatch(
            storeId: widget.storeId,
            productId: widget.productId,
            quantity: qty,
            expiresAt: _expiresAt!,
          );
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) setState(() => _error = mapException(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _expiresAt != null
        ? DateFormat('dd.MM.yyyy').format(_expiresAt!)
        : 'Не выбран';

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Добавить партию: ${widget.productName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _qtyCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: const InputDecoration(labelText: 'Количество'),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Срок годности'),
            subtitle: Text(dateStr),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDate,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Добавить партию'),
          ),
        ],
      ),
    );
  }
}

// ─── Edit batch (adjust quantity) ────────────────────────────────────────────

class _EditBatchSheet extends ConsumerStatefulWidget {
  final String storeId;
  final StockBatch batch;
  final String unit;
  final VoidCallback onSaved;

  const _EditBatchSheet({
    required this.storeId,
    required this.batch,
    required this.unit,
    required this.onSaved,
  });

  @override
  ConsumerState<_EditBatchSheet> createState() => _EditBatchSheetState();
}

class _EditBatchSheetState extends ConsumerState<_EditBatchSheet> {
  late final TextEditingController _qtyCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(text: widget.batch.quantity.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final qty = double.tryParse(_qtyCtrl.text);
    if (qty == null || qty < 0) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(stockRepositoryProvider).updateBatch(
            storeId: widget.storeId,
            batchId: widget.batch.id,
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
    final dateStr = DateFormat('dd.MM.yyyy').format(widget.batch.expiresAt);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Корректировка партии',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Срок годности: $dateStr', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(
            controller: _qtyCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: InputDecoration(
              labelText: 'Новое количество',
              suffixText: widget.unit,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

// ─── Write-off sheet ──────────────────────────────────────────────────────────

class _WriteOffSheet extends ConsumerStatefulWidget {
  final String storeId;
  final StockBatch batch;
  final String unit;
  final VoidCallback onSaved;

  const _WriteOffSheet({
    required this.storeId,
    required this.batch,
    required this.unit,
    required this.onSaved,
  });

  @override
  ConsumerState<_WriteOffSheet> createState() => _WriteOffSheetState();
}

class _WriteOffSheetState extends ConsumerState<_WriteOffSheet> {
  final _qtyCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final qty = double.tryParse(_qtyCtrl.text);
    if (qty == null || qty <= 0) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(stockRepositoryProvider).writeOffBatch(
            storeId: widget.storeId,
            batchId: widget.batch.id,
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
    final dateStr = DateFormat('dd.MM.yyyy').format(widget.batch.expiresAt);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Списание',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Партия: $dateStr · ${widget.batch.quantity} ${widget.unit}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _qtyCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: InputDecoration(
              labelText: 'Количество к списанию',
              suffixText: widget.unit,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Списать'),
          ),
        ],
      ),
    );
  }
}

// ─── Non-perishable sheets (unchanged logic) ──────────────────────────────────

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
      text: widget.item.minQuantity > 0 ? widget.item.minQuantity.toStringAsFixed(0) : '',
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
          Text(
            'Инвентаризация: $name',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
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
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}

// ─── Add stock sheet (FAB — both perishable and non-perishable) ───────────────

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
  DateTime? _expiresAt;
  List<Product> _results = [];
  Product? _selected;
  bool _isLoading = false;

  String get _businessId => ref.read(authStateProvider).valueOrNull?.businessId ?? '';

  bool get _isPerishable => _selected?.isPerishable == true;

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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _expiresAt = picked);
  }

  Future<void> _add() async {
    if (_selected == null) return;
    final qty = double.tryParse(_qtyCtrl.text);
    if (qty == null || qty <= 0) return;
    if (_isPerishable && _expiresAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите срок годности'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      if (_isPerishable) {
        await ref.read(stockRepositoryProvider).addBatch(
              storeId: widget.storeId,
              productId: _selected!.id,
              quantity: qty,
              expiresAt: _expiresAt!,
            );
      } else {
        await ref.read(stockRepositoryProvider).addStock(
              storeId: widget.storeId,
              productId: _selected!.id,
              quantity: qty,
            );
      }
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
    final dateStr = _expiresAt != null
        ? DateFormat('dd.MM.yyyy').format(_expiresAt!)
        : 'Не выбран';

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Добавить товар на склад',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
                    trailing: p.isPerishable
                        ? const Icon(Icons.timer_outlined, size: 16, color: Colors.orange)
                        : null,
                    selected: _selected?.id == p.id,
                    onTap: () => setState(() {
                      _selected = p;
                      _searchCtrl.text = p.name;
                      _results = [];
                      _expiresAt = null;
                    }),
                  );
                },
              ),
            ),
          if (_selected != null) ...[
            Row(
              children: [
                Icon(
                  _isPerishable ? Icons.timer_outlined : Icons.inventory_2_outlined,
                  size: 16,
                  color: _isPerishable ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  _selected!.name,
                  style: TextStyle(color: _isPerishable ? Colors.orange : Colors.green),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _qtyCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: const InputDecoration(labelText: 'Количество'),
          ),
          if (_isPerishable) ...[
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Срок годности'),
              subtitle: Text(dateStr),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading || _selected == null ? null : _add,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(_isPerishable ? 'Добавить партию' : 'Добавить на склад'),
          ),
        ],
      ),
    );
  }
}
