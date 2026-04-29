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
  Future<List<PurchaseOrder>> listPurchases({
    String? storeId,
    int page = 1,
    int limit = 30,
    String? status,
  }) =>
      _ds.listPurchases(storeId: storeId, page: page, limit: limit, status: status);

  @override
  Future<PurchaseOrder> getById(String id) => _ds.getById(id);

  @override
  Future<PurchaseOrder> create({required String storeId}) => _ds.create(storeId: storeId);

  @override
  Future<PurchaseOrderItem> addItem({
    required String purchaseId,
    required String productId,
    required double quantity,
    required double price,
    DateTime? expiresAt,
  }) =>
      _ds.addItem(
        purchaseId: purchaseId,
        productId: productId,
        quantity: quantity,
        price: price,
        expiresAt: expiresAt,
      );

  @override
  Future<PurchaseOrderItem> updateItem({
    required String purchaseId,
    required String itemId,
    required double quantity,
    required double price,
    DateTime? expiresAt,
  }) =>
      _ds.updateItem(
        purchaseId: purchaseId,
        itemId: itemId,
        quantity: quantity,
        price: price,
        expiresAt: expiresAt,
      );

  @override
  Future<void> deleteItem({
    required String purchaseId,
    required String itemId,
  }) =>
      _ds.deleteItem(purchaseId: purchaseId, itemId: itemId);

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
