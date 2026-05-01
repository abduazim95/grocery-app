// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saleDetailHash() => r'0e3c60bc63c68185dbb1aa362d1dae4e0e723a75';

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

/// See also [saleDetail].
@ProviderFor(saleDetail)
const saleDetailProvider = SaleDetailFamily();

/// See also [saleDetail].
class SaleDetailFamily extends Family<AsyncValue<Sale>> {
  /// See also [saleDetail].
  const SaleDetailFamily();

  /// See also [saleDetail].
  SaleDetailProvider call(
    String id,
  ) {
    return SaleDetailProvider(
      id,
    );
  }

  @override
  SaleDetailProvider getProviderOverride(
    covariant SaleDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'saleDetailProvider';
}

/// See also [saleDetail].
class SaleDetailProvider extends AutoDisposeFutureProvider<Sale> {
  /// See also [saleDetail].
  SaleDetailProvider(
    String id,
  ) : this._internal(
          (ref) => saleDetail(
            ref as SaleDetailRef,
            id,
          ),
          from: saleDetailProvider,
          name: r'saleDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saleDetailHash,
          dependencies: SaleDetailFamily._dependencies,
          allTransitiveDependencies:
              SaleDetailFamily._allTransitiveDependencies,
          id: id,
        );

  SaleDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Sale> Function(SaleDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaleDetailProvider._internal(
        (ref) => create(ref as SaleDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Sale> createElement() {
    return _SaleDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaleDetailRef on AutoDisposeFutureProviderRef<Sale> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SaleDetailProviderElement extends AutoDisposeFutureProviderElement<Sale>
    with SaleDetailRef {
  _SaleDetailProviderElement(super.provider);

  @override
  String get id => (origin as SaleDetailProvider).id;
}

String _$salesListHash() => r'd5942db6a934762abf9fe1c660a531be11873bf7';

abstract class _$SalesList
    extends BuildlessAutoDisposeAsyncNotifier<SalesPageData> {
  late final String? storeId;

  FutureOr<SalesPageData> build(
    String? storeId,
  );
}

/// See also [SalesList].
@ProviderFor(SalesList)
const salesListProvider = SalesListFamily();

/// See also [SalesList].
class SalesListFamily extends Family<AsyncValue<SalesPageData>> {
  /// See also [SalesList].
  const SalesListFamily();

  /// See also [SalesList].
  SalesListProvider call(
    String? storeId,
  ) {
    return SalesListProvider(
      storeId,
    );
  }

  @override
  SalesListProvider getProviderOverride(
    covariant SalesListProvider provider,
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
  String? get name => r'salesListProvider';
}

/// See also [SalesList].
class SalesListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SalesList, SalesPageData> {
  /// See also [SalesList].
  SalesListProvider(
    String? storeId,
  ) : this._internal(
          () => SalesList()..storeId = storeId,
          from: salesListProvider,
          name: r'salesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$salesListHash,
          dependencies: SalesListFamily._dependencies,
          allTransitiveDependencies: SalesListFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  SalesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeId,
  }) : super.internal();

  final String? storeId;

  @override
  FutureOr<SalesPageData> runNotifierBuild(
    covariant SalesList notifier,
  ) {
    return notifier.build(
      storeId,
    );
  }

  @override
  Override overrideWith(SalesList Function() create) {
    return ProviderOverride(
      origin: this,
      override: SalesListProvider._internal(
        () => create()..storeId = storeId,
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
  AutoDisposeAsyncNotifierProviderElement<SalesList, SalesPageData>
      createElement() {
    return _SalesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesListProvider && other.storeId == storeId;
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
mixin SalesListRef on AutoDisposeAsyncNotifierProviderRef<SalesPageData> {
  /// The parameter `storeId` of this provider.
  String? get storeId;
}

class _SalesListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SalesList, SalesPageData>
    with SalesListRef {
  _SalesListProviderElement(super.provider);

  @override
  String? get storeId => (origin as SalesListProvider).storeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
