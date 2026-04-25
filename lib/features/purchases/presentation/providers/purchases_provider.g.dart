// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchases_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$purchasesListHash() => r'01f3722e6d1c73f475cccf6fb9150d487ccca545';

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

/// See also [purchasesList].
@ProviderFor(purchasesList)
const purchasesListProvider = PurchasesListFamily();

/// See also [purchasesList].
class PurchasesListFamily extends Family<AsyncValue<List<PurchaseOrder>>> {
  /// See also [purchasesList].
  const PurchasesListFamily();

  /// See also [purchasesList].
  PurchasesListProvider call({
    String? storeId,
  }) {
    return PurchasesListProvider(
      storeId: storeId,
    );
  }

  @override
  PurchasesListProvider getProviderOverride(
    covariant PurchasesListProvider provider,
  ) {
    return call(
      storeId: provider.storeId,
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
  String? get name => r'purchasesListProvider';
}

/// See also [purchasesList].
class PurchasesListProvider
    extends AutoDisposeFutureProvider<List<PurchaseOrder>> {
  /// See also [purchasesList].
  PurchasesListProvider({
    String? storeId,
  }) : this._internal(
          (ref) => purchasesList(
            ref as PurchasesListRef,
            storeId: storeId,
          ),
          from: purchasesListProvider,
          name: r'purchasesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$purchasesListHash,
          dependencies: PurchasesListFamily._dependencies,
          allTransitiveDependencies:
              PurchasesListFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  PurchasesListProvider._internal(
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
  Override overrideWith(
    FutureOr<List<PurchaseOrder>> Function(PurchasesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PurchasesListProvider._internal(
        (ref) => create(ref as PurchasesListRef),
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
  AutoDisposeFutureProviderElement<List<PurchaseOrder>> createElement() {
    return _PurchasesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchasesListProvider && other.storeId == storeId;
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
mixin PurchasesListRef on AutoDisposeFutureProviderRef<List<PurchaseOrder>> {
  /// The parameter `storeId` of this provider.
  String? get storeId;
}

class _PurchasesListProviderElement
    extends AutoDisposeFutureProviderElement<List<PurchaseOrder>>
    with PurchasesListRef {
  _PurchasesListProviderElement(super.provider);

  @override
  String? get storeId => (origin as PurchasesListProvider).storeId;
}

String _$purchaseDetailHash() => r'2ac89d9f87aad5490b2fdeba64d77f8fe25e6165';

abstract class _$PurchaseDetail
    extends BuildlessAutoDisposeAsyncNotifier<PurchaseOrder> {
  late final String id;

  FutureOr<PurchaseOrder> build(
    String id,
  );
}

/// See also [PurchaseDetail].
@ProviderFor(PurchaseDetail)
const purchaseDetailProvider = PurchaseDetailFamily();

/// See also [PurchaseDetail].
class PurchaseDetailFamily extends Family<AsyncValue<PurchaseOrder>> {
  /// See also [PurchaseDetail].
  const PurchaseDetailFamily();

  /// See also [PurchaseDetail].
  PurchaseDetailProvider call(
    String id,
  ) {
    return PurchaseDetailProvider(
      id,
    );
  }

  @override
  PurchaseDetailProvider getProviderOverride(
    covariant PurchaseDetailProvider provider,
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
  String? get name => r'purchaseDetailProvider';
}

/// See also [PurchaseDetail].
class PurchaseDetailProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PurchaseDetail, PurchaseOrder> {
  /// See also [PurchaseDetail].
  PurchaseDetailProvider(
    String id,
  ) : this._internal(
          () => PurchaseDetail()..id = id,
          from: purchaseDetailProvider,
          name: r'purchaseDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$purchaseDetailHash,
          dependencies: PurchaseDetailFamily._dependencies,
          allTransitiveDependencies:
              PurchaseDetailFamily._allTransitiveDependencies,
          id: id,
        );

  PurchaseDetailProvider._internal(
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
  FutureOr<PurchaseOrder> runNotifierBuild(
    covariant PurchaseDetail notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(PurchaseDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: PurchaseDetailProvider._internal(
        () => create()..id = id,
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
  AutoDisposeAsyncNotifierProviderElement<PurchaseDetail, PurchaseOrder>
      createElement() {
    return _PurchaseDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseDetailProvider && other.id == id;
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
mixin PurchaseDetailRef on AutoDisposeAsyncNotifierProviderRef<PurchaseOrder> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PurchaseDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PurchaseDetail,
        PurchaseOrder> with PurchaseDetailRef {
  _PurchaseDetailProviderElement(super.provider);

  @override
  String get id => (origin as PurchaseDetailProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
