import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/stock_batch.dart';
import 'package:grocery/shared/models/stock_item.dart';

class StockListResult {
  final List<StockItem> items;
  final int total;
  final int page;
  final int limit;

  const StockListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  bool get hasMore => page * limit < total;
}

class StockRemoteDs {
  final DioClient _client;

  StockRemoteDs(this._client);

  Future<StockListResult> getStock(
    String storeId, {
    String? query,
    int page = 1,
    int limit = 30,
  }) async {
    final response = await _client.get(
      Endpoints.storeStock(storeId),
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        'page': page,
        'limit': limit,
      },
    );
    final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return StockListResult(
      items: (data['items'] as List)
          .map((e) => StockItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (data['total'] as num).toInt(),
      page: (data['page'] as num).toInt(),
      limit: (data['limit'] as num).toInt(),
    );
  }

  Future<StockItem> addStock({
    required String storeId,
    required String productId,
    required double quantity,
  }) async {
    final response = await _client.post(
      Endpoints.storeStock(storeId),
      data: {'product_id': productId, 'quantity': quantity},
    );
    return unwrapData(response, (d) => StockItem.fromJson(d as Map<String, dynamic>));
  }

  Future<StockItem> updateStock({
    required String storeId,
    required String productId,
    required double quantity,
    double? minQuantity,
  }) async {
    final response = await _client.put(
      Endpoints.storeStock(storeId),
      data: {
        'product_id': productId,
        'quantity': quantity,
        if (minQuantity != null) 'min_quantity': minQuantity,
      },
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

  Future<List<StockBatch>> getBatches(String storeId, String productId) async {
    final response = await _client.get(
      Endpoints.storeBatches(storeId),
      queryParameters: {'product_id': productId},
    );
    return unwrapList(response, (d) => StockBatch.fromJson(d as Map<String, dynamic>));
  }

  Future<StockBatch> addBatch({
    required String storeId,
    required String productId,
    required double quantity,
    required DateTime expiresAt,
  }) async {
    final response = await _client.post(
      Endpoints.storeBatches(storeId),
      data: {
        'product_id': productId,
        'quantity': quantity,
        'expires_at': expiresAt.toIso8601String(),
      },
    );
    return unwrapData(response, (d) => StockBatch.fromJson(d as Map<String, dynamic>));
  }

  Future<StockBatch> updateBatch({
    required String storeId,
    required String batchId,
    required double quantity,
  }) async {
    final response = await _client.patch(
      Endpoints.storeBatch(storeId, batchId),
      data: {'quantity': quantity},
    );
    return unwrapData(response, (d) => StockBatch.fromJson(d as Map<String, dynamic>));
  }

  Future<void> writeOffBatch({
    required String storeId,
    required String batchId,
    required double quantity,
  }) async {
    await _client.post(
      Endpoints.storeBatchWriteOff(storeId, batchId),
      data: {'quantity': quantity},
    );
  }
}
