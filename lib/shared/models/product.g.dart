// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      isPerishable: json['is_perishable'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'barcode': instance.barcode,
      'price': instance.price,
      'unit': instance.unit,
      'is_perishable': instance.isPerishable,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
