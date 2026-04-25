import 'package:grocery/shared/models/sale.dart';

abstract interface class SaleRepository {
  Future<List<Sale>> listSales({required String storeId});
  Future<Sale> createSale({
    required String storeId,
    required List<SaleItemDraft> items,
  });
}
