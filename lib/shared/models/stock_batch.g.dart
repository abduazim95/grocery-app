// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockBatchImpl _$$StockBatchImplFromJson(Map<String, dynamic> json) =>
    _$StockBatchImpl(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      receivedAt: DateTime.parse(json['received_at'] as String),
    );

Map<String, dynamic> _$$StockBatchImplToJson(_$StockBatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'expires_at': instance.expiresAt.toIso8601String(),
      'received_at': instance.receivedAt.toIso8601String(),
    };
