import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/features/products/data/dtos/product_list_result.dart';
import 'package:grocery/shared/models/product.dart';

class ProductRemoteDs {
  final DioClient _client;

  ProductRemoteDs(this._client);

  Future<ProductListResult> listProducts({
    required String storeId,
    String query = '',
    int page = 1,
    int pageSize = 30,
  }) async {
    final response = await _client.dio.get(
      Endpoints.products,
      queryParameters: {
        'store_id': storeId,
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
    required String storeId,
    required String barcode,
  }) async {
    final response = await _client.dio.get(
      Endpoints.productBarcode(barcode),
      queryParameters: {'store_id': storeId},
    );
    return unwrapData(response, (d) => Product.fromJson(d as Map<String, dynamic>));
  }

  Future<Product> create({
    required String storeId,
    required String name,
    required double price,
    required String unit,
    String? barcode,
  }) async {
    final response = await _client.dio.post(
      Endpoints.products,
      queryParameters: {'store_id': storeId},
      data: {
        'name': name,
        'price': price,
        'unit': unit,
        if (barcode != null && barcode.isNotEmpty) 'barcode': barcode,
      },
    );
    return unwrapData(response, (d) => Product.fromJson(d as Map<String, dynamic>));
  }

  Future<Product> update({
    required String id,
    required String name,
    required double price,
    required String unit,
    String? barcode,
  }) async {
    final response = await _client.dio.put(
      Endpoints.productById(id),
      data: {
        'name': name,
        'price': price,
        'unit': unit,
        if (barcode != null && barcode.isNotEmpty) 'barcode': barcode,
      },
    );
    return unwrapData(response, (d) => Product.fromJson(d as Map<String, dynamic>));
  }
}
