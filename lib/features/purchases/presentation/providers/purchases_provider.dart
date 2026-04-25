import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/purchases/data/repositories/purchase_repository_impl.dart';
import 'package:grocery/shared/models/purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchases_provider.g.dart';

@riverpod
Future<List<PurchaseOrder>> purchasesList(Ref ref, {String? storeId}) =>
    ref.watch(purchaseRepositoryProvider).listPurchases(storeId: storeId);

@riverpod
class PurchaseDetail extends _$PurchaseDetail {
  @override
  Future<PurchaseOrder> build(String id) =>
      ref.watch(purchaseRepositoryProvider).getById(id);

  Future<void> markBought(String itemId, bool isBought) async {
    final order = await ref
        .read(purchaseRepositoryProvider)
        .markBought(purchaseId: id, itemId: itemId, isBought: isBought);
    state = AsyncData(order);
  }

  Future<void> close() async {
    final order = await ref.read(purchaseRepositoryProvider).close(id);
    state = AsyncData(order);
  }

  Future<void> addItem({
    required String productId,
    required double quantity,
    required double price,
  }) async {
    await ref.read(purchaseRepositoryProvider).addItem(
          purchaseId: id,
          productId: productId,
          quantity: quantity,
          price: price,
        );
    ref.invalidateSelf();
    await future;
  }
}
