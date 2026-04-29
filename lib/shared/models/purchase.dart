import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocery/shared/models/product.dart';

part 'purchase.freezed.dart';
part 'purchase.g.dart';

enum PurchaseStatus {
  @JsonValue('open')
  open,
  @JsonValue('closed')
  closed,
}

@freezed
class PurchaseOrder with _$PurchaseOrder {
  const factory PurchaseOrder({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'creator_id') required String creatorId,
    required PurchaseStatus status,
    @JsonKey(defaultValue: []) required List<PurchaseOrderItem> items,
    @JsonKey(name: 'closed_at') DateTime? closedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PurchaseOrder;

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderFromJson(json);
}

@freezed
class PurchaseOrderItem with _$PurchaseOrderItem {
  const factory PurchaseOrderItem({
    required String id,
    @JsonKey(name: 'purchase_order_id') required String purchaseOrderId,
    @JsonKey(name: 'product_id') required String productId,
    Product? product,
    required double quantity,
    required double price,
    @JsonKey(name: 'is_bought', defaultValue: false) required bool isBought,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _PurchaseOrderItem;

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderItemFromJson(json);
}
