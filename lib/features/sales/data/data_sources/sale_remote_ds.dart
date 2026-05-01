import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/sale.dart';

class SaleRemoteDs {
  final DioClient _client;

  SaleRemoteDs(this._client);

  Future<List<Sale>> listSales({
    String? storeId,
    int page = 1,
    int limit = 30,
    DateTime? from,
    DateTime? to,
  }) async {
    final response = await _client.get(
      Endpoints.sales,
      queryParameters: {
        if (storeId != null) 'store_id': storeId,
        'page': page,
        'limit': limit,
        if (from != null) 'from': from.toIso8601String().substring(0, 10),
        if (to != null) 'to': to.toIso8601String().substring(0, 10),
      },
    );
    return unwrapPagedList(response, (d) => Sale.fromJson(d as Map<String, dynamic>));
  }

  Future<Sale> getSaleById(String id) async {
    final response = await _client.get(Endpoints.saleById(id));
    return unwrapData(response, (d) => Sale.fromJson(d as Map<String, dynamic>));
  }

  Future<Sale> createSale({
    String? storeId,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await _client.post(
      Endpoints.sales,
      data: {
        if (storeId != null) 'store_id': storeId,
        'items': items,
      },
    );
    return unwrapData(response, (d) => Sale.fromJson(d as Map<String, dynamic>));
  }
}
