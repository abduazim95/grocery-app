import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocery/shared/models/product.dart';

part 'sale.freezed.dart';
part 'sale.g.dart';

@freezed
class Sale with _$Sale {
  const factory Sale({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'seller_id') required String sellerId,
    required List<SaleItem> items,
    required double total,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class SaleItem with _$SaleItem {
  const factory SaleItem({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    Product? product,
    required double quantity,
    required double price,
  }) = _SaleItem;

  factory SaleItem.fromJson(Map<String, dynamic> json) => _$SaleItemFromJson(json);
}

@freezed
class SaleItemDraft with _$SaleItemDraft {
  const factory SaleItemDraft({
    required Product product,
    required double quantity,
  }) = _SaleItemDraft;

  const SaleItemDraft._();

  double get subtotal => product.price * quantity;
}
