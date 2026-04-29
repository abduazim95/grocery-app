import 'package:grocery/shared/models/purchase.dart';

abstract interface class PurchaseRepository {
  Future<List<PurchaseOrder>> listPurchases({
    String? storeId,
    int page,
    int limit,
    String? status,
  });
  Future<PurchaseOrder> getById(String id);
  Future<PurchaseOrder> create({required String storeId});
  Future<PurchaseOrderItem> addItem({
    required String purchaseId,
    required String productId,
    required double quantity,
    required double price,
    DateTime? expiresAt,
  });
  Future<PurchaseOrderItem> updateItem({
    required String purchaseId,
    required String itemId,
    required double quantity,
    required double price,
    DateTime? expiresAt,
  });
  Future<void> deleteItem({
    required String purchaseId,
    required String itemId,
  });
  Future<PurchaseOrder> markBought({
    required String purchaseId,
    required String itemId,
    required bool isBought,
  });
  Future<PurchaseOrder> close(String id);
}
