// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleImpl _$$SaleImplFromJson(Map<String, dynamic> json) => _$SaleImpl(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      sellerId: json['seller_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SaleImplToJson(_$SaleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'seller_id': instance.sellerId,
      'items': instance.items,
      'total': instance.total,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$SaleItemImpl _$$SaleItemImplFromJson(Map<String, dynamic> json) =>
    _$SaleItemImpl(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$SaleItemImplToJson(_$SaleItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'product': instance.product,
      'quantity': instance.quantity,
      'price': instance.price,
    };
