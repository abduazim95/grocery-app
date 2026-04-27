// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchases_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$purchasesListHash() => r'44240cd64419ff9bac8e48ef209e7c951d37ba18';

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

abstract class _$PurchasesList
    extends BuildlessAutoDisposeAsyncNotifier<PurchasesPageData> {
  late final String? storeId;
  late final String? status;

  FutureOr<PurchasesPageData> build({
    String? storeId,
    String? status,
  });
}

/// See also [PurchasesList].
@ProviderFor(PurchasesList)
const purchasesListProvider = PurchasesListFamily();

/// See also [PurchasesList].
class PurchasesListFamily extends Family<AsyncValue<PurchasesPageData>> {
  /// See also [PurchasesList].
  const PurchasesListFamily();

  /// See also [PurchasesList].
  PurchasesListProvider call({
    String? storeId,
    String? status,
  }) {
    return PurchasesListProvider(
      storeId: storeId,
      status: status,
    );
  }

  @override
  PurchasesListProvider getProviderOverride(
    covariant PurchasesListProvider provider,
  ) {
    return call(
      storeId: provider.storeId,
      status: provider.status,
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

/// See also [PurchasesList].
class PurchasesListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PurchasesList, PurchasesPageData> {
  /// See also [PurchasesList].
  PurchasesListProvider({
    String? storeId,
    String? status,
  }) : this._internal(
          () => PurchasesList()
            ..storeId = storeId
            ..status = status,
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
          status: status,
        );

  PurchasesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeId,
    required this.status,
  }) : super.internal();

  final String? storeId;
  final String? status;

  @override
  FutureOr<PurchasesPageData> runNotifierBuild(
    covariant PurchasesList notifier,
  ) {
    return notifier.build(
      storeId: storeId,
      status: status,
    );
  }

  @override
  Override overrideWith(PurchasesList Function() create) {
    return ProviderOverride(
      origin: this,
      override: PurchasesListProvider._internal(
        () => create()
          ..storeId = storeId
          ..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storeId: storeId,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PurchasesList, PurchasesPageData>
      createElement() {
    return _PurchasesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchasesListProvider &&
        other.storeId == storeId &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PurchasesListRef
    on AutoDisposeAsyncNotifierProviderRef<PurchasesPageData> {
  /// The parameter `storeId` of this provider.
  String? get storeId;

  /// The parameter `status` of this provider.
  String? get status;
}

class _PurchasesListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PurchasesList,
        PurchasesPageData> with PurchasesListRef {
  _PurchasesListProviderElement(super.provider);

  @override
  String? get storeId => (origin as PurchasesListProvider).storeId;
  @override
  String? get status => (origin as PurchasesListProvider).status;
}

String _$purchaseDetailHash() => r'a27ebd595ebc06a248f3e1a10a912172d8eea108';

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
