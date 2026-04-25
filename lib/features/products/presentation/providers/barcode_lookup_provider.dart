import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barcode_lookup_provider.g.dart';

@riverpod
class BarcodeLookup extends _$BarcodeLookup {
  @override
  AsyncValue<Product?> build() => const AsyncData(null);

  Future<void> lookup(String storeId, String barcode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        return await ref
            .read(productRepositoryProvider)
            .getByBarcode(storeId: storeId, barcode: barcode);
      } catch (e) {
        // 404 means not found — return null instead of error
        if (_is404(e)) return null;
        rethrow;
      }
    });
  }

  bool _is404(Object e) {
    return e.toString().contains('404') ||
        e.toString().contains('not_found');
  }
}
