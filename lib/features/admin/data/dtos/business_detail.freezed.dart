// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessDetail _$BusinessDetailFromJson(Map<String, dynamic> json) {
  return _BusinessDetail.fromJson(json);
}

/// @nodoc
mixin _$BusinessDetail {
  Business get business => throw _privateConstructorUsedError;
  List<User> get managers => throw _privateConstructorUsedError;
  List<User> get sellers => throw _privateConstructorUsedError;
  List<Store> get stores => throw _privateConstructorUsedError;

  /// Serializes this BusinessDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessDetailCopyWith<BusinessDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessDetailCopyWith<$Res> {
  factory $BusinessDetailCopyWith(
          BusinessDetail value, $Res Function(BusinessDetail) then) =
      _$BusinessDetailCopyWithImpl<$Res, BusinessDetail>;
  @useResult
  $Res call(
      {Business business,
      List<User> managers,
      List<User> sellers,
      List<Store> stores});

  $BusinessCopyWith<$Res> get business;
}

/// @nodoc
class _$BusinessDetailCopyWithImpl<$Res, $Val extends BusinessDetail>
    implements $BusinessDetailCopyWith<$Res> {
  _$BusinessDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? business = null,
    Object? managers = null,
    Object? sellers = null,
    Object? stores = null,
  }) {
    return _then(_value.copyWith(
      business: null == business
          ? _value.business
          : business // ignore: cast_nullable_to_non_nullable
              as Business,
      managers: null == managers
          ? _value.managers
          : managers // ignore: cast_nullable_to_non_nullable
              as List<User>,
      sellers: null == sellers
          ? _value.sellers
          : sellers // ignore: cast_nullable_to_non_nullable
              as List<User>,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<Store>,
    ) as $Val);
  }

  /// Create a copy of BusinessDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusinessCopyWith<$Res> get business {
    return $BusinessCopyWith<$Res>(_value.business, (value) {
      return _then(_value.copyWith(business: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BusinessDetailImplCopyWith<$Res>
    implements $BusinessDetailCopyWith<$Res> {
  factory _$$BusinessDetailImplCopyWith(_$BusinessDetailImpl value,
          $Res Function(_$BusinessDetailImpl) then) =
      __$$BusinessDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Business business,
      List<User> managers,
      List<User> sellers,
      List<Store> stores});

  @override
  $BusinessCopyWith<$Res> get business;
}

/// @nodoc
class __$$BusinessDetailImplCopyWithImpl<$Res>
    extends _$BusinessDetailCopyWithImpl<$Res, _$BusinessDetailImpl>
    implements _$$BusinessDetailImplCopyWith<$Res> {
  __$$BusinessDetailImplCopyWithImpl(
      _$BusinessDetailImpl _value, $Res Function(_$BusinessDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusinessDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? business = null,
    Object? managers = null,
    Object? sellers = null,
    Object? stores = null,
  }) {
    return _then(_$BusinessDetailImpl(
      business: null == business
          ? _value.business
          : business // ignore: cast_nullable_to_non_nullable
              as Business,
      managers: null == managers
          ? _value._managers
          : managers // ignore: cast_nullable_to_non_nullable
              as List<User>,
      sellers: null == sellers
          ? _value._sellers
          : sellers // ignore: cast_nullable_to_non_nullable
              as List<User>,
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<Store>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessDetailImpl implements _BusinessDetail {
  const _$BusinessDetailImpl(
      {required this.business,
      required final List<User> managers,
      required final List<User> sellers,
      required final List<Store> stores})
      : _managers = managers,
        _sellers = sellers,
        _stores = stores;

  factory _$BusinessDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessDetailImplFromJson(json);

  @override
  final Business business;
  final List<User> _managers;
  @override
  List<User> get managers {
    if (_managers is EqualUnmodifiableListView) return _managers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_managers);
  }

  final List<User> _sellers;
  @override
  List<User> get sellers {
    if (_sellers is EqualUnmodifiableListView) return _sellers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sellers);
  }

  final List<Store> _stores;
  @override
  List<Store> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  @override
  String toString() {
    return 'BusinessDetail(business: $business, managers: $managers, sellers: $sellers, stores: $stores)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessDetailImpl &&
            (identical(other.business, business) ||
                other.business == business) &&
            const DeepCollectionEquality().equals(other._managers, _managers) &&
            const DeepCollectionEquality().equals(other._sellers, _sellers) &&
            const DeepCollectionEquality().equals(other._stores, _stores));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      business,
      const DeepCollectionEquality().hash(_managers),
      const DeepCollectionEquality().hash(_sellers),
      const DeepCollectionEquality().hash(_stores));

  /// Create a copy of BusinessDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessDetailImplCopyWith<_$BusinessDetailImpl> get copyWith =>
      __$$BusinessDetailImplCopyWithImpl<_$BusinessDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessDetailImplToJson(
      this,
    );
  }
}

abstract class _BusinessDetail implements BusinessDetail {
  const factory _BusinessDetail(
      {required final Business business,
      required final List<User> managers,
      required final List<User> sellers,
      required final List<Store> stores}) = _$BusinessDetailImpl;

  factory _BusinessDetail.fromJson(Map<String, dynamic> json) =
      _$BusinessDetailImpl.fromJson;

  @override
  Business get business;
  @override
  List<User> get managers;
  @override
  List<User> get sellers;
  @override
  List<Store> get stores;

  /// Create a copy of BusinessDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessDetailImplCopyWith<_$BusinessDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
