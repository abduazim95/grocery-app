import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/shared/utils/error_messages.dart';
import 'package:grocery/shared/widgets/barcode_input.dart';

const _units = ['шт', 'кг', 'л', 'уп', 'пачка'];

class CreateProductScreen extends ConsumerStatefulWidget {
  final String? initialBarcode;

  const CreateProductScreen({super.key, this.initialBarcode});

  @override
  ConsumerState<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends ConsumerState<CreateProductScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _barcodeCtrl = TextEditingController();
  String _unit = 'шт';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialBarcode != null) {
      _barcodeCtrl.text = widget.initialBarcode!;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _barcodeCtrl.dispose();
    super.dispose();
  }

  String get _storeId => ref.read(authStateProvider).valueOrNull?.storeId ?? '';

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final priceText = _priceCtrl.text.trim();
    if (name.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните обязательные поля')),
      );
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Некорректная цена')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(productRepositoryProvider).create(
            storeId: _storeId,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Новый товар')),
      body: SingleChildScrollView(
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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: const InputDecoration(labelText: 'Цена *', suffixText: 'сум'),
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
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
