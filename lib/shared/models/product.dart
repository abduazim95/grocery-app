import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    String? barcode,
    required double price,
    required String unit,
    @Default(false) @JsonKey(name: 'is_perishable') bool isPerishable,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
