// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_product_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productFromCacheHash() => r'fac24a6923835b9539b5ac2606bb6a853df113bb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productFromCache].
@ProviderFor(productFromCache)
const productFromCacheProvider = ProductFromCacheFamily();

/// See also [productFromCache].
class ProductFromCacheFamily extends Family<AsyncValue<Product?>> {
  /// See also [productFromCache].
  const ProductFromCacheFamily();

  /// See also [productFromCache].
  ProductFromCacheProvider call(
    String businessId,
    String productId,
  ) {
    return ProductFromCacheProvider(
      businessId,
      productId,
    );
  }

  @override
  ProductFromCacheProvider getProviderOverride(
    covariant ProductFromCacheProvider provider,
  ) {
    return call(
      provider.businessId,
      provider.productId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productFromCacheProvider';
}

/// See also [productFromCache].
class ProductFromCacheProvider extends AutoDisposeFutureProvider<Product?> {
  /// See also [productFromCache].
  ProductFromCacheProvider(
    String businessId,
    String productId,
  ) : this._internal(
          (ref) => productFromCache(
            ref as ProductFromCacheRef,
            businessId,
            productId,
          ),
          from: productFromCacheProvider,
          name: r'productFromCacheProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productFromCacheHash,
          dependencies: ProductFromCacheFamily._dependencies,
          allTransitiveDependencies:
              ProductFromCacheFamily._allTransitiveDependencies,
          businessId: businessId,
          productId: productId,
        );

  ProductFromCacheProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessId,
    required this.productId,
  }) : super.internal();

  final String businessId;
  final String productId;

  @override
  Override overrideWith(
    FutureOr<Product?> Function(ProductFromCacheRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductFromCacheProvider._internal(
        (ref) => create(ref as ProductFromCacheRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessId: businessId,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Product?> createElement() {
    return _ProductFromCacheProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductFromCacheProvider &&
        other.businessId == businessId &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessId.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductFromCacheRef on AutoDisposeFutureProviderRef<Product?> {
  /// The parameter `businessId` of this provider.
  String get businessId;

  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductFromCacheProviderElement
    extends AutoDisposeFutureProviderElement<Product?>
    with ProductFromCacheRef {
  _ProductFromCacheProviderElement(super.provider);

  @override
  String get businessId => (origin as ProductFromCacheProvider).businessId;
  @override
  String get productId => (origin as ProductFromCacheProvider).productId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
