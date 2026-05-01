import 'package:grocery/shared/models/sale.dart';

abstract interface class SaleRepository {
  Future<List<Sale>> listSales({
    String? storeId,
    int page,
    int limit,
    DateTime? from,
    DateTime? to,
  });
  Future<Sale> getSaleById(String id);
  Future<Sale> createSale({
    String? storeId,
    required List<SaleItemDraft> items,
  });
}
