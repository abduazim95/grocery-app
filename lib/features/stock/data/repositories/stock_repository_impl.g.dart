// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockRepositoryHash() => r'ded836291c6153816b650b3d0ac6dd340938f4e3';

/// See also [stockRepository].
@ProviderFor(stockRepository)
final stockRepositoryProvider = AutoDisposeProvider<StockRemoteDs>.internal(
  stockRepository,
  name: r'stockRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stockRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StockRepositoryRef = AutoDisposeProviderRef<StockRemoteDs>;
String _$stockListHash() => r'792a310b86acafcea291ad58c7901c77d3900434';

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

/// See also [stockList].
@ProviderFor(stockList)
const stockListProvider = StockListFamily();

/// See also [stockList].
class StockListFamily extends Family<AsyncValue<List<StockItem>>> {
  /// See also [stockList].
  const StockListFamily();

  /// See also [stockList].
  StockListProvider call(
    String storeId,
  ) {
    return StockListProvider(
      storeId,
    );
  }

  @override
  StockListProvider getProviderOverride(
    covariant StockListProvider provider,
  ) {
    return call(
      provider.storeId,
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
  String? get name => r'stockListProvider';
}

/// See also [stockList].
class StockListProvider extends AutoDisposeFutureProvider<List<StockItem>> {
  /// See also [stockList].
  StockListProvider(
    String storeId,
  ) : this._internal(
          (ref) => stockList(
            ref as StockListRef,
            storeId,
          ),
          from: stockListProvider,
          name: r'stockListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockListHash,
          dependencies: StockListFamily._dependencies,
          allTransitiveDependencies: StockListFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  StockListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeId,
  }) : super.internal();

  final String storeId;

  @override
  Override overrideWith(
    FutureOr<List<StockItem>> Function(StockListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StockListProvider._internal(
        (ref) => create(ref as StockListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storeId: storeId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<StockItem>> createElement() {
    return _StockListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockListProvider && other.storeId == storeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StockListRef on AutoDisposeFutureProviderRef<List<StockItem>> {
  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _StockListProviderElement
    extends AutoDisposeFutureProviderElement<List<StockItem>>
    with StockListRef {
  _StockListProviderElement(super.provider);

  @override
  String get storeId => (origin as StockListProvider).storeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
