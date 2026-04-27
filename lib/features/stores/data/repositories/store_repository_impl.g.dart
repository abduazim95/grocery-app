// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storeRepositoryHash() => r'87e699ea7fbef45bf8a02fd3cd91c18182cab490';

/// See also [storeRepository].
@ProviderFor(storeRepository)
final storeRepositoryProvider = AutoDisposeProvider<StoreRemoteDs>.internal(
  storeRepository,
  name: r'storeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreRepositoryRef = AutoDisposeProviderRef<StoreRemoteDs>;
String _$storesListHash() => r'a858dc307f944921b4be87ba2cf416962a1a66dd';

/// See also [storesList].
@ProviderFor(storesList)
final storesListProvider = AutoDisposeFutureProvider<List<Store>>.internal(
  storesList,
  name: r'storesListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$storesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoresListRef = AutoDisposeFutureProviderRef<List<Store>>;

String _$storeSellersHash() => r'b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2';

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

/// See also [storeSellers].
@ProviderFor(storeSellers)
const storeSellersProvider = StoreSellersFamily();

/// See also [storeSellers].
class StoreSellersFamily extends Family<AsyncValue<List<User>>> {
  /// See also [storeSellers].
  const StoreSellersFamily();

  /// See also [storeSellers].
  StoreSellersProvider call(String storeId) {
    return StoreSellersProvider(storeId);
  }

  @override
  StoreSellersProvider getProviderOverride(
    covariant StoreSellersProvider provider,
  ) {
    return call(provider.storeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storeSellersProvider';
}

/// See also [storeSellers].
class StoreSellersProvider extends AutoDisposeFutureProvider<List<User>> {
  /// See also [storeSellers].
  StoreSellersProvider(String storeId)
      : this._internal(
          (ref) => storeSellers(ref as StoreSellersRef, storeId),
          from: storeSellersProvider,
          name: r'storeSellersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storeSellersHash,
          dependencies: StoreSellersFamily._dependencies,
          allTransitiveDependencies:
              StoreSellersFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  StoreSellersProvider._internal(
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
    FutureOr<List<User>> Function(StoreSellersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoreSellersProvider._internal(
        (ref) => create(ref as StoreSellersRef),
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
  AutoDisposeFutureProviderElement<List<User>> createElement() {
    return _StoreSellersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoreSellersProvider && other.storeId == storeId;
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
mixin StoreSellersRef on AutoDisposeFutureProviderRef<List<User>> {
  String get storeId;
}

class _StoreSellersProviderElement
    extends AutoDisposeFutureProviderElement<List<User>>
    with StoreSellersRef {
  _StoreSellersProviderElement(super.provider);

  @override
  String get storeId => (origin as StoreSellersProvider).storeId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
