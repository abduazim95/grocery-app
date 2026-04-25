import 'package:grocery/shared/models/purchase.dart';

abstract interface class PurchaseRepository {
  Future<List<PurchaseOrder>> listPurchases({String? storeId});
  Future<PurchaseOrder> getById(String id);
  Future<PurchaseOrder> create({required String storeId});
  Future<PurchaseOrderItem> addItem({
    required String purchaseId,
    required String productId,
    required double quantity,
    required double price,
  });
  Future<PurchaseOrderItem> updateItem({
    required String purchaseId,
    required String itemId,
    required double quantity,
    required double price,
  });
  Future<PurchaseOrder> markBought({
    required String purchaseId,
    required String itemId,
    required bool isBought,
  });
  Future<PurchaseOrder> close(String id);
}
