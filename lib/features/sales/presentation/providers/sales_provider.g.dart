// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$salesListHash() => r'f6f3a38e257a14c22d9da0e8dea90d8345060bba';

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

/// See also [salesList].
@ProviderFor(salesList)
const salesListProvider = SalesListFamily();

/// See also [salesList].
class SalesListFamily extends Family<AsyncValue<List<Sale>>> {
  /// See also [salesList].
  const SalesListFamily();

  /// See also [salesList].
  SalesListProvider call(
    String storeId,
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

/// See also [salesList].
class SalesListProvider extends AutoDisposeFutureProvider<List<Sale>> {
  /// See also [salesList].
  SalesListProvider(
    String storeId,
  ) : this._internal(
          (ref) => salesList(
            ref as SalesListRef,
            storeId,
          ),
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

  final String storeId;

  @override
  Override overrideWith(
    FutureOr<List<Sale>> Function(SalesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SalesListProvider._internal(
        (ref) => create(ref as SalesListRef),
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
  AutoDisposeFutureProviderElement<List<Sale>> createElement() {
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
mixin SalesListRef on AutoDisposeFutureProviderRef<List<Sale>> {
  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _SalesListProviderElement
    extends AutoDisposeFutureProviderElement<List<Sale>> with SalesListRef {
  _SalesListProviderElement(super.provider);

  @override
  String get storeId => (origin as SalesListProvider).storeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
