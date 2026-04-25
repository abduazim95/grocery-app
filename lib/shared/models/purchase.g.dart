// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseOrderImpl _$$PurchaseOrderImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseOrderImpl(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      creatorId: json['creator_id'] as String,
      status: $enumDecode(_$PurchaseStatusEnumMap, json['status']),
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => PurchaseOrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PurchaseOrderImplToJson(_$PurchaseOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'creator_id': instance.creatorId,
      'status': _$PurchaseStatusEnumMap[instance.status]!,
      'items': instance.items,
      'closed_at': instance.closedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$PurchaseStatusEnumMap = {
  PurchaseStatus.open: 'open',
  PurchaseStatus.closed: 'closed',
};

_$PurchaseOrderItemImpl _$$PurchaseOrderItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseOrderItemImpl(
      id: json['id'] as String,
      purchaseOrderId: json['purchase_order_id'] as String,
      productId: json['product_id'] as String,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      isBought: json['is_bought'] as bool? ?? false,
    );

Map<String, dynamic> _$$PurchaseOrderItemImplToJson(
        _$PurchaseOrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchase_order_id': instance.purchaseOrderId,
      'product_id': instance.productId,
      'product': instance.product,
      'quantity': instance.quantity,
      'price': instance.price,
      'is_bought': instance.isBought,
    };
