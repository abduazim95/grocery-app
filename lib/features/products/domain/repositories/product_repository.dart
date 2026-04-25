import 'package:grocery/features/products/data/dtos/product_list_result.dart';
import 'package:grocery/shared/models/product.dart';

abstract interface class ProductRepository {
  Future<ProductListResult> listProducts({
    required String storeId,
    String query,
    int page,
    int pageSize,
  });
  Future<Product> getByBarcode({required String storeId, required String barcode});
  Future<Product> create({
    required String storeId,
    required String name,
    required double price,
    required String unit,
    String? barcode,
  });
  Future<Product> update({
    required String id,
    required String name,
    required double price,
    required String unit,
    String? barcode,
  });
}
