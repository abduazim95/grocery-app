import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/db/app_database.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/barcode_input.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_product_screen.g.dart';

const _units = ['шт', 'кг', 'л', 'уп', 'пачка'];

@riverpod
Future<Product?> productFromCache(Ref ref, String businessId, String productId) async {
  final db = ref.watch(appDatabaseProvider);
  final rows = await db.getByBusiness(businessId);
  try {
    return rows.firstWhere((r) => r.id == productId).toProduct();
  } catch (_) {
    return null;
  }
}

class EditProductScreen extends ConsumerStatefulWidget {
  final String id;

  const EditProductScreen({super.key, required this.id});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _barcodeCtrl = TextEditingController();
  String _unit = 'шт';
  bool _isLoading = false;
  bool _initialized = false;

  String get _businessId => ref.read(authStateProvider).valueOrNull?.businessId ?? '';

  void _initFrom(Product p) {
    if (_initialized) return;
    _nameCtrl.text = p.name;
    _priceCtrl.text = p.price.toStringAsFixed(0);
    _barcodeCtrl.text = p.barcode ?? '';
    _unit = _units.contains(p.unit) ? p.unit : 'шт';
    _initialized = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _barcodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim());
    if (name.isEmpty || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните обязательные поля')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(productRepositoryProvider).update(
            id: widget.id,
            name: name,
            price: price,
            unit: _unit,
            barcode: _barcodeCtrl.text.trim().isEmpty ? null : _barcodeCtrl.text.trim(),
          );
      if (mounted) context.pop();
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
    final productAsync = ref.watch(productFromCacheProvider(_businessId, widget.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать товар')),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(mapException(e))),
        data: (product) {
          if (product != null) _initFrom(product);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Название *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Цена *',
                    suffixText: 'тг',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _unit,
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) => setState(() => _unit = v!),
                  decoration: const InputDecoration(labelText: 'Единица *'),
                ),
                const SizedBox(height: 12),
                BarcodeInput(
                  controller: _barcodeCtrl,
                  onScanned: (_) {},
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Сохранить'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
