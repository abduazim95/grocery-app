// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListResult _$ProductListResultFromJson(Map<String, dynamic> json) =>
    ProductListResult(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
    );

Map<String, dynamic> _$ProductListResultToJson(ProductListResult instance) =>
    <String, dynamic>{
      'products': instance.products,
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.pageSize,
    };
