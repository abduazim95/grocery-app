import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_batch.freezed.dart';
part 'stock_batch.g.dart';

@freezed
class StockBatch with _$StockBatch {
  const factory StockBatch({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'product_id') required String productId,
    required double quantity,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'received_at') required DateTime receivedAt,
  }) = _StockBatch;

  factory StockBatch.fromJson(Map<String, dynamic> json) => _$StockBatchFromJson(json);

  const StockBatch._();

  int get daysLeft => expiresAt.difference(DateTime.now()).inDays;
  bool get isExpired => daysLeft < 0;
  bool get isExpiring => daysLeft >= 0 && daysLeft <= 3;
}
