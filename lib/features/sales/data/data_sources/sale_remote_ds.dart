import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/sale.dart';

class SaleRemoteDs {
  final DioClient _client;

  SaleRemoteDs(this._client);

  Future<List<Sale>> listSales({required String storeId}) async {
    final response = await _client.dio.get(
      Endpoints.sales,
      queryParameters: {'store_id': storeId},
    );
    return unwrapList(response, (d) => Sale.fromJson(d as Map<String, dynamic>));
  }

  Future<Sale> createSale({
    required String storeId,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await _client.dio.post(
      Endpoints.sales,
      queryParameters: {'store_id': storeId},
      data: {'items': items},
    );
    return unwrapData(response, (d) => Sale.fromJson(d as Map<String, dynamic>));
  }
}
