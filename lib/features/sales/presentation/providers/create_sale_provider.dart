import 'package:grocery/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:grocery/shared/models/sale.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_sale_provider.g.dart';

@riverpod
class CreateSale extends _$CreateSale {
  @override
  List<SaleItemDraft> build() => [];

  void addOrIncrement(Product product) {
    final idx = state.indexWhere((i) => i.product.id == product.id);
    if (idx != -1) {
      state = [
        ...state.sublist(0, idx),
        state[idx].copyWith(quantity: state[idx].quantity + 1),
        ...state.sublist(idx + 1),
      ];
    } else {
      state = [...state, SaleItemDraft(product: product, quantity: 1)];
    }
  }

  void updateQuantity(String productId, double qty) {
    state = [
      for (final item in state)
        if (item.product.id == productId) item.copyWith(quantity: qty) else item,
    ];
  }

  void remove(String productId) =>
      state = state.where((i) => i.product.id != productId).toList();

  void clear() => state = [];

  double get total => state.fold(0, (sum, i) => sum + i.subtotal);

  Future<Sale> submit(String storeId) async {
    return ref.read(saleRepositoryProvider).createSale(
          storeId: storeId,
          items: state,
        );
  }
}
