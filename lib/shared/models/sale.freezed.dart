// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Sale _$SaleFromJson(Map<String, dynamic> json) {
  return _Sale.fromJson(json);
}

/// @nodoc
mixin _$Sale {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'seller_id')
  String get sellerId => throw _privateConstructorUsedError;
  List<SaleItem> get items => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Sale to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleCopyWith<Sale> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleCopyWith<$Res> {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) then) =
      _$SaleCopyWithImpl<$Res, Sale>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'seller_id') String sellerId,
      List<SaleItem> items,
      double total,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$SaleCopyWithImpl<$Res, $Val extends Sale>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? sellerId = null,
    Object? items = null,
    Object? total = null,
    Object? createdAt = null,
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
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SaleItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SaleImplCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$$SaleImplCopyWith(
          _$SaleImpl value, $Res Function(_$SaleImpl) then) =
      __$$SaleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'seller_id') String sellerId,
      List<SaleItem> items,
      double total,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$SaleImplCopyWithImpl<$Res>
    extends _$SaleCopyWithImpl<$Res, _$SaleImpl>
    implements _$$SaleImplCopyWith<$Res> {
  __$$SaleImplCopyWithImpl(_$SaleImpl _value, $Res Function(_$SaleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? storeId = null,
    Object? sellerId = null,
    Object? items = null,
    Object? total = null,
    Object? createdAt = null,
  }) {
    return _then(_$SaleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SaleItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleImpl implements _Sale {
  const _$SaleImpl(
      {required this.id,
      @JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'seller_id') required this.sellerId,
      required final List<SaleItem> items,
      required this.total,
      @JsonKey(name: 'created_at') required this.createdAt})
      : _items = items;

  factory _$SaleImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'seller_id')
  final String sellerId;
  final List<SaleItem> _items;
  @override
  List<SaleItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double total;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'Sale(id: $id, storeId: $storeId, sellerId: $sellerId, items: $items, total: $total, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storeId, sellerId,
      const DeepCollectionEquality().hash(_items), total, createdAt);

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleImplCopyWith<_$SaleImpl> get copyWith =>
      __$$SaleImplCopyWithImpl<_$SaleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleImplToJson(
      this,
    );
  }
}

abstract class _Sale implements Sale {
  const factory _Sale(
          {required final String id,
          @JsonKey(name: 'store_id') required final String storeId,
          @JsonKey(name: 'seller_id') required final String sellerId,
          required final List<SaleItem> items,
          required final double total,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$SaleImpl;

  factory _Sale.fromJson(Map<String, dynamic> json) = _$SaleImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'seller_id')
  String get sellerId;
  @override
  List<SaleItem> get items;
  @override
  double get total;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of Sale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleImplCopyWith<_$SaleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleItem _$SaleItemFromJson(Map<String, dynamic> json) {
  return _SaleItem.fromJson(json);
}

/// @nodoc
mixin _$SaleItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  Product? get product => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this SaleItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleItemCopyWith<SaleItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleItemCopyWith<$Res> {
  factory $SaleItemCopyWith(SaleItem value, $Res Function(SaleItem) then) =
      _$SaleItemCopyWithImpl<$Res, SaleItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'product_id') String productId,
      Product? product,
      double quantity,
      double price});

  $ProductCopyWith<$Res>? get product;
}

/// @nodoc
class _$SaleItemCopyWithImpl<$Res, $Val extends SaleItem>
    implements $SaleItemCopyWith<$Res> {
  _$SaleItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? product = freezed,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res>? get product {
    if (_value.product == null) {
      return null;
    }

    return $ProductCopyWith<$Res>(_value.product!, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SaleItemImplCopyWith<$Res>
    implements $SaleItemCopyWith<$Res> {
  factory _$$SaleItemImplCopyWith(
          _$SaleItemImpl value, $Res Function(_$SaleItemImpl) then) =
      __$$SaleItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'product_id') String productId,
      Product? product,
      double quantity,
      double price});

  @override
  $ProductCopyWith<$Res>? get product;
}

/// @nodoc
class __$$SaleItemImplCopyWithImpl<$Res>
    extends _$SaleItemCopyWithImpl<$Res, _$SaleItemImpl>
    implements _$$SaleItemImplCopyWith<$Res> {
  __$$SaleItemImplCopyWithImpl(
      _$SaleItemImpl _value, $Res Function(_$SaleItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? product = freezed,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(_$SaleItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleItemImpl implements _SaleItem {
  const _$SaleItemImpl(
      {required this.id,
      @JsonKey(name: 'product_id') required this.productId,
      this.product,
      required this.quantity,
      required this.price});

  factory _$SaleItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  final Product? product;
  @override
  final double quantity;
  @override
  final double price;

  @override
  String toString() {
    return 'SaleItem(id: $id, productId: $productId, product: $product, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, productId, product, quantity, price);

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleItemImplCopyWith<_$SaleItemImpl> get copyWith =>
      __$$SaleItemImplCopyWithImpl<_$SaleItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleItemImplToJson(
      this,
    );
  }
}

abstract class _SaleItem implements SaleItem {
  const factory _SaleItem(
      {required final String id,
      @JsonKey(name: 'product_id') required final String productId,
      final Product? product,
      required final double quantity,
      required final double price}) = _$SaleItemImpl;

  factory _SaleItem.fromJson(Map<String, dynamic> json) =
      _$SaleItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  Product? get product;
  @override
  double get quantity;
  @override
  double get price;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleItemImplCopyWith<_$SaleItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SaleItemDraft {
  Product get product => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;

  /// Create a copy of SaleItemDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleItemDraftCopyWith<SaleItemDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleItemDraftCopyWith<$Res> {
  factory $SaleItemDraftCopyWith(
          SaleItemDraft value, $Res Function(SaleItemDraft) then) =
      _$SaleItemDraftCopyWithImpl<$Res, SaleItemDraft>;
  @useResult
  $Res call({Product product, double quantity});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class _$SaleItemDraftCopyWithImpl<$Res, $Val extends SaleItemDraft>
    implements $SaleItemDraftCopyWith<$Res> {
  _$SaleItemDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleItemDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of SaleItemDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SaleItemDraftImplCopyWith<$Res>
    implements $SaleItemDraftCopyWith<$Res> {
  factory _$$SaleItemDraftImplCopyWith(
          _$SaleItemDraftImpl value, $Res Function(_$SaleItemDraftImpl) then) =
      __$$SaleItemDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Product product, double quantity});

  @override
  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$SaleItemDraftImplCopyWithImpl<$Res>
    extends _$SaleItemDraftCopyWithImpl<$Res, _$SaleItemDraftImpl>
    implements _$$SaleItemDraftImplCopyWith<$Res> {
  __$$SaleItemDraftImplCopyWithImpl(
      _$SaleItemDraftImpl _value, $Res Function(_$SaleItemDraftImpl) _then)
      : super(_value, _then);

  /// Create a copy of SaleItemDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
    Object? quantity = null,
  }) {
    return _then(_$SaleItemDraftImpl(
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$SaleItemDraftImpl extends _SaleItemDraft {
  const _$SaleItemDraftImpl({required this.product, required this.quantity})
      : super._();

  @override
  final Product product;
  @override
  final double quantity;

  @override
  String toString() {
    return 'SaleItemDraft(product: $product, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleItemDraftImpl &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product, quantity);

  /// Create a copy of SaleItemDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleItemDraftImplCopyWith<_$SaleItemDraftImpl> get copyWith =>
      __$$SaleItemDraftImplCopyWithImpl<_$SaleItemDraftImpl>(this, _$identity);
}

abstract class _SaleItemDraft extends SaleItemDraft {
  const factory _SaleItemDraft(
      {required final Product product,
      required final double quantity}) = _$SaleItemDraftImpl;
  const _SaleItemDraft._() : super._();

  @override
  Product get product;
  @override
  double get quantity;

  /// Create a copy of SaleItemDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleItemDraftImplCopyWith<_$SaleItemDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
