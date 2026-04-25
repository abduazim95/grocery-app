import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocery/shared/models/product.dart';

part 'stock_item.freezed.dart';
part 'stock_item.g.dart';

@freezed
class StockItem with _$StockItem {
  const factory StockItem({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'product_id') required String productId,
    Product? product,
    required double quantity,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _StockItem;

  factory StockItem.fromJson(Map<String, dynamic> json) =>
      _$StockItemFromJson(json);
}
