import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/purchases/data/repositories/purchase_repository_impl.dart';
import 'package:grocery/features/purchases/presentation/providers/purchases_provider.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/shared/models/purchase.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/utils/formatters.dart';
import 'package:grocery/shared/widgets/confirm_dialog.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class PurchaseDetailScreen extends ConsumerWidget {
  final String id;

  const PurchaseDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(purchaseDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text('Заявка')),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e),
        data: (order) => _OrderBody(order: order, id: id),
      ),
    );
  }
}

class _OrderBody extends ConsumerWidget {
  final PurchaseOrder order;
  final String id;

  const _OrderBody({required this.order, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boughtCount = order.items.where((i) => i.isBought).length;
    final isOpen = order.status == PurchaseStatus.open;

    return Column(
      children: [
        ListTile(
          title: Text('Заявка от ${formatDate(order.createdAt)}'),
          subtitle: Text('Куплено: $boughtCount из ${order.items.length}'),
          trailing: Chip(
            label: Text(isOpen ? 'открыта' : 'закрыта'),
            backgroundColor: isOpen ? Colors.green[100] : Colors.grey[200],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: order.items.length,
            itemBuilder: (_, i) => _ItemTile(
              item: order.items[i],
              purchaseId: id,
              isOpen: isOpen,
            ),
          ),
        ),
        if (isOpen) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddItemSheet(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить позицию'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _closeOrder(context, ref, order),
                    style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Закрыть заявку'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _closeOrder(
      BuildContext context, WidgetRef ref, PurchaseOrder order) async {
    final unbought = order.items.where((i) => !i.isBought).length;
    if (unbought > 0) {
      final confirmed = await showConfirmDialog(
        context,
        title: 'Закрыть заявку?',
        content:
            '$unbought позиций не отмечены как купленные и не попадут на склад. Закрыть заявку?',
        confirmText: 'Закрыть',
        isDestructive: false,
      );
      if (!confirmed) return;
    }
    try {
      await ref.read(purchaseDetailProvider(id).notifier).close();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showAddItemSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddItemSheet(purchaseId: id, ref: ref),
    );
  }
}

class _ItemTile extends ConsumerWidget {
  final PurchaseOrderItem item;
  final String purchaseId;
  final bool isOpen;

  const _ItemTile({
    required this.item,
    required this.purchaseId,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = item.product?.name ?? item.productId;
    return ListTile(
      leading: Checkbox(
        value: item.isBought,
        onChanged: isOpen
            ? (v) async {
                try {
                  await ref
                      .read(purchaseDetailProvider(purchaseId).notifier)
                      .markBought(item.id, v ?? false);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(mapException(e)), backgroundColor: Colors.red),
                    );
                  }
                }
              }
            : null,
      ),
      title: Text(
        name,
        style: TextStyle(
          decoration: item.isBought ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text('${item.quantity} × ${formatSum(item.price)}'),
      trailing: isOpen
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Редактировать',
                  onPressed: () => _showEditSheet(context, ref),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  tooltip: 'Удалить',
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            )
          : null,
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditItemSheet(item: item, purchaseId: purchaseId),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Удалить позицию?',
      content: 'Позиция "${item.product?.name ?? item.productId}" будет удалена из заявки.',
    );
    if (!confirmed) return;
    try {
      await ref
          .read(purchaseDetailProvider(purchaseId).notifier)
          .deleteItem(item.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapException(e)), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _EditItemSheet extends ConsumerStatefulWidget {
  final PurchaseOrderItem item;
  final String purchaseId;

  const _EditItemSheet({required this.item, required this.purchaseId});

  @override
  ConsumerState<_EditItemSheet> createState() => _EditItemSheetState();
}

class _EditItemSheetState extends ConsumerState<_EditItemSheet> {
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _priceCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(text: widget.item.quantity.toStringAsFixed(0));
    _priceCtrl = TextEditingController(text: widget.item.price.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final qty = double.tryParse(_qtyCtrl.text);
    final price = double.tryParse(_priceCtrl.text);
    if (qty == null || price == null || qty <= 0 || price <= 0) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(purchaseRepositoryProvider).updateItem(
            purchaseId: widget.purchaseId,
            itemId: widget.item.id,
            quantity: qty,
            price: price,
          );
      ref.invalidate(purchaseDetailProvider(widget.purchaseId));
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
          Text(
            'Редактировать позицию',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Количество'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                  decoration: const InputDecoration(labelText: 'Цена', suffixText: 'тг'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

class _AddItemSheet extends ConsumerStatefulWidget {
  final String purchaseId;
  final WidgetRef ref;

  const _AddItemSheet({required this.purchaseId, required this.ref});

  @override
  ConsumerState<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends ConsumerState<_AddItemSheet> {
  final _searchCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  final _priceCtrl = TextEditingController();
  String? _selectedProductId;
  String? _selectedProductName;
  bool _isLoading = false;
  List<dynamic> _results = [];

  String get _businessId => ref.read(authStateProvider).valueOrNull?.businessId ?? '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    if (q.isEmpty) return;
    final r = await ref
        .read(productRepositoryProvider)
        .listProducts(businessId: _businessId, query: q);
    setState(() => _results = r.products);
  }

  Future<void> _add() async {
    if (_selectedProductId == null) return;
    final qty = double.tryParse(_qtyCtrl.text);
    final price = double.tryParse(_priceCtrl.text);
    if (qty == null || price == null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(purchaseDetailProvider(widget.purchaseId).notifier).addItem(
            productId: _selectedProductId!,
            quantity: qty,
            price: price,
          );
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
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Добавить позицию',
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
                    selected: _selectedProductId == p.id,
                    onTap: () => setState(() {
                      _selectedProductId = p.id;
                      _selectedProductName = p.name;
                      _priceCtrl.text = p.price.toStringAsFixed(0);
                      _searchCtrl.text = p.name;
                      _results = [];
                    }),
                  );
                },
              ),
            ),
          if (_selectedProductName != null)
            Text('Выбрано: $_selectedProductName',
                style: const TextStyle(color: Colors.green)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Количество'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: const InputDecoration(labelText: 'Цена', suffixText: 'тг'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading || _selectedProductId == null ? null : _add,
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
