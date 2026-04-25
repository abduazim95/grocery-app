import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/purchases/data/data_sources/purchase_remote_ds.dart';
import 'package:grocery/features/purchases/domain/repositories/purchase_repository.dart';
import 'package:grocery/shared/models/purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchase_repository_impl.g.dart';

@riverpod
PurchaseRepository purchaseRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  return _PurchaseRepositoryImpl(PurchaseRemoteDs(client));
}

class _PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDs _ds;

  _PurchaseRepositoryImpl(this._ds);

  @override
  Future<List<PurchaseOrder>> listPurchases({String? storeId}) =>
      _ds.listPurchases(storeId: storeId);

  @override
  Future<PurchaseOrder> getById(String id) => _ds.getById(id);

  @override
  Future<PurchaseOrder> create({required String storeId}) =>
      _ds.create(storeId: storeId);

  @override
  Future<PurchaseOrderItem> addItem({
    required String purchaseId,
    required String productId,
    required double quantity,
    required double price,
  }) =>
      _ds.addItem(
          purchaseId: purchaseId,
          productId: productId,
          quantity: quantity,
          price: price);

  @override
  Future<PurchaseOrderItem> updateItem({
    required String purchaseId,
    required String itemId,
    required double quantity,
    required double price,
  }) =>
      _ds.updateItem(
          purchaseId: purchaseId, itemId: itemId, quantity: quantity, price: price);

  @override
  Future<PurchaseOrder> markBought({
    required String purchaseId,
    required String itemId,
    required bool isBought,
  }) =>
      _ds.markBought(purchaseId: purchaseId, itemId: itemId, isBought: isBought);

  @override
  Future<PurchaseOrder> close(String id) => _ds.close(id);
}
