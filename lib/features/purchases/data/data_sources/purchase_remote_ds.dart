import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/purchase.dart';

class PurchaseRemoteDs {
  final DioClient _client;

  PurchaseRemoteDs(this._client);

  Future<List<PurchaseOrder>> listPurchases({String? storeId}) async {
    final response = await _client.get(
      Endpoints.purchases,
      queryParameters: storeId != null ? {'store_id': storeId} : {},
    );
    return unwrapList(response, (d) => PurchaseOrder.fromJson(d as Map<String, dynamic>));
  }

  Future<PurchaseOrder> getById(String id) async {
    final response = await _client.get(Endpoints.purchaseById(id));
    return unwrapData(response, (d) => PurchaseOrder.fromJson(d as Map<String, dynamic>));
  }

  Future<PurchaseOrder> create({required String storeId}) async {
    final response = await _client.post(
      Endpoints.purchases,
      data: {'store_id': storeId},
    );
    return unwrapData(response, (d) => PurchaseOrder.fromJson(d as Map<String, dynamic>));
  }

  Future<PurchaseOrderItem> addItem({
    required String purchaseId,
    required String productId,
    required double quantity,
    required double price,
  }) async {
    final response = await _client.post(
      Endpoints.purchaseItems(purchaseId),
      data: {'product_id': productId, 'quantity': quantity, 'price': price},
    );
    return unwrapData(
        response, (d) => PurchaseOrderItem.fromJson(d as Map<String, dynamic>));
  }

  Future<PurchaseOrderItem> updateItem({
    required String purchaseId,
    required String itemId,
    required double quantity,
    required double price,
  }) async {
    final response = await _client.put(
      Endpoints.purchaseItem(purchaseId, itemId),
      data: {'quantity': quantity, 'price': price},
    );
    return unwrapData(
        response, (d) => PurchaseOrderItem.fromJson(d as Map<String, dynamic>));
  }

  Future<PurchaseOrder> markBought({
    required String purchaseId,
    required String itemId,
    required bool isBought,
  }) async {
    final response = await _client.patch(
      Endpoints.purchaseItemBought(purchaseId, itemId),
      data: {'is_bought': isBought},
    );
    return unwrapData(response, (d) => PurchaseOrder.fromJson(d as Map<String, dynamic>));
  }

  Future<PurchaseOrder> close(String id) async {
    final response = await _client.post(Endpoints.purchaseClose(id));
    return unwrapData(response, (d) => PurchaseOrder.fromJson(d as Map<String, dynamic>));
  }
}
