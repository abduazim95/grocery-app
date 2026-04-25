// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DebtRecordImpl _$$DebtRecordImplFromJson(Map<String, dynamic> json) =>
    _$DebtRecordImpl(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      debtorName: json['debtor_name'] as String,
      debtorPhone: json['debtor_phone'] as String?,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      payments: (json['payments'] as List<dynamic>?)
              ?.map((e) => DebtPayment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$DebtRecordImplToJson(_$DebtRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'debtor_name': instance.debtorName,
      'debtor_phone': instance.debtorPhone,
      'amount': instance.amount,
      'description': instance.description,
      'payments': instance.payments,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$DebtPaymentImpl _$$DebtPaymentImplFromJson(Map<String, dynamic> json) =>
    _$DebtPaymentImpl(
      id: json['id'] as String,
      debtRecordId: json['debt_record_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$DebtPaymentImplToJson(_$DebtPaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'debt_record_id': instance.debtRecordId,
      'amount': instance.amount,
      'note': instance.note,
      'created_at': instance.createdAt.toIso8601String(),
    };
