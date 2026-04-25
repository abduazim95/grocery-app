import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:grocery/shared/models/stock_item.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/error_view.dart';

class StockScreen extends ConsumerWidget {
  final String storeId;

  const StockScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(stockListProvider(storeId));

    return Scaffold(
      appBar: AppBar(title: const Text('Остатки')),
      body: stockAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(stockListProvider(storeId)),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Склад пуст'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(stockListProvider(storeId)),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => _StockTile(
                item: items[i],
                storeId: storeId,
              ),
            ),
          );
        },
      ),
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

  Future<void> _save() async {
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    decoration: InputDecoration(suffixText: unit, isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: _save),
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
          ? IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _editing = true),
            )
          : null,
    );
  }
}
