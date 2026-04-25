import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt.freezed.dart';
part 'debt.g.dart';

@freezed
class DebtRecord with _$DebtRecord {
  const factory DebtRecord({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'debtor_name') required String debtorName,
    @JsonKey(name: 'debtor_phone') String? debtorPhone,
    required double amount,
    @JsonKey(defaultValue: '') required String description,
    @JsonKey(defaultValue: []) required List<DebtPayment> payments,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DebtRecord;

  factory DebtRecord.fromJson(Map<String, dynamic> json) =>
      _$DebtRecordFromJson(json);

  const DebtRecord._();

  bool get isPaid => amount <= 0;
}

@freezed
class DebtPayment with _$DebtPayment {
  const factory DebtPayment({
    required String id,
    @JsonKey(name: 'debt_record_id') required String debtRecordId,
    required double amount,
    @JsonKey(defaultValue: '') required String note,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _DebtPayment;

  factory DebtPayment.fromJson(Map<String, dynamic> json) =>
      _$DebtPaymentFromJson(json);
}
