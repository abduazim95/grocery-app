// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DebtRecord _$DebtRecordFromJson(Map<String, dynamic> json) {
  return _DebtRecord.fromJson(json);
}

/// @nodoc
mixin _$DebtRecord {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'debtor_name')
  String get debtorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'debtor_phone')
  String? get debtorPhone => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: '')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: [])
  List<DebtPayment> get payments => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DebtRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebtRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtRecordCopyWith<DebtRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtRecordCopyWith<$Res> {
  factory $DebtRecordCopyWith(
          DebtRecord value, $Res Function(DebtRecord) then) =
      _$DebtRecordCopyWithImpl<$Res, DebtRecord>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'debtor_name') String debtorName,
      @JsonKey(name: 'debtor_phone') String? debtorPhone,
      double amount,
      @JsonKey(defaultValue: '') String description,
      @JsonKey(defaultValue: []) List<DebtPayment> payments,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$DebtRecordCopyWithImpl<$Res, $Val extends DebtRecord>
    implements $DebtRecordCopyWith<$Res> {
  _$DebtRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? debtorName = null,
    Object? debtorPhone = freezed,
    Object? amount = null,
    Object? description = null,
    Object? payments = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      debtorName: null == debtorName
          ? _value.debtorName
          : debtorName // ignore: cast_nullable_to_non_nullable
              as String,
      debtorPhone: freezed == debtorPhone
          ? _value.debtorPhone
          : debtorPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      payments: null == payments
          ? _value.payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<DebtPayment>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DebtRecordImplCopyWith<$Res>
    implements $DebtRecordCopyWith<$Res> {
  factory _$$DebtRecordImplCopyWith(
          _$DebtRecordImpl value, $Res Function(_$DebtRecordImpl) then) =
      __$$DebtRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'debtor_name') String debtorName,
      @JsonKey(name: 'debtor_phone') String? debtorPhone,
      double amount,
      @JsonKey(defaultValue: '') String description,
      @JsonKey(defaultValue: []) List<DebtPayment> payments,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$DebtRecordImplCopyWithImpl<$Res>
    extends _$DebtRecordCopyWithImpl<$Res, _$DebtRecordImpl>
    implements _$$DebtRecordImplCopyWith<$Res> {
  __$$DebtRecordImplCopyWithImpl(
      _$DebtRecordImpl _value, $Res Function(_$DebtRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? debtorName = null,
    Object? debtorPhone = freezed,
    Object? amount = null,
    Object? description = null,
    Object? payments = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$DebtRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      debtorName: null == debtorName
          ? _value.debtorName
          : debtorName // ignore: cast_nullable_to_non_nullable
              as String,
      debtorPhone: freezed == debtorPhone
          ? _value.debtorPhone
          : debtorPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      payments: null == payments
          ? _value._payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<DebtPayment>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebtRecordImpl extends _DebtRecord {
  const _$DebtRecordImpl(
      {required this.id,
      @JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'debtor_name') required this.debtorName,
      @JsonKey(name: 'debtor_phone') this.debtorPhone,
      required this.amount,
      @JsonKey(defaultValue: '') required this.description,
      @JsonKey(defaultValue: []) required final List<DebtPayment> payments,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _payments = payments,
        super._();

  factory _$DebtRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebtRecordImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'debtor_name')
  final String debtorName;
  @override
  @JsonKey(name: 'debtor_phone')
  final String? debtorPhone;
  @override
  final double amount;
  @override
  @JsonKey(defaultValue: '')
  final String description;
  final List<DebtPayment> _payments;
  @override
  @JsonKey(defaultValue: [])
  List<DebtPayment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DebtRecord(id: $id, storeId: $storeId, debtorName: $debtorName, debtorPhone: $debtorPhone, amount: $amount, description: $description, payments: $payments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.debtorName, debtorName) ||
                other.debtorName == debtorName) &&
            (identical(other.debtorPhone, debtorPhone) ||
                other.debtorPhone == debtorPhone) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      debtorName,
      debtorPhone,
      amount,
      description,
      const DeepCollectionEquality().hash(_payments),
      createdAt,
      updatedAt);

  /// Create a copy of DebtRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtRecordImplCopyWith<_$DebtRecordImpl> get copyWith =>
      __$$DebtRecordImplCopyWithImpl<_$DebtRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebtRecordImplToJson(
      this,
    );
  }
}

abstract class _DebtRecord extends DebtRecord {
  const factory _DebtRecord(
          {required final String id,
          @JsonKey(name: 'store_id') required final String storeId,
          @JsonKey(name: 'debtor_name') required final String debtorName,
          @JsonKey(name: 'debtor_phone') final String? debtorPhone,
          required final double amount,
          @JsonKey(defaultValue: '') required final String description,
          @JsonKey(defaultValue: []) required final List<DebtPayment> payments,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$DebtRecordImpl;
  const _DebtRecord._() : super._();

  factory _DebtRecord.fromJson(Map<String, dynamic> json) =
      _$DebtRecordImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'debtor_name')
  String get debtorName;
  @override
  @JsonKey(name: 'debtor_phone')
  String? get debtorPhone;
  @override
  double get amount;
  @override
  @JsonKey(defaultValue: '')
  String get description;
  @override
  @JsonKey(defaultValue: [])
  List<DebtPayment> get payments;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of DebtRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtRecordImplCopyWith<_$DebtRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DebtPayment _$DebtPaymentFromJson(Map<String, dynamic> json) {
  return _DebtPayment.fromJson(json);
}

/// @nodoc
mixin _$DebtPayment {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'debt_record_id')
  String get debtRecordId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: '')
  String get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DebtPayment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebtPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebtPaymentCopyWith<DebtPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebtPaymentCopyWith<$Res> {
  factory $DebtPaymentCopyWith(
          DebtPayment value, $Res Function(DebtPayment) then) =
      _$DebtPaymentCopyWithImpl<$Res, DebtPayment>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'debt_record_id') String debtRecordId,
      double amount,
      @JsonKey(defaultValue: '') String note,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$DebtPaymentCopyWithImpl<$Res, $Val extends DebtPayment>
    implements $DebtPaymentCopyWith<$Res> {
  _$DebtPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebtPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? debtRecordId = null,
    Object? amount = null,
    Object? note = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      debtRecordId: null == debtRecordId
          ? _value.debtRecordId
          : debtRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DebtPaymentImplCopyWith<$Res>
    implements $DebtPaymentCopyWith<$Res> {
  factory _$$DebtPaymentImplCopyWith(
          _$DebtPaymentImpl value, $Res Function(_$DebtPaymentImpl) then) =
      __$$DebtPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'debt_record_id') String debtRecordId,
      double amount,
      @JsonKey(defaultValue: '') String note,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$DebtPaymentImplCopyWithImpl<$Res>
    extends _$DebtPaymentCopyWithImpl<$Res, _$DebtPaymentImpl>
    implements _$$DebtPaymentImplCopyWith<$Res> {
  __$$DebtPaymentImplCopyWithImpl(
      _$DebtPaymentImpl _value, $Res Function(_$DebtPaymentImpl) _then)
      : super(_value, _then);

  /// Create a copy of DebtPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? debtRecordId = null,
    Object? amount = null,
    Object? note = null,
    Object? createdAt = null,
  }) {
    return _then(_$DebtPaymentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      debtRecordId: null == debtRecordId
          ? _value.debtRecordId
          : debtRecordId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DebtPaymentImpl implements _DebtPayment {
  const _$DebtPaymentImpl(
      {required this.id,
      @JsonKey(name: 'debt_record_id') required this.debtRecordId,
      required this.amount,
      @JsonKey(defaultValue: '') required this.note,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$DebtPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebtPaymentImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'debt_record_id')
  final String debtRecordId;
  @override
  final double amount;
  @override
  @JsonKey(defaultValue: '')
  final String note;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'DebtPayment(id: $id, debtRecordId: $debtRecordId, amount: $amount, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebtPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.debtRecordId, debtRecordId) ||
                other.debtRecordId == debtRecordId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, debtRecordId, amount, note, createdAt);

  /// Create a copy of DebtPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebtPaymentImplCopyWith<_$DebtPaymentImpl> get copyWith =>
      __$$DebtPaymentImplCopyWithImpl<_$DebtPaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebtPaymentImplToJson(
      this,
    );
  }
}

abstract class _DebtPayment implements DebtPayment {
  const factory _DebtPayment(
          {required final String id,
          @JsonKey(name: 'debt_record_id') required final String debtRecordId,
          required final double amount,
          @JsonKey(defaultValue: '') required final String note,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$DebtPaymentImpl;

  factory _DebtPayment.fromJson(Map<String, dynamic> json) =
      _$DebtPaymentImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'debt_record_id')
  String get debtRecordId;
  @override
  double get amount;
  @override
  @JsonKey(defaultValue: '')
  String get note;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of DebtPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebtPaymentImplCopyWith<_$DebtPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
