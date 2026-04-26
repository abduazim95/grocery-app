import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/stock_item.dart';

class StockRemoteDs {
  final DioClient _client;

  StockRemoteDs(this._client);

  Future<List<StockItem>> getStock(String storeId) async {
    final response = await _client.get(Endpoints.storeStock(storeId));
    return unwrapList(response, (d) => StockItem.fromJson(d as Map<String, dynamic>));
  }

  Future<StockItem> updateStock({
    required String storeId,
    required String productId,
    required double quantity,
  }) async {
    final response = await _client.put(
      Endpoints.storeStock(storeId),
      data: {'product_id': productId, 'quantity': quantity},
    );
    return unwrapData(response, (d) => StockItem.fromJson(d as Map<String, dynamic>));
  }

  Future<void> transfer({
    required String fromStoreId,
    required String toStoreId,
    required String productId,
    required double quantity,
  }) async {
    await _client.post(
      Endpoints.stockTransfer,
      data: {
        'from_store_id': fromStoreId,
        'to_store_id': toStoreId,
        'product_id': productId,
        'quantity': quantity,
      },
    );
  }
}
