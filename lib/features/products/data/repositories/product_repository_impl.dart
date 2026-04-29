import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/db/app_database.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/products/data/data_sources/product_remote_ds.dart';
import 'package:grocery/features/products/data/dtos/product_list_result.dart';
import 'package:grocery/features/products/domain/repositories/product_repository.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repository_impl.g.dart';

@riverpod
ProductRepository productRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  final db = ref.watch(appDatabaseProvider);
  return _ProductRepositoryImpl(ProductRemoteDs(client), db);
}

class _ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDs _ds;
  final AppDatabase _db;

  _ProductRepositoryImpl(this._ds, this._db);

  @override
  Future<ProductListResult> listProducts({
    required String businessId,
    String query = '',
    int page = 1,
    int pageSize = 30,
  }) async {
    final result = await _ds.listProducts(
      businessId: businessId,
      query: query,
      page: page,
      pageSize: pageSize,
    );
    // update cache
    await _db.upsertProducts(result.products.map((p) => p.toCompanion()).toList());
    return result;
  }

  @override
  Future<Product> getByBarcode({
    required String businessId,
    required String barcode,
  }) async {
    // try cache first
    final cached = await _db.findByBarcode(businessId, barcode);
    if (cached != null) return cached.toProduct();
    // fetch from API
    final product = await _ds.getByBarcode(businessId: businessId, barcode: barcode);
    await _db.upsertProducts([product.toCompanion()]);
    return product;
  }

  @override
  Future<Product> create({
    required String businessId,
    required String name,
    required double price,
    required String unit,
    String? barcode,
  }) async {
    final product = await _ds.create(
      businessId: businessId,
      name: name,
      price: price,
      unit: unit,
      barcode: barcode,
    );
    await _db.upsertProducts([product.toCompanion()]);
    return product;
  }

  @override
  Future<int> batchUpdatePrice(List<String> ids, double price) =>
      _ds.batchUpdatePrice(ids, price);

  @override
  Future<Product> update({
    required String id,
    required String name,
    required double price,
    required String unit,
    String? barcode,
  }) async {
    final product = await _ds.update(
      id: id,
      name: name,
      price: price,
      unit: unit,
      barcode: barcode,
    );
    await _db.upsertProducts([product.toCompanion()]);
    return product;
  }
}
