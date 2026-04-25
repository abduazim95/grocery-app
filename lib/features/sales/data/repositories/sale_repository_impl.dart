import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/sales/data/data_sources/sale_remote_ds.dart';
import 'package:grocery/features/sales/domain/repositories/sale_repository.dart';
import 'package:grocery/shared/models/sale.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sale_repository_impl.g.dart';

@riverpod
SaleRepository saleRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  return _SaleRepositoryImpl(SaleRemoteDs(client));
}

class _SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDs _ds;

  _SaleRepositoryImpl(this._ds);

  @override
  Future<List<Sale>> listSales({required String storeId}) =>
      _ds.listSales(storeId: storeId);

  @override
  Future<Sale> createSale({
    required String storeId,
    required List<SaleItemDraft> items,
  }) =>
      _ds.createSale(
        storeId: storeId,
        items: items
            .map((i) => {'product_id': i.product.id, 'quantity': i.quantity})
            .toList(),
      );
}
