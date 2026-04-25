// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsListNotifierHash() =>
    r'6919c206336212918b2eb0ff554ccfca4d5c6361';

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

abstract class _$ProductsListNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ProductListState> {
  late final String storeId;
  late final String query;

  FutureOr<ProductListState> build(
    String storeId, {
    String query = '',
  });
}

/// See also [ProductsListNotifier].
@ProviderFor(ProductsListNotifier)
const productsListNotifierProvider = ProductsListNotifierFamily();

/// See also [ProductsListNotifier].
class ProductsListNotifierFamily extends Family<AsyncValue<ProductListState>> {
  /// See also [ProductsListNotifier].
  const ProductsListNotifierFamily();

  /// See also [ProductsListNotifier].
  ProductsListNotifierProvider call(
    String storeId, {
    String query = '',
  }) {
    return ProductsListNotifierProvider(
      storeId,
      query: query,
    );
  }

  @override
  ProductsListNotifierProvider getProviderOverride(
    covariant ProductsListNotifierProvider provider,
  ) {
    return call(
      provider.storeId,
      query: provider.query,
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
  String? get name => r'productsListNotifierProvider';
}

/// See also [ProductsListNotifier].
class ProductsListNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ProductsListNotifier, ProductListState> {
  /// See also [ProductsListNotifier].
  ProductsListNotifierProvider(
    String storeId, {
    String query = '',
  }) : this._internal(
          () => ProductsListNotifier()
            ..storeId = storeId
            ..query = query,
          from: productsListNotifierProvider,
          name: r'productsListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsListNotifierHash,
          dependencies: ProductsListNotifierFamily._dependencies,
          allTransitiveDependencies:
              ProductsListNotifierFamily._allTransitiveDependencies,
          storeId: storeId,
          query: query,
        );

  ProductsListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeId,
    required this.query,
  }) : super.internal();

  final String storeId;
  final String query;

  @override
  FutureOr<ProductListState> runNotifierBuild(
    covariant ProductsListNotifier notifier,
  ) {
    return notifier.build(
      storeId,
      query: query,
    );
  }

  @override
  Override overrideWith(ProductsListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductsListNotifierProvider._internal(
        () => create()
          ..storeId = storeId
          ..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storeId: storeId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProductsListNotifier,
      ProductListState> createElement() {
    return _ProductsListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsListNotifierProvider &&
        other.storeId == storeId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductsListNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ProductListState> {
  /// The parameter `storeId` of this provider.
  String get storeId;

  /// The parameter `query` of this provider.
  String get query;
}

class _ProductsListNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ProductsListNotifier,
        ProductListState> with ProductsListNotifierRef {
  _ProductsListNotifierProviderElement(super.provider);

  @override
  String get storeId => (origin as ProductsListNotifierProvider).storeId;
  @override
  String get query => (origin as ProductsListNotifierProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
