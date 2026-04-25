import 'package:grocery/features/products/data/dtos/product_list_result.dart';
import 'package:grocery/shared/models/product.dart';

abstract interface class ProductRepository {
  Future<ProductListResult> listProducts({
    required String businessId,
    String query,
    int page,
    int pageSize,
  });
  Future<Product> getByBarcode({required String businessId, required String barcode});
  Future<Product> create({
    required String businessId,
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
