import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/features/products/data/dtos/product_list_result.dart';
import 'package:grocery/shared/models/product.dart';

class ProductRemoteDs {
  final DioClient _client;

  ProductRemoteDs(this._client);

  Future<ProductListResult> listProducts({
    required String businessId,
    String query = '',
    int page = 1,
    int pageSize = 30,
  }) async {
    final response = await _client.get(
      Endpoints.products,
      queryParameters: {
        'business_id': businessId,
        if (query.isNotEmpty) 'q': query,
        'page': page,
        'page_size': pageSize,
      },
    );
    return unwrapData(
      response,
      (d) => ProductListResult.fromJson(d as Map<String, dynamic>),
    );
  }

  Future<Product> getByBarcode({
    required String businessId,
    required String barcode,
  }) async {
    final response = await _client.get(
      Endpoints.productBarcode(barcode),
      queryParameters: {'business_id': businessId},
    );
    return unwrapData(response, (d) => Product.fromJson(d as Map<String, dynamic>));
  }

  Future<Product> create({
    required String businessId,
    required String name,
    required double price,
    required String unit,
    String? barcode,
    bool isPerishable = false,
  }) async {
    final response = await _client.post(
      Endpoints.products,
      queryParameters: {'business_id': businessId},
      data: {
        'name': name,
        'price': price,
        'unit': unit,
        if (barcode != null && barcode.isNotEmpty) 'barcode': barcode,
        'is_perishable': isPerishable,
      },
    );
    return unwrapData(response, (d) => Product.fromJson(d as Map<String, dynamic>));
  }

  Future<int> batchUpdatePrice(List<String> ids, double price) async {
    final response = await _client.patch(
      Endpoints.productsBatchPrice,
      data: {'ids': ids, 'price': price},
    );
    return unwrapData(
      response,
      (d) => (d as Map<String, dynamic>)['updated'] as int,
    );
  }

  Future<Product> update({
    required String id,
    required String name,
    required double price,
    required String unit,
    String? barcode,
    bool isPerishable = false,
  }) async {
    final response = await _client.put(
      Endpoints.productById(id),
      data: {
        'name': name,
        'price': price,
        'unit': unit,
        if (barcode != null && barcode.isNotEmpty) 'barcode': barcode,
        'is_perishable': isPerishable,
      },
    );
    return unwrapData(response, (d) => Product.fromJson(d as Map<String, dynamic>));
  }
}
