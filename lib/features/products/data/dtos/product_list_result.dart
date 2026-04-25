import 'package:grocery/shared/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_list_result.g.dart';

@JsonSerializable()
class ProductListResult {
  final List<Product> products;
  final int total;
  final int page;
  @JsonKey(name: 'page_size')
  final int pageSize;

  const ProductListResult({
    required this.products,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory ProductListResult.fromJson(Map<String, dynamic> json) =>
      _$ProductListResultFromJson(json);
}
